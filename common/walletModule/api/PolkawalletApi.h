//
//  PolkawalletApi.h
//  common
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import <Foundation/Foundation.h>
#import "SubstrateService.h"
#import "ApiAccount.h"
#import "ApiSetting.h"
#import "ApiTx.h"

NS_ASSUME_NONNULL_BEGIN

@interface PolkawalletApi : NSObject
@property (nonatomic ,strong) SubstrateService *service;

@property (nonatomic, strong, nullable) NetworkParams *connectedNode;
@property (nonatomic, strong) ApiAccount *account;
@property (nonatomic, strong) ApiKeyring *keyring;
@property (nonatomic, strong) ApiSetting *setting;
@property (nonatomic, strong) ApiTx *tx;
//@property (nonatomic, strong) ApiWalletConnect *walletConnect;

//  final SubScanApi subScan = SubScanApi();

- (instancetype)initWithService:(SubstrateService *)service;

- (void)connectNodeWithKeyringStorage:(Keyring *)keyringStorage
                                nodes:(NSMutableArray<NetworkParams *> *)nodes
                       successHandler:(void (^ _Nullable)(NetworkParams *data))successHandler;

- (void)subscribeMessageWithJSCall:(NSString *)JSCall
                            params:(NSMutableArray *)params
                           channel:(NSString *)channel
                          callback:(void (^ _Nullable)(_Nullable id data))callback
                    successHandler:(void (^ _Nullable)(_Nullable id data))successHandler;

- (void)unsubscribeMessageWithChannel:(NSString *)channel;

@end

NS_ASSUME_NONNULL_END
