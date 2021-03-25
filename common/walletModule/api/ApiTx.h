//
//  ApiTx.h
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import <Foundation/Foundation.h>
@class PolkawalletApi;
@class ServiceTx;

NS_ASSUME_NONNULL_BEGIN

@interface ApiTx : NSObject
@property (nonatomic, strong) PolkawalletApi *apiRoot;
@property (nonatomic, strong) ServiceTx *service;

// Estimate tx fees, [params] will be ignored if we have [rawParam].
- (void)estimateFeesWithTxInfo:(NSMutableDictionary *)txInfo
                        params:(NSMutableArray *)params
                      rawParam:(NSString *)rawParam
                successHandler:(void (^ _Nullable)(NSMutableDictionary *data))successHandler;

// Send tx, [params] will be ignored if we have [rawParam].
// [onStatusChange] is a callback when tx status change.
// @return txHash [string] if tx finalized success.
- (void)signAndSendWithTxInfo:(NSMutableDictionary *)txInfo
                       params:(NSMutableArray *)params
                     password:(NSString *)password
               onStatusChange:(void (^ _Nullable)(_Nullable id data))onStatusChange
                     rawParam:(NSString *)rawParam
               successHandler:(void (^ _Nullable)(NSMutableDictionary *data))successHandler
               failureHandler:(void (^ _Nullable)(NSString *error))failureHandler;

@end

NS_ASSUME_NONNULL_END
