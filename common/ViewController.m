//
//  ViewController.m
//  common
//
//  Created by 杨钰棋 on 2021/3/3.
//

#import "ViewController.h"
#import "WalletSDK.h"
#import <MTLJSONAdapter.h>
#import "NSObject+jsonExtention.h"

@interface ViewController ()<WKNavigationDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) WalletSDK *sdk;

@property (nonatomic, strong) NSDictionary *testAcc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self setUI2];
    
    [self setUI3];
    
    [self initApi];
}



- (void)initApi
{
    self.sdk = [WalletSDK shareInstance];
}

- (void)connect
{
//    NetworkParams *params = [[NetworkParams alloc] init];
//    params.name = @"ChainX";
//    params.endpoint = @"wss://chainx.elara.patract.io";
//    params.ss58 = 44;
//    self.sdk.keyring.store.ss58 = (int)params.ss58;
//    [self.sdk.service.webView connectNode:@[params] successHandler:^(id  _Nullable data) {
//        NSLog(@"data == %@", data);
//
//    }];
    
//    [self.sdk.service.webView evalJavascriptWithCode:@"runAccountTest()" successHandler:^(id  _Nullable data) {
//        NSLog(@"%@", data);
//
//    }];
    [[WalletSDK shareInstance].keyring.store resetStore];
    
}

- (void)importAccount
{
    //mnemonic
//    [self.sdk.api.keyring importAccountWithKeyType:mnemonic
//                                               key:@"wing know chapter eight shed lens mandate lake twenty useless bless glory"
//                                              name:@"testName01"
//                                          password:@"a123456"
//                                    successHandler:^(id  _Nullable data) {
//        self.testAcc = [self.sdk.api.keyring addAccountWithKeyring:self.sdk.keyring keyType:@"mnemonic" acc:data password:@"a123456"];
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
    //@"{\"address\":\"5TiRjQMDebfGB2txVYxtbgrwKfAawsqskxFrmWC3sLXFBMqn\",\"encoded\":\"6FOybGePm0IJGY613kFYQxinQ7cWS9CHB3gH30wJn6AAgAAAAQAAAAgAAABKP9Nfa4Jm1V2Ykd0zyFxHWFt1AJcOQ6GCkakbzhX18+YL7C0aMpr+EH4IzJN5eGnUYtaCaPXZgMth05HtAxp0oCkCIfiYeyGtD8d3hePEmf4gPzD7G8luB5IE+eOSsT7NTm3iGZTvyrYYpts2i2Zu0bR98VLW9bPtycUdtbgyaIkYr++j6pD500TeUAabreWZn/uxJeDIuLVYJNcR\",\"encoding\":{\"content\":[\"pkcs8\",\"sr25519\"],\"type\":[\"scrypt\",\"xsalsa20-poly1305\"],\"version\":\"3\"},\"meta\":{\"genesisHash\":\"0x012cfb6997279fed8ff754a5a90cb30627c70fcdd79ee9c480bcef07de754810\",\"name\":\"test-comon2\",\"tags\":[],\"whenCreated\":1616746198186}}"
    //@"{\"address\":\"5TffWUUbpKS2TkUviz5aZEbNAyJtH8MEaG5mkvXahhQtUz9b\",\"encoded\":\"UIMvI/mr3zDRTSpdvPX9VSshytEmnTu7VuNfFGjS3swAgAAAAQAAAAgAAAD2UbLd9yiBz8Zmig8A6OnA29xjrPR1IwpacKZ129dVUnVd5NOdGXqJOMzgqkIERDCvo5e/6XVGYyaihipQxa6epIO+kLEO35UkxetNYw2BR2e6g1rlGNz2YaNPnsiLQembg4cCKAcG1zJRUN2+5+XEuXxyNuYL297o/CkDsz8FaPzhtu4p3CCMczVICRX5CrRFeimUlY70vYDbw1CV\",\"encoding\":{\"content\":[\"pkcs8\",\"sr25519\"],\"type\":[\"scrypt\",\"xsalsa20-poly1305\"],\"version\":\"3\"},\"meta\":{\"genesisHash\":\"0x012cfb6997279fed8ff754a5a90cb30627c70fcdd79ee9c480bcef07de754810\",\"name\":\"LittleMonster\",\"tags\":[],\"whenCreated\":1614670970208}}"
    NSString *testJson = @"{\"address\":\"5TiRjQMDebfGB2txVYxtbgrwKfAawsqskxFrmWC3sLXFBMqn\",\"encoded\":\"6FOybGePm0IJGY613kFYQxinQ7cWS9CHB3gH30wJn6AAgAAAAQAAAAgAAABKP9Nfa4Jm1V2Ykd0zyFxHWFt1AJcOQ6GCkakbzhX18+YL7C0aMpr+EH4IzJN5eGnUYtaCaPXZgMth05HtAxp0oCkCIfiYeyGtD8d3hePEmf4gPzD7G8luB5IE+eOSsT7NTm3iGZTvyrYYpts2i2Zu0bR98VLW9bPtycUdtbgyaIkYr++j6pD500TeUAabreWZn/uxJeDIuLVYJNcR\",\"encoding\":{\"content\":[\"pkcs8\",\"sr25519\"],\"type\":[\"scrypt\",\"xsalsa20-poly1305\"],\"version\":\"3\"},\"meta\":{\"genesisHash\":\"0x012cfb6997279fed8ff754a5a90cb30627c70fcdd79ee9c480bcef07de754810\",\"name\":\"test-comon2\",\"tags\":[],\"whenCreated\":1616746198186}}";
    [self.sdk.api.keyring importAccountWithKeyType:keystore
                                               key:testJson
                                              name:@"mytest-coming"
                                          password:@"1"
                                    successHandler:^(id  _Nullable data) {
        self.testAcc = [self.sdk.api.keyring addAccountWithKeyring:self.sdk.keyring
                                                           keyType:@"mnemonic"
                                                               acc:data
                                                          password:@"1"];

    } failureHandler:^(id  _Nullable data) {

    }];
}

- (void)transfer
{
//    [self.sdk.api.tx estimateFeesWithTxInfo:@{}.mutableCopy
//                                     params:@[].mutableCopy
//                                   rawParam:nil
//                             successHandler:^(NSMutableDictionary * _Nonnull data) {
//
//    }];
    //0xb44c8b701d20de11c3b85f4b7cafcf2e066e783184359edd4ce5e21a75a40217
    [self.sdk.api.tx signAndSendWithTxInfo:@{@"module":@"balances",
                                             @"call":@"transfer",
                                             @"sender":@{@"address":
                                                             @"5TiRjQMDebfGB2txVYxtbgrwKfAawsqskxFrmWC3sLXFBMqn",
                                                         @"pubKey":@"0xb44c8b701d20de11c3b85f4b7cafcf2e066e783184359edd4ce5e21a75a40217"
                                             }}.mutableCopy
                                    params:@[@"5TffWUUbpKS2TkUviz5aZEbNAyJtH8MEaG5mkvXahhQtUz9b", @"10000"].mutableCopy
                                  password:@"1"
                            onStatusChange:^(id  _Nullable data) {
        
    }
                                  rawParam:nil
                            successHandler:^(NSMutableDictionary * _Nonnull data) {
        
    }
                            failureHandler:^(NSString * _Nonnull error) {
        
    }];
}

/*
 txInfo---{
     call = transfer;
     module = balances;
     sender =     {
         address = 5TiRjQMDebfGB2txVYxtbgrwKfAawsqskxFrmWC3sLXFBMqn;
         pubKey = 0xb44c8b701d20de11c3b85f4b7cafcf2e066e783184359edd4ce5e21a75a40217;
     };
 }
 param---["5UB3xRTfwyh6JU4tRtBJznh7nLSxpzX8F7Dtpt63i6e9GtBC","1000000.000000"]

 */

/*
 txInfo---{
     call = transfer;
     module = balances;
     sender =     {
         address = 5TiRjQMDebfGB2txVYxtbgrwKfAawsqskxFrmWC3sLXFBMqn;
         pubKey = 0xb44c8b701d20de11c3b85f4b7cafcf2e066e783184359edd4ce5e21a75a40217;
     };
 }
 param---["5TffWUUbpKS2TkUviz5aZEbNAyJtH8MEaG5mkvXahhQtUz9b","10000"]
 */

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
    [button setTitle:@"导入账号" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(importAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)setUI3
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 500, 200, 100);
    [button setTitle:@"转账" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(transfer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

@end
