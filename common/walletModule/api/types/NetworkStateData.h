//
//  NetworkStateData.h
//  common
//
//  Created by 杨钰棋 on 2021/3/24.
//

#import <Foundation/Foundation.h>
#import <MTLModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkStateData : MTLModel
@property (nonatomic, assign) int ss58Format;
@property (nonatomic, strong) NSArray<NSNumber *> *tokenDecimals;
@property (nonatomic, strong) NSArray<NSString *> *tokenSymbol;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
