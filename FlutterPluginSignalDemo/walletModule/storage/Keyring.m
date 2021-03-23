//
//  Keyring.m
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "Keyring.h"
#import "KeyringStorage.h"
#import "LocalStorage.h"

@interface Keyring ()

@end

@implementation Keyring

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.store = [[KeyringPrivateStore alloc] init];
    }
    return self;
}

- (int)ss58
{
    return self.store.ss58;
}

- (void)setSs58:(int)ss58
{
    self.store.ss58 = ss58;
}

- (KeyPairData *)current
{
    return [[KeyPairData alloc] init];
}

- (void)setCurrent:(KeyPairData *)current
{
    self.store.currentPubKey = current.pubKey;
}

- (NSMutableArray *)keyPairs
{
    return self.store.list;
}

- (NSMutableArray *)externals
{
    return self.store.externals;
}

- (NSMutableArray *)contacts
{
    return self.store.contacts;
}

- (NSMutableArray<KeyPairData *> *)allAccounts
{
    NSMutableArray *array = self.keyPairs;
    [array addObjectsFromArray:self.externals];
    return [self toModelArrayWithArray:array];
}

- (NSMutableArray<KeyPairData *> *)allWithContacts
{
    NSMutableArray *array = self.keyPairs;
    [array addObjectsFromArray:self.contacts];
    return [self toModelArrayWithArray:array];
}

- (NSMutableArray<KeyPairData *> *)optionals
{
    NSMutableArray<KeyPairData *> *array = [self toModelArrayWithArray:self.keyPairs];
    for (int i = (int)array.count - 1; i >=0; i--) {
        KeyPairData *data = array[i];
        if (data.pubKey == self.current.pubKey) {
            [array removeObject:data];
        }
    }
    return array;
}

- (NSMutableArray<KeyPairData *> *)toModelArrayWithArray:(NSMutableArray *)array
{
    NSMutableArray<KeyPairData *> *modelArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        [modelArray addObject:[KeyPairData modelWithDictionary:dict error:nil]];
    }
    return modelArray;
}

@end

@interface KeyringPrivateStore ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *iconsMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary *> *indicesMap;

@end

@implementation KeyringPrivateStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ss58List = @[@0, @2, @7, @42];
        [LocalStorage shareInstance];
        [self loadKeyPairsFromStorage];
    }
    return self;
}

- (void)setCurrentPubKey:(NSString *)currentPubKey
{
    [[KeyringStorage shareInstance].storage setObject:currentPubKey forKey:@"currentPubKey"];
}

- (NSString *)currentPubKey
{
    return [KeyringStorage shareInstance].currentPubKey;
}

- (NSMutableArray *)list
{
    return [self formatAccountWithLs:[KeyringStorage shareInstance].keyPairs.mutableCopy];
}

- (NSMutableArray *)externals
{
    NSMutableArray *array = [KeyringStorage shareInstance].contacts.mutableCopy;
    for (int i = (int)array.count - 1; i >=0; i--) {
        if (![((NSDictionary *)array[i]).allKeys containsObject:@"observation"]) {
            [array removeObject:array[i]];
        }
    }
    return [self formatAccountWithLs:array];
}

- (NSMutableArray *)contacts
{
    return [self formatAccountWithLs:[KeyringStorage shareInstance].contacts.mutableCopy];
}

- (NSMutableArray *)formatAccountWithLs:(NSMutableArray *)ls
{
    for (NSDictionary *dict in ls) {
        NSString *networkSS58 = [NSString stringWithFormat:@"%d", self.ss58];
        if ([dict.allKeys containsObject:@"pubKey"]) {
            if ([self.pubKeyAddressMap.allKeys containsObject:networkSS58]) {
                if (self.pubKeyAddressMap[networkSS58][dict[@"pubKey"]]) {
                    [dict setValue:self.pubKeyAddressMap[networkSS58][dict[@"pubKey"]] forKey:@"address"];
                }
            }
            [dict setValue:self.iconsMap[dict[@"pubKey"]] forKey:@"icon"];
            [dict setValue:self.indicesMap[dict[@"pubKey"]] forKey:@"indexInfo"];
        }
    }
    return ls;
}

- (void)loadKeyPairsFromStorage
{
    NSMutableArray<NSDictionary<NSString *, id> *> *ls =[LocalStorage shareInstance].getAccountList;
    if (ls.count) {
        for (int i = (int)ls.count - 1; i >=0; i--) {
            NSDictionary<NSString *, id> *dict = ls[i];
            // delete all storageOld data
            [[LocalStorage shareInstance] removeAccountWithPubKey:dict[@"pubKey"]];
            if (dict[@"mnemonic"] || dict[@"rawSeed"]) {
                [dict setValue:nil forKey:@"mnemonic"];
                [dict setValue:nil forKey:@"rawSeed"];
            }
            // retain accounts from storageOld
            bool exist = false;
            for (NSDictionary *mDict in [KeyringStorage shareInstance].keyPairs) {
                if (mDict[@"pubKey"] == dict[@"pubKey"]) {
                    exist = true;
                    break;
                }
            }
            if (exist) {
                [ls removeObject:dict];
            }
        }
        
        NSMutableArray *pairs = [KeyringStorage shareInstance].keyPairs.mutableCopy;
        [pairs addObjectsFromArray:ls];
        [[KeyringStorage shareInstance].storage setObject:pairs forKey:@"keyPairs"];
        
        // load current account pubKey
        NSString *curr = [LocalStorage shareInstance].getCurrentAccount;
        if (curr.length != 0 && curr) {
            [self setCurrentPubKey:curr];
            [[LocalStorage shareInstance] setCurrentAccountWithPubKey:@""];
        }
        
        // and move all encrypted seeds to new storage
        [self migrateSeeds];
    }
}

- (void)updatePubKeyAddressMapWithData:(NSDictionary<NSString *, NSDictionary *> *)data
{
    self.pubKeyAddressMap = data.mutableCopy;
}

- (void)migrateSeeds
{
    NSArray<NSDictionary *> *res = @[[[LocalStorage shareInstance] getSeedsWithSeedType:@"mnemonic"], [[LocalStorage shareInstance] getSeedsWithSeedType:@"rawSeed"]];
    if (res[0].allKeys.count) {
        NSMutableDictionary *dict = [KeyringStorage shareInstance].encryptedMnemonics.mutableCopy;
        [dict addEntriesFromDictionary:res[0]];
        [[KeyringStorage shareInstance].storage setObject:dict forKey:@"encryptedMnemonics"];
        [[LocalStorage shareInstance] setSeedsWithSeedType:@"mnemonic" value:@{}];
    }
    if (res[1].allKeys.count) {
        NSMutableDictionary *dict = [KeyringStorage shareInstance].encryptedRawSeeds.mutableCopy;
        [dict addEntriesFromDictionary:res[1]];
        [[KeyringStorage shareInstance].storage setObject:dict forKey:@"encryptedRawSeeds"];
        [[LocalStorage shareInstance] setSeedsWithSeedType:@"rawSeed" value:@{}];
    }
}


@end
