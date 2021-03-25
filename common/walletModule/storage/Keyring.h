//
//  Keyring.h
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import "KeyPairData.h"
@class KeyringPrivateStore;

NS_ASSUME_NONNULL_BEGIN

@interface Keyring : NSObject
@property (nonatomic, strong) KeyringPrivateStore *store;

@property (nonatomic, assign) int ss58;

@property (nonatomic, strong) KeyPairData *current;
@property (nonatomic, strong) NSMutableArray *keyPairs;
@property (nonatomic, strong) NSMutableArray *externals;
@property (nonatomic, strong) NSMutableArray *contacts;

@property (nonatomic, strong) NSMutableArray<KeyPairData *> *allAccounts;
@property (nonatomic, strong) NSMutableArray<KeyPairData *> *allWithContacts;
@property (nonatomic, strong) NSMutableArray<KeyPairData *> *optionals;

@end

@interface KeyringPrivateStore : NSObject
@property (nonatomic, strong) NSArray<NSNumber *> *ss58List;
@property (nonatomic, assign) int ss58;

@property (nonatomic, copy) NSString *currentPubKey;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *externals;
@property (nonatomic, strong) NSMutableArray *contacts;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary *> *pubKeyAddressMap;

- (void)updatePubKeyAddressMapWithData:(NSMutableDictionary<NSString *, NSMutableDictionary *> *)data;

- (void)updateIconsMapWithData:(NSMutableDictionary<NSString *, NSString *> *)data;

- (void)updateIndicesMapWithData:(NSMutableDictionary<NSString *, NSMutableDictionary *> *)data;

- (void)addAccountWithAcc:(NSMutableDictionary *)acc;

- (void)addContactWithAcc:(NSMutableDictionary *)acc;

- (void)updateAccountWithAcc:(NSMutableDictionary *)acc
                  isExternal:(BOOL)isExternal;

- (void)updateKeyPairWithAcc:(NSMutableDictionary *)acc;

- (void)updateContactWithAcc:(NSMutableDictionary *)acc;

- (void)deleteAccountWithPubKey:(NSString *)pubKey;

- (void)deleteKeyPairWithPubKey:(NSString *)pubKey;

- (void)deleteContactWithPubKey:(NSString *)pubKey;

- (void)encryptSeedAndSaveWithPubKey:(NSString *)pubKey
                                seed:(NSString *)seed
                            seedType:(NSString *)seedType
                            password:(NSString *)password;

- (void)updateEncryptedSeedWithPubKey:(NSString *)pubKey
                              passOld:(NSString *)passOld
                              passNew:(NSString *)passNew;

- (NSMutableDictionary<NSString *, id> *)getDecryptedSeedWithPubKey:(NSString *)pubKey
                                                    password:(NSString *)password;

- (BOOL)checkSeedExistWithKeyType:(NSString *)keyType
                           pubKey:(NSString *)pubKey;

@end

NS_ASSUME_NONNULL_END
