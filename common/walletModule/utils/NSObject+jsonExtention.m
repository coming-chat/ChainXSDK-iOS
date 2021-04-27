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

//const HEX_REGEX = /^0x[a-fA-F0-9]+$/;
//
//export function isHex (value: unknown, bitLength = -1, ignoreLength = false): value is string | String {
//  const isValidHex = value === '0x' || (isString(value) && HEX_REGEX.test(value.toString()));
//
//  if (isValidHex && bitLength !== -1) {
//    return (value as string).length === (2 + Math.ceil(bitLength / 4));
//  }
//
//  return isValidHex && (ignoreLength || ((value as string).length % 2 === 0));
//}
BOOL isValidAddress(NSString *address)
{
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [predicate evaluateWithObject:address];
    return result;
}

- (NSString *)notRounding:(double)number afterPoint:(int)position {

    return [self coinStringFromNumber:(NSInteger)number digit:position zero:position != 8];

}

- (NSInteger)coinNumberFromString:(NSString *)string {
    return (NSInteger)([string doubleValue] * 100000000);
}

- (NSString *)coinStringFromNumber:(NSInteger)coin {
    return [self coinStringFromNumber:coin digit:8 zero:NO];
}

- (NSString *)coinStringFromNumber:(NSInteger)coin digit:(NSInteger)digit zero:(BOOL)zero {
    NSMutableString *res = [NSMutableString stringWithFormat:@"%9ld", coin];
    NSRange r1 = NSMakeRange(0, res.length);
    [res replaceOccurrencesOfString:@" " withString:@"0" options:NSCaseInsensitiveSearch range:r1];
    [res insertString:@"." atIndex:res.length - 8];
    
    // 根据 digit 裁剪（尾数直接舍去）
    NSUInteger del = MAX(0, MIN(8, (8 - (NSUInteger)digit)));
    NSRange r2 = NSMakeRange(res.length - del, del);
    [res deleteCharactersInRange:r2];
    
    // 去掉末尾多余的 0
    if (zero == NO) {
        NSString *temp = [res stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0"]];
        if ([temp hasSuffix:@"."]) {
            temp = [temp substringToIndex:temp.length-1];
        }
        if ([temp hasPrefix:@"."]) {
            temp = [@"0" stringByAppendingString:temp];
        }
        if (temp.length == 0) {
            temp = @"0";
        }
        return temp;
    }
    return [res copy];
}

@end
