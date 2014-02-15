//
//  ExpiringCache.m
//
//  Created by Aaron Brager on 10/23/13.

#import "AGBExpiringCache.h"

@implementation AGBExpiringCache

- (instancetype) init {
    self = [super init];

    if (self) {
        self.cache = [[NSCache alloc] init];
        self.expiryTimeInterval = 3600;  // default 1 hour
    }

    return self;
}

- (id)objectForKey:(id)key {
    @try {
        NSObject <AGBExpiringCacheItem> *object = [self.cache objectForKey:key];

        if (object) {
            NSTimeInterval timeSinceCache = fabs([object.expiringCacheItemDate timeIntervalSinceNow]);
            if (timeSinceCache > self.expiryTimeInterval) {
                [self.cache removeObjectForKey:key];
                return nil;
            }
        }

        return object;
    }

    @catch (NSException *exception) {
        return nil;
    }
}

- (void)setObject:(NSObject <AGBExpiringCacheItem> *)obj forKey:(id)key {
    obj.expiringCacheItemDate = [NSDate date];
    [self.cache setObject:obj forKey:key];
}

@end
