//
//  WalletSDK.m
//  common
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import "WalletSDK.h"

@implementation WalletSDK

+ (instancetype)shareInstance
{
    static WalletSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithKeyring:nil webViewRunner:nil jsCode:nil];
    });
    return instance;
}

- (instancetype)initWithKeyring:(Keyring *)keyring
                  webViewRunner:(nullable WebViewRunner *)webViewParam
                         jsCode:(nullable NSString *)jsCode
{
    if (self = [super init]) {
        self.keyring = [[Keyring alloc] init];
        keyring = self.keyring;
        self.service = [[SubstrateService alloc] initWithKeyring:keyring
                                                   webViewRunner:webViewParam
                                                           block:^{
            [self.service.keyring injectKeyPairsToWebViewWithKeyring:keyring successHandler:^(id  _Nullable data) {
                NSLog(@"webView准备完成----%@", data);
            }];
            
            [self.api.keyring updatePubKeyIconsMapWithKeyring:keyring pubKey:nil];
            
            [self connectNode];
        }
                                                          jsCode:jsCode];
        self.api = [[PolkawalletApi alloc] initWithService:self.service];
    }
    return self;
}

- (void)connectNode
{
    NetworkParams *params = [[NetworkParams alloc] init];
    params.name = @"ChainX";
    //主网
//    params.endpoint = @"wss://chainx.elara.patract.io";
//    params.ss58 = 44;
    //测试网
    params.endpoint = @"wss://testnet.chainx.org/ws";
    params.ss58 = 42;
    [WalletSDK shareInstance].keyring.store.ss58 = (int)params.ss58;
    [[WalletSDK shareInstance].api connectNodeWithKeyringStorage:self.keyring nodes:@[params].mutableCopy successHandler:^(NetworkParams * _Nonnull data) {
        
    }];
}

@end
