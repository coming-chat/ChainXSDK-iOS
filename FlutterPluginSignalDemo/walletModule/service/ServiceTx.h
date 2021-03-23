//
//  ServiceTx.h
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
@class SubstrateService;

NS_ASSUME_NONNULL_BEGIN

@interface ServiceTx : NSObject
@property (nonatomic, weak) SubstrateService *serviceRoot;

@end

NS_ASSUME_NONNULL_END
