//
//  ExpiringCache.h
//
//  Created by Aaron Brager on 10/23/13.

#import <Foundation/Foundation.h>

@protocol AGBExpiringCacheItem <NSObject>

@property (nonatomic, strong) NSDate *expiringCacheItemDate;

@end

@interface AGBExpiringCache : NSObject

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, assign) NSTimeInterval expiryTimeInterval;

- (id)objectForKey:(id)key;
- (void)setObject:(NSObject <AGBExpiringCacheItem> *)obj forKey:(id)key;

@end