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

- (instancetype)initWithKeyring:(Keyring *)keyring
                  webViewRunner:(nullable WebViewRunner *)webViewParam
                         jsCode:(nullable NSString *)jsCode;

@end

NS_ASSUME_NONNULL_END
