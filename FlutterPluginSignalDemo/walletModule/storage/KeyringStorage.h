//
//  KeyringStorage.h
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyringStorage : NSObject

@property (nonatomic, strong) NSUserDefaults *storage;

@property (nonatomic, strong) NSArray *keyPairs;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, copy) NSString *currentPubKey;
@property (nonatomic, strong) NSDictionary *encryptedRawSeeds;
@property (nonatomic, strong) NSDictionary *encryptedMnemonics;

+(instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
