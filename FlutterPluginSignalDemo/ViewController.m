//
//  ViewController.m
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/3.
//

#import "ViewController.h"
//#import "ChainXWebView.h"
#import "WebViewRunner.h"
#import "Keyring.h"

@interface ViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WebViewRunner *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"转跳Flutter" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(jumpToFlutter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
//    Keyring *keyring = [[Keyring alloc] init];
    
}

- (void)jumpToFlutter
{
    self.webView = [[WebViewRunner alloc] init];
    [self.webView launchWithKeyring:[[ServiceKeyring alloc] init] Keyring:[[Keyring alloc] init] block:^{
        
    } jsCode:@""];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NetworkParams *params = [[NetworkParams alloc] init];
        params.name = @"Kusama";
        params.endpoint = @"wss://kusama-1.polkawallet.io:9944/";
        params.ss58 = 2;
        [self.webView connectNode:@[params] successHandler:^(id  _Nullable data) {
            NSLog(@"data == %@", data);
            
        }];
    });
}

@end