//
//  ApiSetting.h
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import <Foundation/Foundation.h>
@class PolkawalletApi;
@class ServiceSetting;

NS_ASSUME_NONNULL_BEGIN

@interface ApiSetting : NSObject
@property (nonatomic, strong) PolkawalletApi *apiRoot;
@property (nonatomic, strong) ServiceSetting *service;

// query network const.
- (void)queryNetworkConstWithSuccessHandler:(void (^ _Nullable)(NSDictionary *data))successHandler;

// query network properties.
- (void)queryNetworkPropsWithSuccessHandler:(void (^ _Nullable)(NSDictionary *data))successHandler;

// subscribe best number.
// @return [String] msgChannel, call unsubscribeMessage(msgChannel) to unsub.
- (void)subscribeBestNumberWithCallback:(void (^ _Nullable)(_Nullable id data))callback
                         successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)unsubscribeBestNumber;

@end

NS_ASSUME_NONNULL_END
