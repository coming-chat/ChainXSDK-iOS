//
//  PolkawalletPlugin.h
//  common
//
//  Created by 杨钰棋 on 2021/3/26.
//

#import <Foundation/Foundation.h>
@class WalletSDK;

NS_ASSUME_NONNULL_BEGIN

@interface PolkawalletPlugin : NSObject
@property (nonatomic, strong) WalletSDK *sdk;

@end

NS_ASSUME_NONNULL_END
