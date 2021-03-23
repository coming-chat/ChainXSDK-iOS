//
//  WalletSDK.m
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import "WalletSDK.h"

@implementation WalletSDK

- (instancetype)initWithKeyring:(Keyring *)keyring
                  webViewRunner:(WebViewRunner *)webViewParam
                         jsCode:(NSString *)jsCode
{
    if (self = [super init]) {
        self.service = [[SubstrateService alloc] initWithKeyring:keyring
                                                   webViewRunner:webViewParam
                                                           block:^{
            [self.service.keyring injectKeyPairsToWebViewWithKeyring:keyring successHandler:nil];
            
        }
                                                          jsCode:jsCode];
    }
    return self;
}

@end
