//
//  WalletSDK.h
//  common
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import <Foundation/Foundation.h>
#import "SubstrateService.h"
#import "PolkawalletApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletSDK : NSObject
@property (nonatomic, strong) PolkawalletApi *api;
@property (nonatomic, strong) SubstrateService *service;
@property (nonatomic, strong) Keyring *keyring;
@property (nonatomic, assign) BOOL skip;

+ (instancetype)shareInstance;

- (void)connectNode;

@end

NS_ASSUME_NONNULL_END
