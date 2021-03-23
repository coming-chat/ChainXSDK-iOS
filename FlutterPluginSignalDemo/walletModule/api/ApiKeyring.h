//
//  ApiKeyring.h
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KeyType) {
    mnemonic = 0,
    rawSeed,
    keystore,
};

typedef NS_ENUM(NSUInteger, CryptoType) {
    sr25519 = 0,
    ed25519,
};

@interface ApiKeyring : NSObject

@end

NS_ASSUME_NONNULL_END
