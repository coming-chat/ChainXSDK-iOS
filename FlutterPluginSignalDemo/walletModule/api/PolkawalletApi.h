//
//  PolkawalletApi.h
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import <Foundation/Foundation.h>
#import "SubstrateService.h"

NS_ASSUME_NONNULL_BEGIN

@interface PolkawalletApi : NSObject
@property (nonatomic, strong) NetworkParams *connectedNode;
@property (nonatomic, strong) ApiKeyring *keyring;
//@property (nonatomic, strong) ApiSetting *setting;
//@property (nonatomic, strong) ApiAccount *account;
//@property (nonatomic, strong) ApiTx *tx;
//@property (nonatomic, strong) ApiWalletConnect *walletConnect;

//  final SubScanApi subScan = SubScanApi();

@end

NS_ASSUME_NONNULL_END
