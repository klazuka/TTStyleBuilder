//
//  TTStyleAdditions.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleAdditions.h"
#import "objc/runtime.h"
#import "TTStyleBuilderGlobal.h"

@implementation TTStyle (TTStyleBuilderAdditions)

- (NSString *)className
{
    return [NSString stringWithCString:class_getName([self class]) encoding:NSUTF8StringEncoding];
}

// a private helper method for accumulating values as we walk the linked list
- (void)pipelineHelper:(NSMutableArray *)names
{
    [names addObject:self];
    
    if (!self.next)
        return;
    
    [self.next pipelineHelper:names];
}

- (NSArray *)pipeline
{
    NSMutableArray *styles = [NSMutableArray array];
    [self pipelineHelper:styles];
    return styles;
}

@end
