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

+ (NSString *)atEncodeTypeHandler
{
    return @"T@\"NSString\"";
}

- (void)updatePropertyValue
{
    [self.object setValue:[stringField text] forKey:self.propertyName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
}

// -------------------------------------------------------------------------------------
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
    [self updatePropertyValue];
}

// -------------------------------------------------------------------------------------
#pragma mark TTTableViewController

- (void)createModel
{
    stringField = [[UITextField alloc] init];
    stringField.placeholder = self.propertyName;
    stringField.text = [self.object valueForKey:self.propertyName];
    stringField.font = TTSTYLEVAR(font);
    stringField.delegate = self;
    stringField.keyboardType = UIKeyboardTypeAlphabet;
    stringField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
    self.dataSource = [TTListDataSource dataSourceWithObjects:
                       [TTTableControlItem itemWithCaption:@"String" control:stringField],
                       nil];
}

// -------------------------------------------------------------------------------------
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(updatePropertyValue) withObject:nil afterDelay:0.f]; // Wait until the next iteration of the runloop so that when we read the [textField text] property, we read the new value (which isn't yet visible at this time).
    return YES;
}


#pragma mark -

- (void)dealloc
{
    [object release];
    [propertyName release];
    [stringField release];
    [super dealloc];
}


@end
