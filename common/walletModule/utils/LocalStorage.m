//
//  LocalStorage.m
//  common
//
//  Created by 杨钰棋 on 2021/3/22.
//

#import "LocalStorage.h"
#import "NSObject+jsonExtention.h"

@interface LocalStorage ()
@property (nonatomic, copy) NSString *accountsKey;
@property (nonatomic, copy) NSString *currentAccountKey;
@property (nonatomic, copy) NSString *contactsKey;
@property (nonatomic, copy) NSString *seedKey;
@property (nonatomic, copy) NSString *customKVKey;

@end

@implementation LocalStorage

const int customCacheTimeLength = 10 * 60 * 1000;

+ (instancetype)shareInstance
{
    static LocalStorage *instance = nil;
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
    
    self.accountsKey = @"wallet_account_list";
    self.currentAccountKey = @"wallet_current_account";
    self.contactsKey = @"wallet_contact_list";
    self.seedKey = @"wallet_seed";
    self.customKVKey = @"wallet_kv";

//    OWSAssertIsOnMainThread();

//    OWSSingletonAssert();

    return self;
}

- (void)addAccountWithAcc:(NSMutableDictionary<NSString *, id> *)acc
{
    [self addItemToListWithStoreKey:self.accountsKey dictionary:acc];
}

- (void)removeAccountWithPubKey:(NSString *)pubKey
{
    [self removeItemFromListWithStoreKey:self.accountsKey itemKey:@"pubKey" itemValue:pubKey];
}

- (NSMutableArray<NSMutableDictionary<NSString *, id> *> *)getAccountList
{
    return [self getListWithStoreKey:self.accountsKey];
}

- (void)setCurrentAccountWithPubKey:(NSString *)pubKey
{
    [self setKVWithKey:self.currentAccountKey value:pubKey];
}

- (NSString *)getCurrentAccount
{
    return [self getKVWithKey:self.currentAccountKey];
}

- (void)addContactWithDictionary:(NSMutableDictionary<NSString *, id> *)dict
{
    [self addItemToListWithStoreKey:self.contactsKey dictionary:dict];
}

- (void)removeContactWithAddress:(NSString *)address
{
    [self removeItemFromListWithStoreKey:self.contactsKey itemKey:@"address" itemValue:address];
}

- (void)updateContactDictionary:(NSMutableDictionary<NSString *, id> *)dict
{
    [self updateItemInListWithStoreKey:self.contactsKey itemKey:@"address" itemValue:dict[@"address"] itemNew:dict];
}

- (NSMutableArray<NSMutableDictionary<NSString *, id> *> *)getContactList
{
    return [self getListWithStoreKey:self.contactsKey];
}

- (void)setSeedsWithSeedType:(NSString *)seedType
                       value:(NSMutableDictionary *)value
{
    [self setKVWithKey:[NSString stringWithFormat:@"%@_%@", self.seedKey, seedType] value:jsonEncodeWithValue(value)];
}

- (NSMutableDictionary *)getSeedsWithSeedType:(NSString *)seedType
{
    NSString *value = [self getKVWithKey:[NSString stringWithFormat:@"%@_%@", self.seedKey, seedType]];
    if (value) {
        return jsonDecodeWithString(value);
    }
    return @{}.mutableCopy;
}

- (void)setObjectWithKey:(NSString *)key
                   value:(id)value
{
    [self setKVWithKey:[NSString stringWithFormat:@"%@_%@", self.customKVKey, key] value:jsonEncodeWithValue(value)];
}

- (id)getObjectWithKey:(NSString *)key
{
    id value = [self getKVWithKey:[NSString stringWithFormat:@"%@_%@", self.customKVKey, key]];
    if (value) {
        return jsonEncodeWithValue(value);
    }
    return nil;
}

- (void)setAccountCacheWithAccPubKey:(NSString *)accPubKey
                                 key:(NSString *)key
                               value:(id)value
{
    NSMutableDictionary *dict = [self getObjectWithKey:key];
    if (!dict) {
        dict = @{}.mutableCopy;
    }
    [dict setValue:value forKey:@"accPubKey"];
    [self setObjectWithKey:key value:value];
}

- (id)getAccountCacheWithAccPubKey:(NSString *)accPubKey
                               key:(NSString *)key
{
    NSMutableDictionary *dict = [self getObjectWithKey:key];
    if (!dict) {
        return nil;
    }
    return dict[accPubKey];
}

- (BOOL)checkCacheTimeoutWithCacheTime:(int)cacheTime
{
    return (NSDate.date.timeIntervalSince1970 - customCacheTimeLength) > cacheTime;
}

#pragma mark api
- (NSString *)getKVWithKey:(NSString *)key
{
    return [[[NSUserDefaults alloc] initWithSuiteName:@"LocalStorage"] stringForKey:key];
}

- (void)setKVWithKey:(NSString *)key value:(id)value
{
    [[[NSUserDefaults alloc] initWithSuiteName:@"LocalStorage"] setValue:value forKey:key];
}

- (void)addItemToListWithStoreKey:(NSString *)storeKey
                       dictionary:(NSMutableDictionary<NSString *, id> *)dict
{
    NSMutableArray<NSMutableDictionary<NSString *, id> *> *ls = [[NSMutableArray alloc] init];
    NSString *str = [self getKVWithKey:storeKey];
    if (str) {
        ls = jsonDecodeWithString(str);
    }
    [ls addObject:dict];
    [self setKVWithKey:storeKey value:jsonEncodeWithValue(ls)];
}

- (void)removeItemFromListWithStoreKey:(NSString *)storeKey
                               itemKey:(NSString *)itemKey
                             itemValue:(NSString *)itemValue
{
    NSMutableArray<NSMutableDictionary<NSString *, id> *> *ls = [self getListWithStoreKey:storeKey];
    for (NSMutableDictionary<NSString *, id> *dict in ls) {
        if ([dict.allKeys containsObject:itemKey]) {
            if ([dict[itemKey] isEqualToString:itemValue]) {
                [ls removeObject:dict];
                break;
            }
        }
    }
}

- (void)updateItemInListWithStoreKey:(NSString *)storeKey
                               itemKey:(NSString *)itemKey
                           itemValue:(NSString *)itemValue
                             itemNew:(NSMutableDictionary<NSString *, id> *)newItem
{
    NSMutableArray<NSMutableDictionary<NSString *, id> *> *ls = [self getListWithStoreKey:storeKey];
    for (NSMutableDictionary<NSString *, id> *dict in ls) {
        if ([dict.allKeys containsObject:itemKey]) {
            if ([dict[itemKey] isEqualToString:itemValue]) {
                [ls removeObject:dict];
                break;
            }
        }
    }
    [ls addObject:newItem];
    [self setKVWithKey:storeKey value:jsonEncodeWithValue(ls)];
}

- (NSMutableArray<NSMutableDictionary<NSString *, id> *> *)getListWithStoreKey:(NSString *)storeKey
{
    NSMutableArray<NSMutableDictionary<NSString *, id> *> *res = [[NSMutableArray alloc] init];
    NSString *str = [self getKVWithKey:storeKey];
    if (str) {
        res = jsonDecodeWithString(str);
    }
    return res;
}

@end
