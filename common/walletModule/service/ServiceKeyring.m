//
//  ServiceKeyring.m
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "ServiceKeyring.h"
#import "SubstrateService.h"
#import "NSObject+jsonExtention.h"
#import "NSDictionary+MTLManipulationAdditions.h"

@implementation ServiceKeyring

- (void)getPubKeyAddressMapWithKeyPairs:(NSMutableArray *)keyPairs
                               ss58List:(NSMutableArray *)ss58
                         successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    NSMutableArray<NSString *> *pubKeys = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dict in keyPairs) {
        [pubKeys addObject:dict[@"pubKey"]];
    }
    [self.serviceRoot.account encodeAddressWithPubKeys:pubKeys ss58List:ss58 successHandler:successHandler];
}

- (void)getPubKeyIconsMapWithPubKeys:(NSMutableArray *)pubKeys
                      successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.account getPubKeyIconsWithKeys:pubKeys successHandler:successHandler];
}

- (void)injectKeyPairsToWebViewWithKeyring:(Keyring *)keyring
                      successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    if (keyring.store.list.count) {
        [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"keyring.initKeys(%@, %@)", jsonEncodeWithValue(keyring.store.list), jsonEncodeWithValue(keyring.store.ss58List)] successHandler:^(id  _Nullable data) {
            NSMutableDictionary<NSString *, NSMutableDictionary *> *res = data;
            [self getPubKeyAddressMapWithKeyPairs:keyring.store.contacts ss58List:keyring.store.ss58List.mutableCopy successHandler:^(id  _Nullable data) {
                NSArray *keys;
                int i, count;
                id key, value;
                keys = [res allKeys];
                count = (int)[keys count];
                for (i = 0; i < count; i++)
                {
                    key = [keys objectAtIndex: i];
                    value = [res objectForKey: key];
                    [res[key] mtl_dictionaryByAddingEntriesFromDictionary:data[key]];
                }
                [keyring.store updatePubKeyAddressMapWithData:res];
                successHandler(res);
            }];
        }];
    }else{
        successHandler(nil);
    }
}

- (NSMutableDictionary *)updateKeyPairMetaDataWithAcc:(NSMutableDictionary *)acc
                                          name:(NSString *)name
{
    [acc setValue:name forKey:@"name"];
    [acc[@"meta"] setValue:name forKey:@"name"];
    if (![((NSMutableDictionary *)acc[@"meta"]).allKeys containsObject:@"whenCreated"]) {
        [acc[@"meta"] setValue:@(NSDate.date.timeIntervalSince1970) forKey:@"whenCreated"];
    }else{
        if (!acc[@"meta"][@"whenCreated"]) {
            [acc[@"meta"] setValue:@(NSDate.date.timeIntervalSince1970) forKey:@"whenCreated"];
        }
    }
    [acc[@"meta"] setValue:@(NSDate.date.timeIntervalSince1970) forKey:@"whenEdited"];
    return acc;
}

// Generate a set of new mnemonic.
- (void)generateMnemonicWithSuccessHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:@"keyring.gen()" successHandler:^(id  _Nullable data) {
        successHandler(data[@"mnemonic"]);
    }];
}

// Import account from mnemonic/rawSeed/keystore.
// param [cryptoType] can be `sr25519`(default) or `ed25519`.
// return [null] if import failed.
- (void)importAccountWithKeyType:(KeyType)keyType
                             key:(NSString *)key
                            name:(NSString *)name
                        password:(NSString *)password
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    NSString *code = [NSString stringWithFormat:@"keyring.recover(\"%@\", \"%@\", \'%@%@\', \"%@\")", keyType == mnemonic ? @"mnemonic" : keyType == rawSeed ? @"rawSeed" : keyType == keystore ? @"keystore" : @"", @"sr25519", key, @"", password];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"r'\t|\n|\r'" options:NSRegularExpressionCaseInsensitive error:nil];
    code = [regex stringByReplacingMatchesInString:code options:0 range:NSMakeRange(0, [code length]) withTemplate:@""];
    
    [self.serviceRoot.webView evalJavascriptWithCode:code successHandler:^(id  _Nullable data) {
        NSMutableDictionary<NSString *, id> *acc = data;
        if (!acc) {
            successHandler(acc);
            return;
        }
        if ([acc.allKeys containsObject:@"error"]) {
            if (acc[@"error"]) {
                successHandler(acc);
                return;
            }
        }
        // add metadata to json
        [self updateKeyPairMetaDataWithAcc:acc name:name];
        successHandler(acc);
    }];
}

- (void)checkPasswordWithPubKey:(NSString *)pubKey
                           pass:(NSString *)pass
                 successHandler:(void (^)(BOOL data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"keyring.checkPassword(\"%@\", \"%@\")", pubKey, pass] successHandler:^(id  _Nullable data) {
        if (!data) {
            successHandler(NO);
        }
        successHandler(YES);
    }];
}

- (void)changePasswordWithPubKey:(NSString *)pubKey
                         passOld:(NSString *)passOld
                         passNew:(NSString *)passNew
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"keyring.changePassword(\"%@\", \"%@\", \"%@\")", pubKey, passOld, passNew] successHandler:successHandler];
}

// Check if derive path is valid, return [null] if valid,
// and return error message if invalid.
- (void)checkDerivePathWithSeed:(NSString *)seed
                           path:(NSString *)path
                 successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"keyring.checkDerivePath(\"%@\", \"%@\", \"%@\")", seed, path, @"sr25519"] successHandler:successHandler];
}

- (void)signAsExtensionWithPassword:(NSString *)password
                               args:(NSMutableDictionary *)args
                     successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    NSString *call = [args[@"msgType"] isEqualToString:@"pub(bytes.sign)"] ? @"signBytesAsExtension" : @"signTxAsExtension";
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"keyring.%@(api, \"%@\", %@)", call, password, jsonEncodeWithValue(args[@"request"])] successHandler:successHandler];
}

// Open a new webView for a DApp,
// sign extrinsic or msg for the DApp.
- (void)signatureVerifyWithMessage:(NSString *)message
                         signature:(NSString *)signature
                           address:(NSString *)address
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"keyring.verifySignature(\"%@\", \"%@\", \"%@\")", message, signature, address] successHandler:successHandler];
}

@end
