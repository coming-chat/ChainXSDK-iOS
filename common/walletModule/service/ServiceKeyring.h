//
//  ServiceKeyring.h
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import "ApiKeyring.h"
@class SubstrateService;
@class Keyring;

NS_ASSUME_NONNULL_BEGIN

@interface ServiceKeyring : NSObject
@property (nonatomic, weak) SubstrateService *serviceRoot;

- (void)getPubKeyAddressMapWithKeyPairs:(NSMutableArray *)keyPairs
                               ss58List:(NSMutableArray *)ss58
                         successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)getPubKeyIconsMapWithPubKeys:(NSMutableArray *)pubKeys
                      successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)injectKeyPairsToWebViewWithKeyring:(Keyring *)keyring
                            successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (NSDictionary *)updateKeyPairMetaDataWithAcc:(NSDictionary *)acc
                                          name:(NSString *)name;

// Generate a set of new mnemonic.
- (void)generateMnemonicWithSuccessHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

// Import account from mnemonic/rawSeed/keystore.
// param [cryptoType] can be `sr25519`(default) or `ed25519`.
// return [null] if import failed.
- (void)importAccountWithKeyType:(KeyType)keyType
                             key:(NSString *)key
                            name:(NSString *)name
                        password:(NSString *)password
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)checkPasswordWithPubKey:(NSString *)pubKey
                           pass:(NSString *)pass
                 successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)changePasswordWithPubKey:(NSString *)pubKey
                         passOld:(NSString *)passOld
                         passNew:(NSString *)passNew
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

// Check if derive path is valid, return [null] if valid,
// and return error message if invalid.
- (void)checkDerivePathWithSeed:(NSString *)seed
                           path:(NSString *)path
                 successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)signAsExtensionWithPassword:(NSString *)password
                               args:(NSDictionary *)args
                     successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

// Open a new webView for a DApp,
// sign extrinsic or msg for the DApp.
- (void)signatureVerifyWithMessage:(NSString *)message
                         signature:(NSString *)signature
                           address:(NSString *)address
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

@end

NS_ASSUME_NONNULL_END
