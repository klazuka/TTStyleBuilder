//
//  TTShapeAdditions.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTShapeAdditions.h"
#import "objc/runtime.h"

@implementation TTRectangleShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance { return [TTRectangleShape shape]; }
@end

@implementation TTRoundedRectangleShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance { return [TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED]; }
@end

@implementation TTRoundedRightArrowShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance { return [TTRoundedRightArrowShape shapeWithRadius:5]; }
@end

@implementation TTRoundedLeftArrowShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance { return [TTRoundedLeftArrowShape shapeWithRadius:5]; }
@end

@implementation TTSpeechBubbleShape (TTStyleBuilderAdditions)
+ (TTShape *)prototypicalInstance { return [TTSpeechBubbleShape shapeWithRadius:5 pointLocation:60 pointAngle:90 pointSize:CGSizeMake(20,10)]; }
@end
