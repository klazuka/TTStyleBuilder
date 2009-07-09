//
//  StylePreview.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StylePreview.h"

@implementation StylePreview

@synthesize size;
@synthesize fillColor;
@synthesize textForDelegate;
@synthesize imageForDelegate;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        size = frame.size;
        fillColor = [self.backgroundColor retain];
        textForDelegate = [[NSString alloc] initWithUTF8String:"Three20"];
        imageForDelegate = [TTIMAGE(@"bundle://Three20.bundle/images/nextIcon.png") retain];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"size"]) {
        self.width = [value CGSizeValue].width;
        self.height = [value CGSizeValue].height;
        self.centerX = self.superview.centerX;
    } else if ([key isEqualToString:@"fillColor"]) {
        self.backgroundColor = value;
    }
    
    [self setNeedsDisplay];  // redraw whenever one of our properties are modified
}

- (void)drawRect:(CGRect)rect
{
    // For some reason, if you don't explicitly fill the gfx context
    // before you render the style, when you do something like
    // setNeedsDisplay, the style will be rendered *over* the old
    // image buffer. So if I were Joe, I would do this in -[TTView drawRect:]
    // but since I'm not, I'll just do it here in my subclass.
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.backgroundColor setFill];
    CGContextFillRect(ctx, rect);
    [super drawRect:rect];
}
- (NSString*)textForLayerWithStyle:(TTStyle*)style
{
    return textForDelegate;
}

- (UIImage*)imageForLayerWithStyle:(TTStyle*)style
{
    return imageForDelegate;
}

- (void)dealloc
{
    [fillColor release];
    [textForDelegate release];
    [imageForDelegate release];
    [super dealloc];
}

@end
