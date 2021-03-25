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
                 successHandler:(void (^ _Nullable)(BalanceData *data))successHandler
{
    [self.service queryBalanceWithAddress:address successHandler:^(id  _Nullable data) {
        successHandler([BalanceData modelWithDictionary:data error:nil]);
    }];
}

- (void)subscribeBalanceWithAddress:(NSString *)address
                           onUpdate:(void (^ _Nullable)(BalanceData *data))onUpdate
                     successHandler:(void (^ _Nullable)(NSString *msgChannel))successHandler
{
    NSString *msgChannel = @"Balance";
    NSString *code = [NSString stringWithFormat:@"account.getBalance(api, \"%@\", \"%@\")", address, msgChannel];
    [self.apiRoot.service.webView subscribeMessageWithCode:code channel:msgChannel callback:^(id  _Nullable data) {
        onUpdate([BalanceData modelWithDictionary:data error:nil]);
    } successHandler:successHandler];
}

- (void)unsubscribeBalance
{
    NSString *msgChannel = @"Balance";
    [self.apiRoot unsubscribeMessageWithChannel:msgChannel];
}

// Get on-chain account info of addresses
- (void)queryIndexInfoWithAddresses:(NSMutableArray *)addresses
                     successHandler:(void (^ _Nullable)(NSMutableArray *list))successHandler
{
    if (!addresses || addresses.count == 0) {
        successHandler(@[].mutableCopy);
        return;
    }
    [self.service queryIndexInfoWithAddresses:addresses successHandler:successHandler];
}

// query address with account index
- (void)queryAddressWithAccountIndexWithIndex:(NSString *)index
                               successHandler:(void (^ _Nullable)(NSString *string))successHandler
{
    [self.service queryAddressWithAccountIndex:index ss58:(int)self.apiRoot.connectedNode.ss58 successHandler:^(id  _Nullable data) {
        if (data) {
            if (((NSArray *)data).count > 0) {
                successHandler(data[0]);
            }
        }else{
            successHandler(nil);
        }
    }];
}

// Get icons of pubKeys
// return svg strings
- (void)getPubKeyIconsWithKeys:(NSMutableArray<NSString *> *)keys
                successHandler:(void (^ _Nullable)(NSMutableArray *list))successHandler
{
    if (!keys || keys.count == 0) {
        successHandler(@[].mutableCopy);
        return;
    }
    [self.service getPubKeyIconsWithKeys:keys successHandler:successHandler];
}

// Get icons of addresses
// return svg strings
- (void)getAddressIconsWithKeys:(NSMutableArray<NSString *> *)addresses
                 successHandler:(void (^ _Nullable)(NSMutableArray *list))successHandler
{
    if (!addresses || addresses.count == 0) {
        successHandler(@[].mutableCopy);
        return;
    }
    [self.service getAddressIconsWithAddresses:addresses successHandler:successHandler];
}

@end
