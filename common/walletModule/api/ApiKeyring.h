//
//  ApiKeyring.h
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import <Foundation/Foundation.h>
@class PolkawalletApi;
@class ServiceKeyring;
@class Keyring;
@class KeyPairData;
@class SeedBackupData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KeyType) {
    mnemonic = 0,
    rawSeed,
    keystore,
};

typedef NS_ENUM(NSUInteger, CryptoType) {
    sr25519 = 0,
    ed25519,
};

@interface ApiKeyring : NSObject
@property (nonatomic, strong) PolkawalletApi *apiRoot;
@property (nonatomic, strong) ServiceKeyring *service;

- (void)generateMnemonicWithSuccessHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)importAccountWithKeyType:(KeyType)keyType
                             key:(NSString *)key
                            name:(NSString *)name
                        password:(NSString *)password
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
                  failureHandler:(void (^ _Nullable)(_Nullable id data))failureHandler;

// Add account to local storage.
- (NSMutableDictionary *)addAccountWithKeyring:(Keyring *)keyring
                                       keyType:(NSString *)keyType
                                           acc:(NSMutableDictionary *)acc
                                      password:(NSString *)password;

- (void)addContactWithKeyring:(Keyring *)keyring
                          acc:(NSMutableDictionary *)acc
               successHandler:(void (^ _Nullable)(NSMutableDictionary *data))successHandler;

- (void)updatePubKeyAddressMapWithKeyring:(Keyring *)keyring;

- (void)updatePubKeyIconsMapWithKeyring:(Keyring *)keyring
                                 pubKey:(nullable NSString *)pubKey;

- (void)updateIndicesMapWithKeyring:(Keyring *)keyring
                          addresses:(nullable NSMutableArray<NSString *> *)addresses;

// Decrypt and get the backup of seed.
- (SeedBackupData *)getDecryptedSeedWithKeyring:(Keyring *)keyring
                                       password:(NSString *)password;

// delete account from storage
- (void)deleteAccountWithKeyring:(Keyring *)keyring
                         account:(KeyPairData *)account;

// check password of account
- (void)checkPasswordWithAccount:(KeyPairData *)account
                        password:(NSString *)password
                  successHandler:(void (^)(BOOL result))successHandler;

// change password of account
- (void)changePasswordWithKeyring:(Keyring *)keyring
                          passOld:(NSString *)passOld
                          passNew:(NSString *)passNew
                   successHandler:(void (^ _Nullable)(KeyPairData *data))successHandler;

// change name of account
- (KeyPairData *)changeNameWithKeyring:(Keyring *)keyring
                                  name:(NSString *)name;

// Check if derive path is valid, return [null] if valid,
// and return error message if invalid.
- (void)checkDerivePathWithSeed:(NSString *)seed
                           path:(NSString *)path
                     cryptoType:(NSString *)cryptoType
                 successHandler:(void (^ _Nullable)(NSString *data))successHandler;

// Open a new webView for a DApp,
// sign extrinsic or msg for the DApp.
- (void)signAsExtensionWithPassword:(NSString *)password
               signAsExtensionParam:(NSMutableDictionary *)signAsExtensionParam
                     successHandler:(void (^ _Nullable)(NSMutableDictionary *data))successHandler;

- (void)signatureVerifyWithMessage:(NSString *)message
                         signature:(NSString *)signature
                           address:(NSString *)address
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

@end

NS_ASSUME_NONNULL_END
