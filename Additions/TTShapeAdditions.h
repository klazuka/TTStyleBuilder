//
//  TTShapeAdditions.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Three20/Three20.h"

/*
 *  Provide an example object for each TTShape subclass.
 *  This makes it easy for the TTStyleBuilder tool to instantiate
 *  new TTShape objects at runtime.
 */
@interface TTRectangleShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance;
@end

@interface TTRoundedRectangleShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance;
@end

@interface TTRoundedRightArrowShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance;
@end

@interface TTRoundedLeftArrowShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance;
@end

@interface TTSpeechBubbleShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance;
@end

