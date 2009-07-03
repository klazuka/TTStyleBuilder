//
//  FloatEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FloatEditor.h"


@implementation FloatEditor

@synthesize object, propertyName;

+ (NSString *)atEncodeTypeHandler
{
    return @"Tf";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

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
    [object release];
    [propertyName release];
    [numberField release];
    [super dealloc];
}


@end
