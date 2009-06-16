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

- (NSArray *)pipeline;          // the rendering pipeline from this style onwards, flattened into an array of TTStyles.
- (NSString *)className;        // this style's class name.

@end
