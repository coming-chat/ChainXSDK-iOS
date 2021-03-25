//
//  ApiKeyring.m
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import "ApiKeyring.h"
#import "PolkawalletApi.h"
#import "ServiceKeyring.h"
#import <MTLJSONAdapter.h>

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

- (void)updateIndicesMapWithKeyring:(Keyring *)keyring
                          addresses:(NSMutableArray<NSString *> *)addresses
{
    NSMutableArray<NSString *> *ls = [[NSMutableArray alloc] init];
    if (addresses) {
        [ls addObjectsFromArray:addresses];
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (KeyPairData *data in keyring.allWithContacts) {
            [array addObject:data.address];
        }
        [ls addObjectsFromArray:array];
    }
    if (ls.count == 0) return;
    
    // get account indices from webView.
    [self.apiRoot.account queryIndexInfoWithAddresses:ls successHandler:^(NSMutableArray * _Nonnull list) {
        if (list) {
            NSDictionary *data = @{};
            for (NSDictionary *dict in list) {
                [data setValue:dict forKey:dict[@"accountId"]];
            }
            [keyring.store updateIndicesMapWithData:data];
        }
    }];
}

// Decrypt and get the backup of seed.
- (SeedBackupData *)getDecryptedSeedWithKeyring:(Keyring *)keyring
                           password:(NSString *)password
{
    NSDictionary<NSString *, id> *data = [keyring.store getDecryptedSeedWithPubKey:keyring.current.pubKey password:password];
    if (!data) return nil;
    if (![data.allKeys containsObject:@"seed"]) {
        [data setValue:@"wrong password" forKey:@"error"];
    }
    return [SeedBackupData modelWithDictionary:data error:nil];
}

// delete account from storage
- (void)deleteAccountWithKeyring:(Keyring *)keyring
                         account:(KeyPairData *)account
{
    if (account) {
        [keyring.store deleteAccountWithPubKey:account.pubKey];
    }
}

// check password of account
- (void)checkPasswordWithAccount:(KeyPairData *)account
                        password:(NSString *)password
                  successHandler:(void (^)(BOOL result))successHandler
{
    [self.service checkPasswordWithPubKey:account.pubKey pass:password successHandler:successHandler];
}

// change password of account
- (void)changePasswordWithKeyring:(Keyring *)keyring
                          passOld:(NSString *)passOld
                          passNew:(NSString *)passNew
                   successHandler:(void (^ _Nullable)(KeyPairData *data))successHandler
{
    KeyPairData *acc = keyring.current;
    // 1. change password of keyPair in webView
    [self.service changePasswordWithPubKey:acc.pubKey
                                   passOld:passOld
                                   passNew:passNew
                            successHandler:^(id  _Nullable data) {
        if (!data) {
            successHandler(nil);
            return;
        }
        // 2. if success in webView, then update encrypted seed in local storage.
        [keyring.store updateEncryptedSeedWithPubKey:acc.pubKey passOld:passOld passNew:passNew];
        
        // update json meta data
        [self.service updateKeyPairMetaDataWithAcc:(NSDictionary *)data name:acc.name];
        
        // update keyPair date in storage
        [keyring.store updateAccountWithAcc:(NSDictionary *)data isExternal:NO];
        successHandler([KeyPairData modelWithDictionary:data error:nil]);
    }];
}

// change name of account
- (KeyPairData *)changeNameWithKeyring:(Keyring *)keyring
                         name:(NSString *)name
{
    NSDictionary *json = [MTLJSONAdapter JSONDictionaryFromModel:keyring.current error:nil];
    // update json meta data
    [self.service updateKeyPairMetaDataWithAcc:json name:name];
    // update keyPair date in storage
    [keyring.store updateAccountWithAcc:json isExternal:NO];
    return [KeyPairData modelWithDictionary:json error:nil];
}

// Check if derive path is valid, return [null] if valid,
// and return error message if invalid.
- (void)checkDerivePathWithSeed:(NSString *)seed
                           path:(NSString *)path
                     cryptoType:(NSString *)cryptoType
                 successHandler:(void (^ _Nullable)(NSString *data))successHandler
{
    [self.service checkDerivePathWithSeed:seed
                                     path:path
                           successHandler:successHandler];
}

// Open a new webView for a DApp,
// sign extrinsic or msg for the DApp.
- (void)signAsExtensionWithPassword:(NSString *)password
               signAsExtensionParam:(NSDictionary *)signAsExtensionParam
                     successHandler:(void (^ _Nullable)(NSDictionary *data))successHandler
{
    [self.service signAsExtensionWithPassword:password
                                         args:signAsExtensionParam
                               successHandler:^(id  _Nullable data) {
        if (data) {
            NSDictionary *res = @{};
            [res setValue:signAsExtensionParam[@"id"] forKey:@"id"];
            [res setValue:data[@"signature"] forKey:@"signature"];
            successHandler(res);
        }
    }];
}

- (void)signatureVerifyWithMessage:(NSString *)message
                         signature:(NSString *)signature
                           address:(NSString *)address
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.service signatureVerifyWithMessage:message
                                   signature:signature
                                     address:address
                              successHandler:successHandler];
}

@end
