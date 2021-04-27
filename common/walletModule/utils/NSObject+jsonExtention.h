//
//  NSObject+jsonExtention.h
//  common
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (jsonExtention)

NSString *jsonEncodeWithValue(id value);

id jsonDecodeWithString(NSString *string);

NSString *passwordToEncryptKey(NSString *password);

BOOL isValidAddress(NSString *address);

- (NSString *)notRounding:(double)number afterPoint:(int)position;


/// 货币 字符串 -> 数字 (乘以 10^8)
/// @param string 货币
- (NSInteger)coinNumberFromString:(NSString *)string;

/// 货币 数字 (乘以 10^8) -> 格式化字符串
/// @param coin 货币数值 (乘以 10^8)
/// digit 固定8位
/// zero 不保留末尾的0
- (NSString *)coinStringFromNumber:(NSInteger)coin;

/// 货币 数字 (乘以 10^8) -> 格式化字符串
/// @param coin 货币数值 (乘以 10^8)
/// @param digit 需要保留的小数位数
/// @param zero 小数点末尾的 0 是否保留
- (NSString *)coinStringFromNumber:(NSInteger)coin digit:(NSInteger)digit zero:(BOOL)zero;

@end

NS_ASSUME_NONNULL_END
