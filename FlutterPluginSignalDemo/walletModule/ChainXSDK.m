//
//  WalletSDK.m
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import "ChainXSDK.h"

@implementation ChainXSDK

- (instancetype)initWithKeyring:(ServiceKeyring *)keyringStorage
                  webViewRunner:(WebViewRunner *)webViewParam
                         jsCode:(NSString *)jsCode
{
    if (self = [super init]) {
        self.service = [[SubstrateService alloc] initWithKeyring:keyringStorage
                                                   webViewRunner:webViewParam
                                                           block:^{
            
        }
                                                          jsCode:jsCode];
    }
    return self;
}

@end
