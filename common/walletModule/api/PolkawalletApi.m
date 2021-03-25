//
//  PolkawalletApi.m
//  common
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import "PolkawalletApi.h"
#import "NSObject+jsonExtention.h"

@interface PolkawalletApi ()

@end

@implementation PolkawalletApi

- (instancetype)initWithService:(SubstrateService *)service
{
    self = [super init];
    if (self) {
        self.service = service;
        self.account = [[ApiAccount alloc] init];
        self.account.apiRoot = self;
        self.account.service = self.service.account;
        self.keyring = [[ApiKeyring alloc] init];
        self.keyring.apiRoot = self;
        self.keyring.service = self.service.keyring;
        self.setting = [[ApiSetting alloc] init];
        self.setting.apiRoot = self;
        self.setting.service = self.service.setting;
        self.tx = [[ApiTx alloc] init];
        self.tx.apiRoot = self;
        self.tx.service = self.service.tx;
    }
    return self;
}

- (void)connectNodeWithKeyringStorage:(Keyring *)keyringStorage
                                nodes:(NSMutableArray<NetworkParams *> *)nodes
                       successHandler:(void (^ _Nullable)(NetworkParams *data))successHandler
{
    self.connectedNode = nil;
    [self.service.webView connectNode:nodes successHandler:^(NetworkParams * _Nonnull data) {
        if (data) {
            self.connectedNode = data;
        }
        [self.keyring updateIndicesMapWithKeyring:keyringStorage addresses:nil];
        successHandler(data);
    }];
}

- (void)subscribeMessageWithJSCall:(NSString *)JSCall
                            params:(NSMutableArray *)params
                           channel:(NSString *)channel
                          callback:(void (^ _Nullable)(_Nullable id data))callback
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.service.webView subscribeMessageWithCode:[NSString stringWithFormat:@"settings.subscribeMessage(%@, %@, \"%@\")", JSCall, jsonEncodeWithValue(params), channel]
                                           channel:channel
                                          callback:callback
                                    successHandler:successHandler];
}

- (void)unsubscribeMessageWithChannel:(NSString *)channel
{
    [self.service.webView unsubscribeMessageWithChannel:channel];
}

@end
