//
//  PropertyFieldCell.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyFieldCell.h"
#import "PropertyField.h"
#import "objc/runtime.h"

@implementation PropertyFieldCell

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:identifier]) {
        valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [valueLabel setText:@"unset"];
        [valueLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [valueLabel setBackgroundColor:[UIColor clearColor]];
        [valueLabel setHighlightedTextColor:[UIColor whiteColor]];
        [valueLabel setTextAlignment:UITextAlignmentRight];
        [valueLabel setTextColor:[UIColor colorWithRed:0.20f green:0.31f blue:0.52f alpha:1.0f]];
        [self.contentView addSubview:valueLabel];
	}
	return self;
}

- (void)dealloc
{
    [valueLabel release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewCell

- (void)setObject:(id)object
{
    if (_field != object) {
        [super setObject:object];
        [valueLabel setText:[object valueDescription]];
        
        // size the blue "value" label such that it does not occlude the property name
        NSString *propertyName = [object text];
        CGSize labelSize = [propertyName sizeWithFont:_label.font];
        CGFloat padLeft = 25.f;
        CGFloat padRight = padLeft + 30.f;
        CGFloat cellWidth = 320.f;  // TODO get this from somewhere else
        CGFloat cellHeight = 44.f;  // TODO get this from somewhere else

        [valueLabel setFrame:
            CGRectMake(
                       _label.left + labelSize.width + padLeft, 
                       _label.top, 
                       cellWidth - labelSize.width - padRight, 
                       cellHeight)];
    }
}

@end