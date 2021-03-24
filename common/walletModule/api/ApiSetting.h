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

@end

NS_ASSUME_NONNULL_END
