//
//  NSObjectAdditions.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSObjectAdditions.h"
#import "objc/runtime.h"

// I had to copy NSDebug.h from the simulator's Foundation framework to this project
// in order to use it on both the simulator and the device.
#import "NSDebug.h"

@implementation NSObject (TTStyleBuilderAdditions)

- (NSString *)className
{
  return NSStringFromClass([self class]);
}

// -------------------------------------------------------------------------------
#pragma mark In Memory Object URLS

+ (NSString *)inMemoryUrlScheme
{
    return @"memory";   // arbitrary
}

+ (NSString *)inMemoryUrlHost
{
    return @"NSObject"; // arbitrary
}

+ (id<TTPersistable>)fromURL:(NSURL*)url
{
    id obj = (id)[[[url path] substringFromIndex:1] intValue];
    
    // Check that the object is still alive. Please note that this check
    // is not guaranteed to work 100% of the time because after the object
    // has been freed, the OS may re-allocate that memory, in which case
    // this check would pass. If you are having weird memory errors,
    // please set the NSZombieEnabled and NSDeallocateZombies environment
    // variables to prevent the reuse of allocated objects.
    // (http://stackoverflow.com/questions/535060/how-to-add-nsdebug-h-and-use-nszombie-in-iphone-sdk)
    NSAssert1(!NSIsFreedObject(obj), @"FATAL -[NSObject fromURL:] tried to load in-memory object for url %@ but the object has been freed.", url);
    
    return obj;
}

- (NSString *)viewURL
{
    return [NSString stringWithFormat:@"%@://%@/%d", [[self class] inMemoryUrlScheme], [[self class] inMemoryUrlHost], self];
}

@end
