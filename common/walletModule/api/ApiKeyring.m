//
//  ApiKeyring.m
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import "ApiKeyring.h"
#import "PolkawalletApi.h"
#import "ServiceKeyring.h"

@implementation ApiKeyring

- (void)generateMnemonicWithSuccessHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.service generateMnemonicWithSuccessHandler:successHandler];
}

- (void)importAccountWithKeyType:(KeyType)keyType
                             key:(NSString *)key
                            name:(NSString *)name
                        password:(NSString *)password
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
                  failureHandler:(void (^ _Nullable)(_Nullable id data))failureHandler
{
    [self.service importAccountWithKeyType:keyType key:key name:name password:password successHandler:^(id  _Nullable data) {
        if (!data) {
            successHandler(nil);
        }else{
            if ([((NSDictionary *)data).allKeys containsObject:@"error"]) {
                if (data[@"error"]) {
                    failureHandler(data[@"error"]);
                    return;
                }
            }
            successHandler(data);
        }
    }];
}

- (void)updatePubKeyAddressMapWithKeyring:(Keyring *)keyring
{
    NSMutableArray *ls = keyring.store.list;
    [ls addObjectsFromArray:keyring.store.contacts];
    [self.service getPubKeyAddressMapWithKeyPairs:ls ss58List:keyring.store.ss58List.mutableCopy successHandler:^(id  _Nullable data) {
        if (data) {
            if ([((NSDictionary *)data).allKeys containsObject:[NSString stringWithFormat:@"%d", keyring.store.ss58]]) {
                [keyring.store updatePubKeyAddressMapWithData:data];
            }
        }
    }];
}

- (void)updatePubKeyIconsMapWithKeyring:(Keyring *)keyring
                                 pubKey:(NSString *)pubKey
{
    NSMutableArray *ls = [[NSMutableArray alloc] init];
    if (pubKey.length != 0) {
        [ls addObject:pubKey];
    }else{
        for (NSDictionary *dict in keyring.keyPairs) {
            [ls addObject:dict[@"pubKey"]];
        }
        for (NSDictionary *dict in keyring.contacts) {
            [ls addObject:dict[@"pubKey"]];
        }
    }
    if (ls.count == 0) return;
    [self.service getPubKeyIconsMapWithPubKeys:ls successHandler:^(id  _Nullable data) {
        if (data) {
            NSDictionary *dict = [[NSDictionary alloc] init];
            for (NSArray *array in data) {
                [dict setValue:array[1] forKey:array[0]];
            }
            [keyring.store updatePubKeyAddressMapWithData:dict];
        }
    }];
    
}

@end
