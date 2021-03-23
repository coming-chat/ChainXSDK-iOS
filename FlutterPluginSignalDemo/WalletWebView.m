//
//  WalletWebView.m
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import "WalletWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WalletWebView ()

@end

@implementation WalletWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 创建JavaScript执行环境(上下文)
//        JSContext *context = [[JSContext alloc] init];
//        NSString *funCode =
//            @"var isValidNumber = function(phone) {"
//             "    var phonePattern = /^1[34578]\\\\d{9}$/;"
//             "    return phone.match(phonePattern);"
//             "};";
//        // 执行上面的JavaScript代码
//        [context evaluateScript:funCode];
//        // 获得isValidNumber函数并传参调用
//        JSValue *jsFunction = context[@"isValidNumber"];
//        JSValue *value1 = [jsFunction callWithArguments:@[ @"13012345678" ]];
//        NSLog(@"%@", [value1 toBool]? @"有效": @"无效");    // 有效
//        JSValue *value2 = [jsFunction callWithArguments:@[ @"12345678899" ]];
//        NSLog(@"%@", [value2 toBool]? @"有效": @"无效");    // 无效
        
        // 创建JavaScript执行环境(上下文)
//        JSContext *context = [[JSContext alloc] init];
//        // 可以将一个block传给JavaScript上下文
//        // 它会被转换成一个JavaScript中的函数
//        context[@"factorial"] = ^(int x) {
//            double result = 1.0;
//            for (; x > 1; x--) {
//                result *= x;
//            }
//            return result;
//        };
//        // 执行求阶乘的函数
//        [context evaluateScript:@"var num = factorial(5);"];
//        JSValue *num = context[@"num"];
//        NSLog(@"5! = %@", num);    // 5! = 120
    }
    return self;
}



@end
