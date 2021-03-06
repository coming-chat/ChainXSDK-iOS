//
//  Keyring.m
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "Keyring.h"
#import "KeyringStorage.h"
#import "LocalStorage.h"
#import "NSObject+jsonExtention.h"
#import "AESCrypt.h"
#import "NSDictionary+MTLManipulationAdditions.h"

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
    if (self.allAccounts.count > 0) {
        for (KeyPairData *data in self.allAccounts) {
            if ([data.pubKey isEqualToString:self.store.currentPubKey]) {
                return data;
            }
        }
    }
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
        if ([data.pubKey isEqualToString:self.current.pubKey]) {
            [array removeObject:data];
        }
    }
    return array;
}

- (NSMutableArray<KeyPairData *> *)toModelArrayWithArray:(NSMutableArray *)array
{
    NSMutableArray<KeyPairData *> *modelArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dict in array) {
        [modelArray addObject:[KeyPairData modelWithDictionary:dict error:nil]];
    }
    return modelArray;
}

@end

@interface KeyringPrivateStore ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *iconsMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary *> *indicesMap;

@end

@implementation KeyringPrivateStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ss58List = @[@0, @2, @7, @42, @44];
        self.pubKeyAddressMap = @{}.mutableCopy;
        self.iconsMap = @{}.mutableCopy;
        self.indicesMap = @{}.mutableCopy;
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
        if (![((NSMutableDictionary *)array[i]).allKeys containsObject:@"observation"]) {
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
    for (int i = 0 ; i < ls.count; i++) {
        NSString *networkSS58 = [NSString stringWithFormat:@"%d", self.ss58];
        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] initWithDictionary:ls[i]];
        if ([mDict.allKeys containsObject:@"pubKey"]) {
            if ([self.pubKeyAddressMap.allKeys containsObject:networkSS58]) {
                if (self.pubKeyAddressMap[networkSS58][mDict[@"pubKey"]]) {
                    [mDict setValue:self.pubKeyAddressMap[networkSS58][mDict[@"pubKey"]] forKey:@"address"];
                }
            }
            [mDict setValue:self.iconsMap[mDict[@"pubKey"]] forKey:@"icon"];
            [mDict setValue:self.indicesMap[mDict[@"pubKey"]] forKey:@"indexInfo"];
        }
        ls[i] = mDict;
    }
    return ls;
}

- (void)loadKeyPairsFromStorage
{
    NSMutableArray<NSMutableDictionary<NSString *, id> *> *ls =[LocalStorage shareInstance].getAccountList;
    if (ls.count) {
        for (int i = (int)ls.count - 1; i >=0; i--) {
            NSMutableDictionary<NSString *, id> *dict = ls[i];
            // delete all storageOld data
            [[LocalStorage shareInstance] removeAccountWithPubKey:dict[@"pubKey"]];
            if (dict[@"mnemonic"] || dict[@"rawSeed"]) {
                [dict setValue:nil forKey:@"mnemonic"];
                [dict setValue:nil forKey:@"rawSeed"];
            }
            // retain accounts from storageOld
            bool exist = false;
            for (NSMutableDictionary *mDict in [KeyringStorage shareInstance].keyPairs) {
                if ([mDict[@"pubKey"] isEqualToString:dict[@"pubKey"]]) {
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

- (void)updatePubKeyAddressMapWithData:(NSMutableDictionary<NSString *, NSMutableDictionary *> *)data
{
    self.pubKeyAddressMap = data.mutableCopy;
}

- (void)updateIconsMapWithData:(NSMutableDictionary<NSString *, NSString *> *)data
{
    [self.iconsMap addEntriesFromDictionary:data];
}

- (void)updateIndicesMapWithData:(NSMutableDictionary<NSString *, NSMutableDictionary *> *)data
{
    self.indicesMap = data.mutableCopy;
}

- (void)addAccountWithAcc:(NSMutableDictionary *)acc
{
    NSMutableArray *array = [KeyringStorage shareInstance].keyPairs.mutableCopy;
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        if ([dict[@"pubKey"] isEqualToString:acc[@"pubKey"]]) {
            [array removeObject:dict];
            break;
        }
    }
    [array addObject:acc];
    [[KeyringStorage shareInstance].storage setValue:array.copy forKey:@"keyPairs"];
    [self setCurrentPubKey:acc[@"pubKey"]];
}

- (void)addContactWithAcc:(NSMutableDictionary *)acc
{
    NSMutableArray *array = [KeyringStorage shareInstance].contacts.mutableCopy;
    [array addObject:acc];
    [[KeyringStorage shareInstance].storage setValue:array.copy forKey:@"contacts"];
    if ([acc.allKeys containsObject:@"observation"]) {
        [self setCurrentPubKey:acc[@"pubKey"]];
    }
}

- (void)updateAccountWithAcc:(NSMutableDictionary *)acc
                  isExternal:(BOOL)isExternal
{
    if (isExternal) {
        [self updateContactWithAcc:acc];
    }else{
        [self updateKeyPairWithAcc:acc];
    }
}

- (void)updateKeyPairWithAcc:(NSMutableDictionary *)acc
{
    NSMutableArray *array = [KeyringStorage shareInstance].keyPairs.mutableCopy;
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        if ([dict[@"pubKey"] isEqualToString:acc[@"pubKey"]]) {
            dict = acc;
            break;
        }
    }
    [[KeyringStorage shareInstance].storage setValue:array.copy forKey:@"keyPairs"];
}

- (void)updateContactWithAcc:(NSMutableDictionary *)acc
{
    NSMutableArray *array = [KeyringStorage shareInstance].contacts.mutableCopy;
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        if ([dict[@"pubKey"] isEqualToString:acc[@"pubKey"]]) {
            dict = acc;
            break;
        }
    }
    [[KeyringStorage shareInstance].storage setValue:array.copy forKey:@"contacts"];
}

- (void)deleteAccountWithPubKey:(NSString *)pubKey
{
    [self deleteKeyPairWithPubKey:pubKey];
    
    NSMutableDictionary *dict = [KeyringStorage shareInstance].encryptedMnemonics.mutableCopy;
    if ([dict.allKeys containsObject:pubKey]) {
        [dict removeObjectForKey:pubKey];
    }
    [[KeyringStorage shareInstance].storage setValue:dict.copy forKey:@"encryptedMnemonics"];
    NSMutableDictionary *dict2 = [KeyringStorage shareInstance].encryptedRawSeeds.mutableCopy;
    if ([dict2.allKeys containsObject:pubKey]) {
        [dict2 removeObjectForKey:pubKey];
    }
    [[KeyringStorage shareInstance].storage setValue:dict2.copy forKey:@"encryptedRawSeeds"];
}

- (void)deleteKeyPairWithPubKey:(NSString *)pubKey
{
    NSMutableArray *array = [KeyringStorage shareInstance].contacts.mutableCopy;
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        if ([dict[@"pubKey"] isEqualToString:pubKey]) {
            [array removeObject:dict];
            break;
        }
    }
    [[KeyringStorage shareInstance].storage setValue:array.copy forKey:@"contacts"];
    
    if (array.count > 0) {
        [self setCurrentPubKey:array[0][@"pubKey"]];
    }else if (self.externals.count > 0){
        [self setCurrentPubKey:self.externals[0][@"pubKey"]];
    }else{
        [self setCurrentPubKey:@""];
    }
}

- (void)deleteContactWithPubKey:(NSString *)pubKey
{
    NSMutableArray *array = [KeyringStorage shareInstance].contacts.mutableCopy;
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dict = array[i];
        if ([dict[@"pubKey"] isEqualToString:pubKey]) {
            [array removeObject:dict];
            break;
        }
    }
    [[KeyringStorage shareInstance].storage setValue:array.copy forKey:@"contacts"];
}

- (void)encryptSeedAndSaveWithPubKey:(NSString *)pubKey
                                seed:(NSString *)seed
                            seedType:(NSString *)seedType
                            password:(NSString *)password
{
    NSString *key = passwordToEncryptKey(password);
    NSString *encrypted = [AESCrypt encrypt:seed password:key];
    NSMutableDictionary *store = [[LocalStorage shareInstance] getSeedsWithSeedType:seedType];
    [store setValue:encrypted forKey:pubKey];
    if ([seedType isEqualToString:@"mnemonic"]) {
        NSMutableDictionary *mnemonics = [[KeyringStorage shareInstance] encryptedMnemonics];
        [mnemonics mtl_dictionaryByAddingEntriesFromDictionary:store];
        [[KeyringStorage shareInstance].storage setValue:mnemonics forKey:@"encryptedMnemonics"];
    }else if ([seedType isEqualToString:@"rawSeed"]){
        NSMutableDictionary *seeds = [[KeyringStorage shareInstance] encryptedRawSeeds];
        [seeds mtl_dictionaryByAddingEntriesFromDictionary:store];
        [[KeyringStorage shareInstance].storage setValue:seeds forKey:@"encryptedRawSeeds"];
    }else{
        //TODO::处理seedType不识别情况
        
    }
}

- (void)updateEncryptedSeedWithPubKey:(NSString *)pubKey
                              passOld:(NSString *)passOld
                              passNew:(NSString *)passNew
{
    NSMutableDictionary<NSString *, id> *seed = [self getDecryptedSeedWithPubKey:pubKey password:passOld];
    [self encryptSeedAndSaveWithPubKey:pubKey seed:seed[@"seed"] seedType:seed[@"type"] password:passNew];
}

- (NSMutableDictionary<NSString *, id> *)getDecryptedSeedWithPubKey:(NSString *)pubKey
                                                    password:(NSString *)password
{
    NSString *key = passwordToEncryptKey(password);
    if ([[[KeyringStorage shareInstance] encryptedMnemonics].allKeys containsObject:pubKey]) {
        NSString *mnemonic = [[KeyringStorage shareInstance] encryptedMnemonics][pubKey];
        NSMutableDictionary *res = @{@"type": @"mnemonic"}.mutableCopy;
        [res setValue:[AESCrypt decrypt:mnemonic password:key] forKey:@"seed"];
        return res;
    }
    if ([[[KeyringStorage shareInstance] encryptedRawSeeds].allKeys containsObject:pubKey]) {
        NSString *rawSeed = [[KeyringStorage shareInstance] encryptedRawSeeds][pubKey];
        NSMutableDictionary *res = @{@"type": @"rawSeed"}.mutableCopy;
        [res setValue:[AESCrypt decrypt:rawSeed password:key] forKey:@"seed"];
        return res;
    }
    return nil;
}

- (BOOL)checkSeedExistWithKeyType:(NSString *)keyType
                           pubKey:(NSString *)pubKey
{
    if ([keyType isEqualToString:@"mnemonic"]) {
        return [[[KeyringStorage shareInstance] encryptedMnemonics].allKeys containsObject:pubKey];
    }else if ([keyType isEqualToString:@"rawSeed"]){
        return [[[KeyringStorage shareInstance] encryptedRawSeeds].allKeys containsObject:pubKey];
    }else{
        return NO;
    }
}

- (void)migrateSeeds
{
    NSArray<NSMutableDictionary *> *res = @[[[LocalStorage shareInstance] getSeedsWithSeedType:@"mnemonic"], [[LocalStorage shareInstance] getSeedsWithSeedType:@"rawSeed"]];
    if (res[0].allKeys.count) {
        NSMutableDictionary *dict = [KeyringStorage shareInstance].encryptedMnemonics.mutableCopy;
        [dict addEntriesFromDictionary:res[0]];
        [[KeyringStorage shareInstance].storage setObject:dict forKey:@"encryptedMnemonics"];
        [[LocalStorage shareInstance] setSeedsWithSeedType:@"mnemonic" value:@{}.mutableCopy];
    }
    if (res[1].allKeys.count) {
        NSMutableDictionary *dict = [KeyringStorage shareInstance].encryptedRawSeeds.mutableCopy;
        [dict addEntriesFromDictionary:res[1]];
        [[KeyringStorage shareInstance].storage setObject:dict forKey:@"encryptedRawSeeds"];
        [[LocalStorage shareInstance] setSeedsWithSeedType:@"rawSeed" value:@{}.mutableCopy];
    }
}

- (void)resetStore
{
    [[KeyringStorage shareInstance] resetStorage];
}

@end
