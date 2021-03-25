//
//  WalletSDK.m
//  common
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import "WalletSDK.h"

@implementation WalletSDK

- (instancetype)initWithKeyring:(Keyring *)keyring
                  webViewRunner:(nullable WebViewRunner *)webViewParam
                         jsCode:(nullable NSString *)jsCode
{
    if (self = [super init]) {
        self.service = [[SubstrateService alloc] initWithKeyring:keyring
                                                   webViewRunner:webViewParam
                                                           block:^{
            [self.service.keyring injectKeyPairsToWebViewWithKeyring:keyring successHandler:^(id  _Nullable data) {
                NSLog(@"webView准备完成----%@", data);
            }];
            
            [self.api.keyring updatePubKeyIconsMapWithKeyring:keyring pubKey:nil];
        }
                                                          jsCode:jsCode];
        self.api = [[PolkawalletApi alloc] initWithService:self.service];
    }
    return self;
}

@end
