//
//  SubstrateService.h
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import "ServiceKeyring.h"
#import "ServiceSetting.h"
#import "ServiceAccount.h"
#import "ServiceTx.h"
#import "ServiceWalletConnect.h"
#import "WebViewRunner.h"
#import "Keyring.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubstrateService : NSObject
@property (nonatomic, strong) ServiceKeyring *keyring;
@property (nonatomic, strong) ServiceSetting *setting;
@property (nonatomic, strong) ServiceAccount *account;
@property (nonatomic, strong) ServiceTx *tx;
@property (nonatomic, strong) ServiceWalletConnect *walletConnect;
@property (nonatomic, strong) WebViewRunner *webView;
@property (nonatomic, strong) Keyring *keyrings;

- (instancetype)initWithKeyring:(ServiceKeyring *)keyringStorage
                  webViewRunner:(WebViewRunner *)webViewParam
                          block:(void(^)(void))onInitiatedBlock
                         jsCode:(NSString *)jsCode;

@end

NS_ASSUME_NONNULL_END
