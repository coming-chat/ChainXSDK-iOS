//
//  ApiTx.m
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import "ApiTx.h"
#import "PolkawalletApi.h"
#import "ServiceTx.h"
#import "NSObject+jsonExtention.h"

@implementation ApiTx

// Estimate tx fees, [params] will be ignored if we have [rawParam].
- (void)estimateFeesWithTxInfo:(NSDictionary *)txInfo
                        params:(NSMutableArray *)params
                      rawParam:(NSString *)rawParam
                successHandler:(void (^ _Nullable)(NSDictionary *data))successHandler
{
    NSString *param = rawParam ? : jsonEncodeWithValue(params);
    [self.service estimateFeesWithTxInfo:txInfo params:param successHandler:successHandler];
}

// Send tx, [params] will be ignored if we have [rawParam].
// [onStatusChange] is a callback when tx status change.
// @return txHash [string] if tx finalized success.
- (void)signAndSendWithTxInfo:(NSDictionary *)txInfo
                       params:(NSMutableArray *)params
                     password:(NSString *)password
               onStatusChange:(void (^ _Nullable)(_Nullable id data))onStatusChange
                     rawParam:(NSString *)rawParam
               successHandler:(void (^ _Nullable)(NSDictionary *data))successHandler
               failureHandler:(void (^ _Nullable)(NSString *error))failureHandler
{
    NSString *param = rawParam ? : jsonEncodeWithValue(params);
    NSLog(@"txInfo---%@\nparam---%@", txInfo, param);
    [self.service signAndSendWithTxInfo:txInfo params:param password:password onStatusChange:onStatusChange successHandler:^(id  _Nullable data) {
        if ([((NSDictionary *)data).allKeys containsObject:@"error"]) {
            failureHandler(data[@"error"]);
        }else{
            successHandler(data);
        }
    }];
}

@end
