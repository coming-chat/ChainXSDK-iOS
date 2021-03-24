//
//  NSObject+jsonExtention.m
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import "NSObject+jsonExtention.h"

@implementation NSObject (jsonExtention)

NSString *jsonEncodeWithValue(id value)
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:value options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
}

id jsonDecodeWithString(NSString *string)
{
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

@end
