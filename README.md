AGBExpiringCache
================

An Objective-C memory cache that invalidates items after a certain time interval.

The implementation uses `NSCache`, so the cache may also be invalidated on system memory pressure.

###Usage

1. Create an `AGBExpiringCache` and optionally set its `expiryTimeInterval`.  The default is `3600` (1 hour).
2. Make your model objects conform to the `AGBExpiringCacheItem` protocol by adding this property:

    `@property (nonatomic, strong) NSDate *expiringCacheItemDate;`

3. Store objects when you get them, and retrieve them when you want them!

###Sample Code

	#import "AGBExpiringCache.h"

	@property (nonatomic, strong) AGBExpiringCache *accountsCache;

	- (void) doSomething {
	    if (!self.accountsCache) {
	        self.accountsCache = [[AGBExpiringCache alloc] init];
	        self.accountsCache.expiryTimeInterval = 7200; // 2 hours
	    }
	
	    // add an object to the cache
	    [self.accountsCache setObject:newObj forKey:@"some key"];
	
	    // get an object
	    SomeModelObject *cachedObj = [self.accountsCache objectForKey:@"some key"];
	    if (!cachedObj) {
	        // create a new one, either the old one expired or we've never gotten it
	    }
	}
