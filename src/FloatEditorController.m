//
//  FloatEditorController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FloatEditorController.h"


@implementation FloatEditorController

+ (NSString *)typeHandler
{
    return @"Tf";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)viewWillDisappear:(BOOL)animated
{
    NSNumber *newValue = [NSNumber numberWithFloat:[[numberField text] floatValue]];
    [self.object setValue:newValue forKey:self.propertyName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    numberField = [[TTTextFieldTableField alloc] initWithTitle:self.propertyName text:[NSString stringWithFormat:@"%.1f", [[self.object valueForKey:self.propertyName] floatValue]]];
    numberField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return [TTListDataSource dataSourceWithObjects:numberField, nil];
}

#pragma mark -

- (void)dealloc
{
    [numberField release];
    [super dealloc];
}


@end
