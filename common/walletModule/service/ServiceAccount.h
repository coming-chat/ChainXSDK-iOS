//
//  ServiceAccount.h
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
@class SubstrateService;

NS_ASSUME_NONNULL_BEGIN

@interface ServiceAccount : NSObject
@property (nonatomic, weak) SubstrateService *serviceRoot;

- (void)encodeAddressWithPubKeys:(NSMutableArray<NSString *> *)pubKeys
                        ss58List:(NSMutableArray *)ss58List
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)decodeAddressWithAddresses:(NSMutableArray<NSString *> *)addresses
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)queryBalanceWithAddress:(NSString *)address
                 successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)queryIndexInfoWithAddresses:(NSMutableArray *)addresses
                     successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)queryAddressWithAccountIndex:(NSString *)index
                                ss58:(int)ss58
                      successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)getPubKeyIconsWithKeys:(NSMutableArray<NSString *> *)keys
                successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)getAddressIconsWithAddresses:(NSMutableArray *)addresses
                      successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;
@end

NS_ASSUME_NONNULL_END
