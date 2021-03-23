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

- (void)encodeAddressWithDecodeAddress:(NSMutableArray<NSString *> *)addresses
                        successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.decodeAddress(%@)", jsonEncodeWithValue(addresses)]
                                      successHandler:successHandler];
}

- (void)encodeAddressWithqueryBalance:(NSString *)address
                       successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"account.getBalance(api, \"%@\")", address]
                                      successHandler:successHandler];
}

@end
