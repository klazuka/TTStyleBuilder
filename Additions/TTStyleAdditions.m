//
//  TTStyleAdditions.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleAdditions.h"
#import "objc/runtime.h"

@implementation TTStyle (TTStyleBuilderAdditions)

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


@implementation TTSolidFillStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTSolidFillStyle styleWithColor:RGBACOLOR(0, 128, 256, 1.0) next:nil]; }
@end

@implementation TTMaskStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTMaskStyle styleWithMask:TTIMAGE(@"bundle://Three20.bundle/images/nextIcon.png") next:nil]; }
@end

@implementation TTSolidBorderStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTSolidBorderStyle styleWithColor:[UIColor blackColor] width:6.f next:nil]; }
@end

@implementation TTTextStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:20.f] color:[UIColor blackColor] next:nil]; }
@end

@implementation TTInsetStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTInsetStyle styleWithInset:UIEdgeInsetsMake(6.f, 10.f, 6.f, 10.f) next:nil]; }
@end

@implementation TTLinearGradientFillStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTLinearGradientFillStyle styleWithColor1:[UIColor orangeColor] color2:[UIColor yellowColor] next:nil]; }
@end

@implementation TTFourBorderStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTFourBorderStyle styleWithTop:[UIColor blackColor] right:[UIColor blackColor] bottom:[UIColor blackColor] left:[UIColor blackColor] width:2.f next:nil]; }
@end

@implementation TTBevelBorderStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTBevelBorderStyle styleWithColor:[UIColor whiteColor] width:4.f next:nil]; }
@end

@implementation TTShapeStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:nil]; }
@end

@implementation TTContentStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTContentStyle styleWithNext:nil]; }
@end

@implementation TTReflectiveFillStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTReflectiveFillStyle styleWithColor:[UIColor redColor] next:nil]; }
@end

@implementation TTPartStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTPartStyle styleWithName:@"FooPart" style:[TTImageStyle styleWithImage:TTIMAGE(@"bundle://Three20.bundle/images/nextIcon.png") next:nil] next:nil]; }
@end

@implementation TTImageStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTImageStyle styleWithImageURL:@"http://1.bp.blogspot.com/_lULSdWJgqfQ/R84h4N149aI/AAAAAAAAABI/rO81Veof-T8/s400/blah.jpg" next:nil]; }
@end

@implementation TTBoxStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(12.f, 12.f, 12.f, 12.f) next:nil]; }
@end

@implementation TTShadowStyle (TTStyleBuilderAdditions)
+ (TTStyle *)prototypicalInstance { return [TTShadowStyle styleWithColor:[UIColor blackColor] blur:4.f offset:CGSizeMake(2.f, 4.f) next:nil]; }
@end













