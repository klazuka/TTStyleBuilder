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

- (void)updatePropertyValue
{
    NSValue *newValue = [NSValue valueWithCGSize:CGSizeMake([[widthField text] floatValue], [[heightField text] floatValue])];
    [self.object setValue:newValue forKey:self.propertyName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
}

// ------------------------------------------------------------------
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

// ------------------------------------------------------------------
#pragma mark TTTableViewController

- (void)createModel
{
    CGSize size = [[self.object valueForKey:self.propertyName] CGSizeValue];
    
    widthField = [[UITextField alloc] init];
    widthField.text = [NSString stringWithFormat:@"%.1f", size.width];
    widthField.delegate = self;
    widthField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    widthField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    heightField = [[UITextField alloc] init];
    heightField.text = [NSString stringWithFormat:@"%.1f", size.height];
    heightField.delegate = self;
    heightField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    heightField.clearButtonMode = UITextFieldViewModeWhileEditing;

    self.dataSource = [TTListDataSource dataSourceWithObjects:
                       [TTTableControlItem itemWithCaption:@"Width" control:widthField],
                       [TTTableControlItem itemWithCaption:@"Height" control:heightField],
                       nil];
}

// ------------------------------------------------------------------
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
    [widthField release];
    [heightField release];
    [super dealloc];
}


@end
