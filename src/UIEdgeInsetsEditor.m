//
//  UIEdgeInsetsEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIEdgeInsetsEditor.h"


@implementation UIEdgeInsetsEditor

+ (NSString *)typeHandler
{
    return @"T{UIEdgeInsets=\"top\"f\"left\"f\"bottom\"f\"right\"f}";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)viewWillDisappear:(BOOL)animated
{
    NSValue *newValue = [NSValue valueWithUIEdgeInsets:
                         UIEdgeInsetsMake(
                                            [[topField text] floatValue], 
                                            [[leftField text] floatValue],
                                            [[bottomField text] floatValue],
                                            [[rightField text] floatValue])];
    [self.object setValue:newValue forKey:self.propertyName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    UIEdgeInsets insets = [[self.object valueForKey:self.propertyName] UIEdgeInsetsValue];
    
    topField = [[TTTextFieldTableField alloc] initWithTitle:@"Top" text:[NSString stringWithFormat:@"%.1f", insets.top]];
    topField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    topField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    leftField = [[TTTextFieldTableField alloc] initWithTitle:@"Left" text:[NSString stringWithFormat:@"%.1f", insets.left]];
    leftField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    leftField.clearButtonMode = UITextFieldViewModeWhileEditing;

    bottomField = [[TTTextFieldTableField alloc] initWithTitle:@"Bottom" text:[NSString stringWithFormat:@"%.1f", insets.bottom]];
    bottomField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    bottomField.clearButtonMode = UITextFieldViewModeWhileEditing;

    rightField = [[TTTextFieldTableField alloc] initWithTitle:@"Right" text:[NSString stringWithFormat:@"%.1f", insets.right]];
    rightField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    rightField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return [TTListDataSource dataSourceWithObjects:topField, leftField, bottomField, rightField, nil];
}

- (void) dealloc
{
    [topField release];
    [leftField release];
    [bottomField release];
    [rightField release];
    [super dealloc];
}


@end
