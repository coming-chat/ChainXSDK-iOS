//
//  KeyPairData.m
//  common
//
//  Created by 杨钰棋 on 2021/3/19.
//

#import "KeyPairData.h"
#import "NSDictionary+MTLMappingAdditions.h"

@implementation KeyPairData
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

@end

@implementation SeedBackupData

@end
