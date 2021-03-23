//
//  WebViewRunner.h
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import "ChainXWebView.h"
#import "ServiceKeyring.h"
#import "Keyring.h"
#import "NetworkParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewRunner : NSObject
@property (nonatomic, strong) ChainXWebView *web;
@property (nonatomic, assign) NSInteger evalJavascriptUID;

- (void)launchWithKeyring:(ServiceKeyring *)keyring
                  Keyring:(Keyring *)keyringStorage
                    block:(void(^)(void))onLaunched
                   jsCode:(NSString *)jsCode;

- (void)evalJavascriptWithCode:(NSString *)code successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (NSString *)connectNode:(NSArray<NetworkParams *> *)nodes successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

@end

NS_ASSUME_NONNULL_END
