//
//  IntEditorController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IntEditorController.h"


@implementation IntEditorController

+ (NSString *)typeHandler
{
    return @"Ti";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)viewWillDisappear:(BOOL)animated
{
    NSNumber *newValue = [NSNumber numberWithInt:[[numberField text] intValue]];
    [self.object setValue:newValue forKey:self.propertyName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    numberField = [[TTTextFieldTableField alloc] initWithTitle:self.propertyName text:[NSString stringWithFormat:@"%d", [[self.object valueForKey:self.propertyName] intValue]]];
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    return [TTListDataSource dataSourceWithObjects:numberField, nil];
}

@end
