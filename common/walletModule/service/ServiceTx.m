//
//  ServiceTx.m
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "ServiceTx.h"
#import "SubstrateService.h"
#import "NSObject+jsonExtention.h"

@implementation ServiceTx

- (void)estimateFeesWithTxInfo:(NSDictionary *)txInfo
                        params:(NSString *)params
                successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.serviceRoot.webView evalJavascriptWithCode:[NSString stringWithFormat:@"keyring.txFeeEstimate(api, %@, %@)", jsonEncodeWithValue(txInfo), params] successHandler:successHandler];
}

- (void)signAndSendWithTxInfo:(NSDictionary *)txInfo
                       params:(NSString *)params
                     password:(NSString *)password
               onStatusChange:(void (^ _Nullable)(_Nullable id data))onStatusChange
               successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    NSString *msgId = [NSString stringWithFormat:@"onStatusChange%ld", (long)self.serviceRoot.webView.evalJavascriptUID];
    [self.serviceRoot.webView addMsgHandlerWithChannel:msgId onMessage:onStatusChange];
    NSString *code = [NSString stringWithFormat:@"keyring.sendTx(api, %@, %@, \"%@\", \"%@\")", jsonEncodeWithValue(txInfo), params, password, msgId];
    [self.serviceRoot.webView evalJavascriptWithCode:code successHandler:^(id  _Nullable data) {
        [self.serviceRoot.webView removeMsgHandlerWithChannel:msgId];
        successHandler(data);
    }];
}


@end
