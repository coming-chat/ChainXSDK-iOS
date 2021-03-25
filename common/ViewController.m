//
//  ViewController.m
//  common
//
//  Created by 杨钰棋 on 2021/3/3.
//

#import "ViewController.h"
//#import "WalletWebView.h"
#import "WebViewRunner.h"
#import "Keyring.h"
#import "WalletSDK.h"

@interface ViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WalletSDK *sdk;
@property (nonatomic, strong) Keyring *keyring;

@property (nonatomic, strong) NSDictionary *testAcc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self setUI2];
    
    [self initApi];
}



- (void)initApi
{
    self.keyring = [[Keyring alloc] init];
    self.sdk = [[WalletSDK alloc] initWithKeyring:self.keyring webViewRunner:nil jsCode:nil];
    
}

- (void)connect
{
    NetworkParams *params = [[NetworkParams alloc] init];
    params.name = @"Kusama";
    params.endpoint = @"wss://kusama-1.polkawallet.io:9944/";
    params.ss58 = 2;
    [self.sdk.service.webView connectNode:@[params] successHandler:^(id  _Nullable data) {
        NSLog(@"data == %@", data);
        
    }];
}

- (void)importAccount
{
    //mnemonic
//    [self.sdk.api.keyring importAccountWithKeyType:mnemonic
//                                               key:@"wing know chapter eight shed lens mandate lake twenty useless bless glory"
//                                              name:@"testName01"
//                                          password:@"a123456"
//                                    successHandler:^(id  _Nullable data) {
//        self.testAcc = [self.sdk.api.keyring addAccountWithKeyring:self.keyring keyType:@"mnemonic" acc:data password:@"a123456"];
//
//    } failureHandler:^(id  _Nullable data) {
//
//    }];
    //rawSeed
//    [self.sdk.api.keyring importAccountWithKeyType:rawSeed
//                                               key:@"Alice"
//                                              name:@"testName02"
//                                          password:@"a123456"
//                                    successHandler:^(id  _Nullable data) {
//        self.testAcc = [self.sdk.api.keyring addAccountWithKeyring:self.keyring
//                                                           keyType:@"mnemonic"
//                                                               acc:data
//                                                          password:@"a123456"];
//
//    } failureHandler:^(id  _Nullable data) {
//
//    }];
    //keystore
//    NSString *testJson = @"{\"pubKey\":\"0xa2d1d33cc490d34ccc6938f8b30430428da815a85bf5927adc85d9e27cbbfc1a\",\"address\":\"14gV68QsGAEUGkcuV5JA1hx2ZFTuKJthMFfnkDyLMZyn8nnb\",\"encoded\":\"G3BHvs9tVTSf1Qe02bcOGpj7vjLdgqyS+/s0/J3EfRMAgAAAAQAAAAgAAADpWTEOs5/06DmEZaeuoExpf9+y1xcUhIzmEr6dUxyl67VQRX2KNGVmTqq05/sEIUDPVeOqqLbjBEPaNRoC0lZTQlKM5u38lX4PzKivGHM9ZJkvtQxf7RAndN/vgfIX4X76gX60bqrUY8Qr2ZswtuPTeGVKQOD7y0GtoPOcR2RzFg6rs44NuugTR0UwA8HWTDkh0c/KOnUc1FJDb4rV\",\"encoding\":{\"content\":[\"pkcs8\",\"sr25519\"],\"type\":[\"scrypt\",\"xsalsa20-poly1305\"],\"version\":\"3\"},\"meta\": {\"name\":\"testName-3\",\"whenCreated\": 1598270113026,\"whenEdited\": 1598270113026}}";
//    [self.sdk.api.keyring importAccountWithKeyType:keystore
//                                               key:testJson
//                                              name:@"testName03"
//                                          password:@"a123456"
//                                    successHandler:^(id  _Nullable data) {
//        self.testAcc = [self.sdk.api.keyring addAccountWithKeyring:self.keyring
//                                                           keyType:@"mnemonic"
//                                                               acc:data
//                                                          password:@"a123456"];
//
//    } failureHandler:^(id  _Nullable data) {
//
//    }];
}

- (void)setUI
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 200, 100);
    [button setTitle:@"连接节点" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)setUI2
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 300, 200, 100);
    [button setTitle:@"导入账号通过助记词" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(importAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

@end
