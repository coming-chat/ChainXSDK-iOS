//
//  KeyringStorage.m
//  common
//
//  Created by 杨钰棋 on 2021/3/18.
//

#import "KeyringStorage.h"
#import "KeyPairData.h"

@implementation KeyringStorage

+ (instancetype)shareInstance
{
    static KeyringStorage *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initDefault];
    });
    return instance;
}

- (instancetype)initDefault
{
    self = [super init];

    if (!self) {
        return self;
    }

//    OWSAssertIsOnMainThread();

//    OWSSingletonAssert();

    return self;
}

- (NSUserDefaults *)storage
{
    return [[NSUserDefaults alloc] initWithSuiteName:@"polka_coming_sdk"];
}

- (NSArray *)keyPairs
{
    return [self.storage arrayForKey:@"keyPairs"];
}

- (NSArray *)contacts
{
    return [self.storage arrayForKey:@"contacts"];
}

- (NSString *)currentPubKey
{
    return [self.storage stringForKey:@"currentPubKey"];
}

- (NSDictionary *)encryptedRawSeeds
{
    return [self.storage dictionaryForKey:@"encryptedRawSeeds"];
}

- (NSDictionary *)encryptedMnemonics
{
    return [self.storage dictionaryForKey:@"encryptedMnemonics"];
}

@end
