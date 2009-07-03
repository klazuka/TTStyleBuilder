//
//  StringEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StringEditor.h"


@implementation StringEditor

@synthesize object, propertyName;

+ (NSString *)typeHandler
{
    return @"T@\"NSString\"";
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
    [self.object setValue:[stringField text] forKey:self.propertyName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    stringField = [[TTTextFieldTableField alloc] initWithTitle:self.propertyName text:[self.object valueForKey:self.propertyName]];
    stringField.keyboardType = UIKeyboardTypeAlphabet;
    stringField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
    return [TTListDataSource dataSourceWithObjects:stringField, nil];
}

- (void)dealloc
{
    [object release];
    [propertyName release];
    [stringField release];
    [super dealloc];
}


@end
