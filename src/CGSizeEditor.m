//
//  CGSizeEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CGSizeEditor.h"


@implementation CGSizeEditor

@synthesize object, propertyName;

+ (NSString *)atEncodeTypeHandler
{
    return @"T{CGSize=\"width\"f\"height\"f}";
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

- (void)dealloc
{
    [object release];
    [propertyName release];
    [widthField release];
    [heightField release];
    [super dealloc];
}


@end
