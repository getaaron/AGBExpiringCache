//
//  AGBViewController.m
//  AGBExpiringCacheDemo
//
//  Created by Aaron Brager on 2/14/14.
//  Copyright (c) 2014 Aaron Brager. All rights reserved.
//

#import "AGBViewController.h"
#import "AGBExpiringCache.h"

@interface SomeModelObject : NSObject <AGBExpiringCacheItem>

@property (nonatomic, strong) NSDate *expiringCacheItemDate;

@end

@implementation SomeModelObject

@end

@interface AGBViewController ()

@property (nonatomic, strong) AGBExpiringCache *expiringCache;

@end

@implementation AGBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.expiringCache = [[AGBExpiringCache alloc] init];

    // Expire objects after 60 seconds
    self.expiringCache.expiryTimeInterval = 60;
}

- (IBAction)tryItPressed:(UIButton *)sender {
//
// <--- Set a breakpoint here
//

    SomeModelObject *modelObject = [[SomeModelObject alloc] init];

    static NSString *exampleKey = @"Example Object";

    // Add the object to the cache…
    [self.expiringCache setObject:modelObject forKey:exampleKey];

    // Get the object…
    SomeModelObject *myObject = [self.expiringCache objectForKey:exampleKey];

    // Got it!
    NSLog(@"%@", myObject);

    // Simulate the object being older than 60 seconds
    myObject.expiringCacheItemDate = [[NSDate date] dateByAddingTimeInterval:-100];

    // Now try getting it again…
    SomeModelObject *oldObject = [self.expiringCache objectForKey:exampleKey];

    // It's gone now!
    NSLog(@"%@", oldObject);
}
@end
