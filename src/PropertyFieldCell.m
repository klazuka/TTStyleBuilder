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
#import "NewObjectPickerController.h"

@implementation PropertyFieldCell

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
        
        newValueButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [newValueButton setTitle:@"New" forState:UIControlStateNormal];
        [newValueButton addTarget:self action:@selector(newValueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:newValueButton];
	}
	return self;
}

- (void)newValueButtonTapped
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewObjectValueButtonTappedNotification object:self.object];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewCell

- (void)setObject:(id)object
{
    if (_field != object) {
        [super setObject:object];
        
        if (!object)
            return;
        [valueLabel setText:[object valueDescription]];
        
        // size the blue "value" label such that it does not occlude the property name
        NSString *propertyName = [object text];
        CGSize propertyNameSize = [propertyName sizeWithFont:_label.font];
        CGFloat padLeft = 65.f;
        CGFloat padRight = padLeft + 30.f;
        CGFloat cellWidth = 320.f;  // TODO get this from somewhere else
        CGFloat cellHeight = 44.f;  // TODO get this from somewhere else
        
        [valueLabel setFrame:
         CGRectMake(
                    propertyNameSize.width + padLeft, 
                    0.f, 
                    cellWidth - propertyNameSize.width - padRight, 
                    cellHeight)];

        // Conditionally hide/show the new value button based on the property type.
        // TODO this is an ugly hack. In the initialization of my TTStyle and TTShape categories
        // I should register the base class with some global registry that this class than
        // queries to determine whether to show or hide the button.
        NSRange r1 = [[object propertyType] rangeOfString:@"Style"];
        NSRange r2 = [[object propertyType] rangeOfString:@"Shape"];
        BOOL hidden = r1.location == NSNotFound && r2.location == NSNotFound;
        [newValueButton setHidden:hidden];
        
        if (!hidden) {
            CGFloat buttonWidth = 44.f;
            CGRect f = CGRectInset([valueLabel frame], 0.f, 4.f);
            f.origin.x -= buttonWidth + 6.f;
            f.size.width = buttonWidth;
            [newValueButton setFrame:f];            
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [newValueButton release];
    [valueLabel release];
	[super dealloc];
}

@end