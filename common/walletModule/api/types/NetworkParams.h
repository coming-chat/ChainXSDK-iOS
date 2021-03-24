//
//  NetworkParams.h
//  common
//
//  Created by 杨钰棋 on 2021/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkParams : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *endpoint;
@property (nonatomic, assign) NSInteger ss58;

@end

NS_ASSUME_NONNULL_END
