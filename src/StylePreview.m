//
//  StylePreview.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StylePreview.h"

@implementation StylePreview
- (void)drawRect:(CGRect)rect
{
    // for some reason, if you don't explicitly fill the gfx context
    // before you render the style, when you do something like
    // setNeedsDisplay, the style will be rendered *over* the old
    // image buffer. So if I were Joe, I would do this in -[TTView drawRect:]
    // but since I'm not, I'll just do it here in my subclass.
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor] setFill];
    CGContextFillRect(ctx, rect);
    [super drawRect:rect];
}
- (NSString*)textForLayerWithStyle:(TTStyle*)style
{
    return @"42";
}

- (UIImage*)imageForLayerWithStyle:(TTStyle*)style
{
    return TTIMAGE(@"bundle://Three20.bundle/images/nextIcon.png");
}
@end
