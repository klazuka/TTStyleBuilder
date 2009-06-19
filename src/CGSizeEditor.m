//
//  CGSizeEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CGSizeEditor.h"


@implementation CGSizeEditor

+ (NSString *)typeHandler
{
    return @"T{CGSize=\"width\"f\"height\"f}";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)viewWillDisappear:(BOOL)animated
{
    NSValue *newValue = [NSValue valueWithCGSize:CGSizeMake([[widthField text] floatValue], [[heightField text] floatValue])];
    [self.object setValue:newValue forKey:self.propertyName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    CGSize size = [[self.object valueForKey:self.propertyName] CGSizeValue];
    
    widthField = [[TTTextFieldTableField alloc] initWithTitle:@"Width" text:[NSString stringWithFormat:@"%.1f", size.width]];
    widthField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    widthField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    heightField = [[TTTextFieldTableField alloc] initWithTitle:@"Height" text:[NSString stringWithFormat:@"%.1f", size.height]];
    heightField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    heightField.clearButtonMode = UITextFieldViewModeWhileEditing;

    return [TTListDataSource dataSourceWithObjects:widthField, heightField, nil];
}

- (void) dealloc
{
    [widthField release];
    [heightField release];
    [super dealloc];
}


@end
