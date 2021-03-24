//
//  Keyring.h
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>
#import "KeyPairData.h"
@class KeyringPrivateStore;

NS_ASSUME_NONNULL_BEGIN

@interface Keyring : NSObject
@property (nonatomic, strong) KeyringPrivateStore *store;

@property (nonatomic, assign) int ss58;

@property (nonatomic, strong) KeyPairData *current;
@property (nonatomic, strong) NSMutableArray *keyPairs;
@property (nonatomic, strong) NSMutableArray *externals;
@property (nonatomic, strong) NSMutableArray *contacts;

@property (nonatomic, strong) NSMutableArray<KeyPairData *> *allAccounts;
@property (nonatomic, strong) NSMutableArray<KeyPairData *> *allWithContacts;
@property (nonatomic, strong) NSMutableArray<KeyPairData *> *optionals;

@end

@interface KeyringPrivateStore : NSObject
@property (nonatomic, strong) NSArray<NSNumber *> *ss58List;
@property (nonatomic, assign) int ss58;

@property (nonatomic, copy) NSString *currentPubKey;

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableArray *externals;
@property (nonatomic, strong) NSMutableArray *contacts;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary *> *pubKeyAddressMap;

- (void)updatePubKeyAddressMapWithData:(NSDictionary<NSString *, NSDictionary *> *)data;

@end

NS_ASSUME_NONNULL_END
