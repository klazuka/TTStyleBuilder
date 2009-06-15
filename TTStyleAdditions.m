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
- (void)pipelineClassNamesHelper:(NSMutableArray *)names
{
    [names addObject:[self className]];
    
    if (!self.next)
        return;
    
    [self.next pipelineClassNamesHelper:names];
}

- (NSArray *)pipelineClassNames
{
    NSMutableArray *names = [NSMutableArray array];
    [self pipelineClassNamesHelper:names];
    return names;
}

- (NSArray *)propertyNames
{
    NSMutableArray *names = [NSMutableArray array];
    
    unsigned int numProperties = -1;
    objc_property_t *properties = class_copyPropertyList([self class], &numProperties);
    if (!properties)
        return [NSArray array];
    
    for (unsigned int i = 0; i < numProperties; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        KLog(@"Style %@ has property named %@", name);
        [names addObject:name];
    }
    
    free(properties);
    
    return names;
}

@end
