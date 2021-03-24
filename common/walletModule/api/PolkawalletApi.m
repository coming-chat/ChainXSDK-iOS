//
//  PolkawalletApi.m
//  common
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import "PolkawalletApi.h"

@interface PolkawalletApi ()
@property (nonatomic ,strong) SubstrateService *service;

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

@end
