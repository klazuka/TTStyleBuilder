//
//  TTStyleAdditions.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"

//
//  Convenience methods for working with TTStyle's Objective-C runtime state.
//
@interface TTStyle (TTStyleBuilderAdditions)

- (NSArray *)pipelineClassNames;    // the name of each style's class in the order of the rendering pipeline.
- (NSString *)className;            // this style's class's name
- (NSArray *)propertyNames;         // the properties declared by the receiver's class (but NOT its superclasses)

@end
