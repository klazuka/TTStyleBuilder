//
//  UIColorAdditions.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIColorAdditions.h"


@implementation UIColor (TTStyleBuilderAdditions)

- (CGFloat)alpha 
{
    const CGFloat* rgba = CGColorGetComponents(self.CGColor);
    return rgba[3];
}

@end
