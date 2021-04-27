//
//  SubstrateService.m
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "SubstrateService.h"

@implementation SubstrateService

- (instancetype)initWithKeyring:(Keyring *)keyring
                  webViewRunner:(WebViewRunner *)webViewParam
                          block:(void (^)(void))onInitiatedBlock
                         jsCode:(NSString *)jsCode
{
    if (self = [super init]) {
        self.keyring = [[ServiceKeyring alloc] init];
        self.keyring.serviceRoot = self;
        self.setting = [[ServiceSetting alloc] init];
        self.setting.serviceRoot = self;
        self.account = [[ServiceAccount alloc] init];
        self.account.serviceRoot = self;
        self.tx = [[ServiceTx alloc] init];
        self.tx.serviceRoot = self;
        self.walletConnect = [[ServiceWalletConnect alloc] init];
        self.walletConnect.serviceRoot = self;
        self.webView = webViewParam ?:[[WebViewRunner alloc] init];
        self.keyrings = keyring;
        
        [self.webView launchWithKeyring:self.keyring keyringStorage:keyring block:onInitiatedBlock jsCode:jsCode];
    }
    return self;
}

@end
