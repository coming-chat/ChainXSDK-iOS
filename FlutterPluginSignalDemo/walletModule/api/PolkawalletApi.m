//
//  PolkawalletApi.m
//  FlutterPluginSignalDemo
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
    }
    return self;
}

@end
