//
//  WebViewRunner.h
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import "WalletWebView.h"
#import "ServiceKeyring.h"
#import "Keyring.h"
#import "NetworkParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewRunner : NSObject
@property (nonatomic, strong) WalletWebView *web;
@property (nonatomic, assign) NSInteger evalJavascriptUID;

- (void)launchWithKeyring:(ServiceKeyring *)keyring
           keyringStorage:(Keyring *)keyringStorage
                    block:(void(^)(void))onLaunched
                   jsCode:(NSString *)jsCode;

- (void)evalJavascriptWithCode:(NSString *)code successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)connectNode:(NSArray<NetworkParams *> *)nodes successHandler:(void (^ _Nullable)(NetworkParams *data))successHandler;

- (void)subscribeMessageWithCode:(NSString *)code
                         channel:(NSString *)channel
                        callback:(void (^ _Nullable)(_Nullable id data))callback
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)addMsgHandlerWithChannel:(NSString *)channel
                       onMessage:(void (^)(_Nullable id data))onMessage;

- (void)removeMsgHandlerWithChannel:(NSString *)channel;

@end

NS_ASSUME_NONNULL_END
