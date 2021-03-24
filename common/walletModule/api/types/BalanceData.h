//
//  BalanceData.h
//  common
//
//  Created by 杨钰棋 on 2021/3/24.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
@class BalanceBreakdownData;

NS_ASSUME_NONNULL_BEGIN

@interface BalanceData : MTLModel
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, strong) id accountNonce;
@property (nonatomic, strong) id availableBalance;
@property (nonatomic, strong) id freeBalance;
@property (nonatomic, strong) id frozenFee;
@property (nonatomic, strong) id frozenMisc;
@property (nonatomic, assign) bool isVesting;
@property (nonatomic, strong) id lockedBalance;
@property (nonatomic, strong) NSArray<BalanceBreakdownData *> *lockedBreakdown;

@property (nonatomic, strong) id reservedBalance;
@property (nonatomic, strong) id vestedBalance;
@property (nonatomic, strong) id vestedClaimable;
@property (nonatomic, strong) id vestingEndBlock;
@property (nonatomic, strong) id vestingLocked;
@property (nonatomic, strong) id vestingPerBlock;
@property (nonatomic, strong) id vestingTotal;
@property (nonatomic, strong) id votingBalance;

@end

@interface BalanceBreakdownData : MTLModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) id amount;
@property (nonatomic, copy) NSString *reasons;
@property (nonatomic, copy) NSString *use;

@end

NS_ASSUME_NONNULL_END
