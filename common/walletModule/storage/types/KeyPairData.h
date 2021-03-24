//
//  KeyPairData.h
//  common
//
//  Created by 杨钰棋 on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyPairData : MTLModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *encoded;
@property (nonatomic, copy) NSString *pubKey;

@property (nonatomic, strong) NSDictionary<NSString*, id> *encoding;
@property (nonatomic, strong) NSDictionary<NSString*, id> *meta;

@property (nonatomic, copy) NSString *memo;
@property (nonatomic, assign) bool observation;

// address avatar in svg format
@property (nonatomic, copy) NSString *icon;

// indexInfo
@property (nonatomic, strong) NSDictionary *indexInfo;

@end

@interface SeedBackupData : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *seed;
@property (nonatomic, copy) NSString *error;

@end

NS_ASSUME_NONNULL_END