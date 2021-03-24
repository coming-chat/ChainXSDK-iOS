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

NSString *passwordToEncryptKey(NSString *password)
{
    NSData *myD = [password dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for (int i = 0; i < [myD length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];///16进制数
        if([newHexStr length] == 1)
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr,newHexStr];
    }
    if (hexStr.length > 32) {
        return [hexStr substringToIndex:32];
    }
    return CharacterStringMainString(hexStr, 32, @"0");
}

NSString *CharacterStringMainString(NSString *MainString, int AddDigit, NSString *AddString)
{
    NSString *ret = [[NSString alloc] init];
    ret = MainString;
    for (int y = 0; y < (AddDigit - MainString.length); y++){
        ret = [NSString stringWithFormat:@"%@%@", ret, AddString];
    }
    return ret;
}

@end
