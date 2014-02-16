//
//  ExpiringCache.h
//
//  Created by Aaron Brager on 10/23/13.

#import <Foundation/Foundation.h>

@interface AGBExpiringCache : NSObject

- (instancetype)initWithCacheExpireTime:(NSTimeInterval)expireTime;
- (instancetype)initWithCache:(NSCache *)cache expireTime:(NSTimeInterval)expireTime;

- (id)objectForKey:(id)key;
- (void)setObject:(NSObject *)obj forKey:(id)key;

@end