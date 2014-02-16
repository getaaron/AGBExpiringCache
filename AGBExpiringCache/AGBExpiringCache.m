//
//  AGBExpiringCache.m
//
//  Created by Aaron Brager on 10/23/13.

#import "AGBExpiringCache.h"

@interface AGBExpiringCache ()
@property (atomic, strong) NSMutableDictionary *objectExpireDates;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, assign) NSTimeInterval expiryTimeInterval;
@end

@implementation AGBExpiringCache

// Designated initializer
- (instancetype)initWithCache:(NSCache *)cache expireTime:(NSTimeInterval)expireTime;
{
    if (self = [super init]) {
        self.cache = cache;
        self.objectExpireDates = [NSMutableDictionary dictionary];
        self.expiryTimeInterval = expireTime;
    }
    
    return self;
}

- (instancetype)initWithCacheExpireTime:(NSTimeInterval)expireTime;
{
    return [self initWithCache:[NSCache new] expireTime:expireTime];
}

- (instancetype) init {
    return [self initWithCacheExpireTime:3600]; // default to 1 hour
}

- (id)objectForKey:(id)key {
    @try {
        NSObject *object = [self.cache objectForKey:key];
        
        if (object) {
            
            NSDate *expiringCacheItemDate = [self expiringCacheItemDateForKey:key];
            
            if (expiringCacheItemDate) {
                NSTimeInterval timeSinceCache = fabs([expiringCacheItemDate timeIntervalSinceNow]);
                
                if (timeSinceCache > self.expiryTimeInterval) {
                    [self removeObjectForKey:key];
                    return nil; // if we don't reach here then we will return the object
                }
            }else{
                // For some reason there was an object in the cache
                // without an expiration date. Should we expire it?
                [self removeObjectForKey:key];
                return nil;
            }
        }
        
        if (object) {
            NSLog(@"[CACHE HIT][%@] %@", key, object);
        }else{
            NSLog(@"[CACHE MISS][%@]", key);
        }
        
        
        return object;
    }
    
    @catch (NSException *exception) {
        return nil;
    }
}

- (void)setObject:(NSObject *)obj forKey:(id)key {
    
    NSLog(@"[CACHE STORE][%@] %@", key, obj);
    
    [self setExpiringCacheItemDateForKey:key];
    [self.cache setObject:obj forKey:key];
}

- (void)removeObjectForKey:(id)key
{
    NSLog(@"[CACHE DELETION][%@]", key);
    
    [self removeCacheDateForKey:key];
    [self.cache removeObjectForKey:key];
}

// Methods for storing and retrieving the times objects are stored for expiration

- (NSDate *)expiringCacheItemDateForKey:(id)key
{
    return self.objectExpireDates[key];
}

- (void)setExpiringCacheItemDateForKey:(id)key
{
    self.objectExpireDates[key] = [NSDate date];
}

- (void)removeCacheDateForKey:(id)key
{
    [self.objectExpireDates removeObjectForKey:key];
}

@end