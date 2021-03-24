//
//  ApiAccount.m
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import "ApiAccount.h"
#import "PolkawalletApi.h"
#import "ServiceAccount.h"

@implementation ApiAccount

- (void)encodeAddressWithPubKeys:(NSMutableArray<NSString *> *)pubKeys
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.service encodeAddressWithPubKeys:pubKeys ss58List:@[@(self.apiRoot.connectedNode.ss58)].mutableCopy successHandler:^(id  _Nullable data) {
        if ([data isKindOfClass:NSDictionary.class]) {
            if ([((NSDictionary *)data).allKeys containsObject:[NSString stringWithFormat:@"%ld", (long)self.apiRoot.connectedNode.ss58]]) {
                successHandler(data[[NSString stringWithFormat:@"%ld", (long)self.apiRoot.connectedNode.ss58]]);
                return;
            }
        }
        successHandler(nil);
    }];
}

- (void)decodeAddressWithAddresses:(NSMutableArray<NSString *> *)addresses
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    [self.service decodeAddressWithAddresses:addresses successHandler:successHandler];
}

- (void)queryBalanceWithAddress:(NSString *)address
                 successHandler:(void (^ _Nullable)(_Nullable id data))successHandler
{
    
}

@end
