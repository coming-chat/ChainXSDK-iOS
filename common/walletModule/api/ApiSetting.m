//
//  ApiSetting.m
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import "ApiSetting.h"
#import "PolkawalletApi.h"
#import "ServiceSetting.h"

@interface ApiSetting ()
@property (nonatomic, copy) NSString *msgChannel;

@end

@implementation ApiSetting

- (NSString *)msgChannel
{
    return @"BestNumber";
}

// query network const.
- (void)queryNetworkConstWithSuccessHandler:(void (^ _Nullable)(NSDictionary *data))successHandler
{
    [self.service queryNetworkConstWithSuccessHandler:successHandler];
}

// query network properties.
- (void)queryNetworkPropsWithSuccessHandler:(void (^ _Nullable)(NSDictionary *data))successHandler
{
    [self.service queryNetworkPropsWithSuccessHandler:successHandler];
}

// subscribe best number.
// @return [String] msgChannel, call unsubscribeMessage(msgChannel) to unsub.
- (void)subscribeBestNumberWithCallback:(void (^ _Nullable)(_Nullable id data))callback
                         successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.apiRoot subscribeMessageWithJSCall:@"api.derive.chain.bestNumber"
                                      params:@[].mutableCopy
                                     channel:self.msgChannel
                                    callback:callback
                              successHandler:successHandler];
}

- (void)unsubscribeBestNumber
{
    [self.apiRoot.service.webView unsubscribeMessageWithChannel:self.msgChannel];
}

@end
