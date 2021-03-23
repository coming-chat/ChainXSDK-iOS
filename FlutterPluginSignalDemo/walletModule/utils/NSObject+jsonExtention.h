//
//  NSObject+jsonExtention.h
//  FlutterPluginSignalDemo
//
//  Created by 杨钰棋 on 2021/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (jsonExtention)

NSString *jsonEncodeWithValue(id value);

id jsonDecodeWithString(NSString *string);

@end

NS_ASSUME_NONNULL_END