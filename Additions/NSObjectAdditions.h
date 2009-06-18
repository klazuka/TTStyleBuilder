//
//  NSObjectAdditions.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"

@interface NSObject (TTStyleBuilderAdditions)

- (NSString *)className;        // this object's class name.

// added by Keith to support URL representation of in-memory objects
+ (NSString *)inMemoryUrlScheme;
+ (NSString *)inMemoryUrlHost;
+ (id<TTPersistable>)fromURL:(NSURL*)url;
- (NSString *)viewURL;

@end
