//
//  NSObjectAdditions.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSObjectAdditions.h"

@implementation NSObject (TTStyleBuilderAdditions)

- (NSString *)className
{
  return NSStringFromClass([self class]);
}

@end
