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
    return [self.storage arrayForKey:@"keyPairs"] ? : [[NSArray alloc] init];
}

- (NSArray *)contacts
{
    return [self.storage arrayForKey:@"contacts"] ? : [[NSArray alloc] init];
}

- (NSString *)currentPubKey
{
    return [self.storage stringForKey:@"currentPubKey"] ? : [[NSString alloc] init];
}

- (NSMutableDictionary *)encryptedRawSeeds
{
    return [self.storage dictionaryForKey:@"encryptedRawSeeds"].mutableCopy ? : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)encryptedMnemonics
{
    return [self.storage dictionaryForKey:@"encryptedMnemonics"].mutableCopy ? : [[NSMutableDictionary alloc] init];
}

@end
