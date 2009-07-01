//
//  TTStyleAdditions.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"

/*
 *  Convenience methods for working with TTStyle's Objective-C runtime state.
 */
@interface TTStyle (TTStyleBuilderAdditions)

- (NSArray *)pipeline;          // the rendering pipeline from this style onwards, flattened into an array of TTStyles.

@end

/*
 *  Provide an example object for each TTStyle subclass.
 *  This makes it easy for the TTStyleBuilder tool to instantiate
 *  new TTStyle objects at runtime.
 */
@interface TTSolidFillStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTMaskStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTSolidBorderStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTTextStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTInsetStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTLinearGradientFillStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTFourBorderStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTBevelBorderStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTShapeStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTContentStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTReflectiveFillStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTPartStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTImageStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTBoxStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end

@interface TTShadowStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance;
@end
