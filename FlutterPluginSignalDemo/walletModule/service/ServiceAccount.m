//
//  ServiceAccount.m
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "ServiceAccount.h"
#import "SubstrateService.h"
#import "NSObject+jsonExtention.h"

@implementation ServiceAccount

- (void)encodeAddressWithPubKeys:(NSMutableArray<NSString *> *)pubKeys
                        ss58List:(NSMutableArray *)ss58List
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.encodeAddress(%@, %@)", jsonEncodeWithValue(pubKeys), jsonEncodeWithValue(ss58List)]
                                      successHandler:successHandler];
}

- (void)decodeAddressWithAddresses:(NSMutableArray<NSString *> *)addresses
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.decodeAddress(%@)", jsonEncodeWithValue(addresses)]
                                      successHandler:successHandler];
}

- (void)queryBalanceWithAddress:(NSString *)address
                 successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.getBalance(api, \"%@\")", address]
                                      successHandler:successHandler];
}

- (void)queryIndexInfoWithAddresses:(NSMutableArray *)addresses
                     successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.getAccountIndex(api, %@)", jsonEncodeWithValue(addresses)]
                                      successHandler:successHandler];
}

- (void)queryAddressWithAccountIndex:(NSString *)index
                                ss58:(int)ss58
                      successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.queryAddressWithAccountIndex(api, \"%@\", %d)", index, ss58]
                                      successHandler:successHandler];
}

- (void)getPubKeyIconsWithKeys:(NSMutableArray<NSString *> *)keys
                successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.genPubKeyIcons(%@)", jsonEncodeWithValue(keys)]
                                      successHandler:successHandler];
}

- (void)getAddressIconsWithAddresses:(NSMutableArray *)addresses
                      successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.genIcons(%@)", jsonEncodeWithValue(addresses)]
                                      successHandler:successHandler];
}

@end
