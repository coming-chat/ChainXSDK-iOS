//
//  ServiceTx.h
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
@class SubstrateService;

NS_ASSUME_NONNULL_BEGIN

@interface ServiceTx : NSObject
@property (nonatomic, weak) SubstrateService *serviceRoot;

- (void)estimateFeesWithTxInfo:(NSDictionary *)txInfo
                        params:(NSString *)params
                successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)signAndSendWithTxInfo:(NSDictionary *)txInfo
                       params:(NSString *)params
                     password:(NSString *)password
               onStatusChange:(void (^ _Nullable)(_Nullable id data))onStatusChange
               successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

@end

NS_ASSUME_NONNULL_END
