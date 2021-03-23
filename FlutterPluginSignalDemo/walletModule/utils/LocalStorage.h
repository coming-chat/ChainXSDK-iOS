//
//  LocalStorage.h
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalStorage : NSObject

+ (instancetype)shareInstance;

- (void)addAccountWithAcc:(NSDictionary<NSString *, id> *)acc;

- (void)removeAccountWithPubKey:(NSString *)pubKey;

- (NSMutableArray<NSDictionary<NSString *, id> *> *)getAccountList;

- (void)setCurrentAccountWithPubKey:(NSString *)pubKey;

- (NSString *)getCurrentAccount;

- (void)addContactWithDictionary:(NSDictionary<NSString *, id> *)dict;

- (void)removeContactWithAddress:(NSString *)address;

- (void)updateContactDictionary:(NSDictionary<NSString *, id> *)dict;

- (NSMutableArray<NSDictionary<NSString *, id> *> *)getContactList;

- (void)setSeedsWithSeedType:(NSString *)seedType
                       value:(NSDictionary *)value;

- (NSDictionary *)getSeedsWithSeedType:(NSString *)seedType;

- (void)setObjectWithKey:(NSString *)key
                   value:(id)value;

- (id)getObjectWithKey:(NSString *)key;

- (void)setAccountCacheWithAccPubKey:(NSString *)accPubKey
                                 key:(NSString *)key
                               value:(id)value;

- (id)getAccountCacheWithAccPubKey:(NSString *)accPubKey
                               key:(NSString *)key;

- (BOOL)checkCacheTimeoutWithCacheTime:(int)cacheTime;

@end

NS_ASSUME_NONNULL_END
