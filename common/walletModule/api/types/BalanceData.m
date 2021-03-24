//
//  BalanceData.m
//  common
//
//  Created by 杨钰棋 on 2021/3/24.
//

#import "BalanceData.h"
#import <MTLJSONAdapter.h>

@implementation BalanceData

+ (NSValueTransformer *)lockedBreakdownJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:BalanceBreakdownData.class];
}

@end

@implementation BalanceBreakdownData


@end
