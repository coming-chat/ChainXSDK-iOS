//
//  ApiAccount.h
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import <Foundation/Foundation.h>
#import "BalanceData.h"
@class PolkawalletApi;
@class ServiceAccount;

NS_ASSUME_NONNULL_BEGIN

@interface ApiAccount : NSObject
@property (nonatomic, strong) PolkawalletApi *apiRoot;
@property (nonatomic, strong) ServiceAccount *service;

@end

NS_ASSUME_NONNULL_END
