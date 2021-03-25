//
//  ApiAccount.h
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import <Foundation/Foundation.h>
#import "BalanceData.h"
@class PolkawalletApi;
@class ServiceAccount;

NS_ASSUME_NONNULL_BEGIN

@interface ApiAccount : NSObject
@property (nonatomic, strong) PolkawalletApi *apiRoot;
@property (nonatomic, strong) ServiceAccount *service;

- (void)encodeAddressWithPubKeys:(NSMutableArray<NSString *> *)pubKeys
                  successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)decodeAddressWithAddresses:(NSMutableArray<NSString *> *)addresses
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)queryBalanceWithAddress:(NSString *)address
                 successHandler:(void (^ _Nullable)(BalanceData *data))successHandler;
- (void)subscribeBalanceWithAddress:(NSString *)address
                           onUpdate:(void (^ _Nullable)(BalanceData *data))onUpdate
                     successHandler:(void (^ _Nullable)(NSString *msgChannel))successHandler;

- (void)unsubscribeBalance;

// Get on-chain account info of addresses
- (void)queryIndexInfoWithAddresses:(NSMutableArray *)addresses
                     successHandler:(void (^ _Nullable)(NSMutableArray *list))successHandler;

// query address with account index
- (void)queryAddressWithAccountIndexWithIndex:(NSString *)index
                               successHandler:(void (^ _Nullable)(NSString *string))successHandler;

// Get icons of pubKeys
// return svg strings
- (void)getPubKeyIconsWithKeys:(NSMutableArray<NSString *> *)keys
                successHandler:(void (^ _Nullable)(NSMutableArray *list))successHandler;

// Get icons of addresses
// return svg strings
- (void)getAddressIconsWithKeys:(NSMutableArray<NSString *> *)addresses
                 successHandler:(void (^ _Nullable)(NSMutableArray *list))successHandler;

@end

NS_ASSUME_NONNULL_END
