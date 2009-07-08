//
//  UIEdgeInsetsEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIEdgeInsetsEditor.h"


@implementation UIEdgeInsetsEditor

@synthesize object, propertyName;

+ (NSString *)atEncodeTypeHandler
{
    return @"T{UIEdgeInsets=\"top\"f\"left\"f\"bottom\"f\"right\"f}";
}

- (void)updatePropertyValue
{
    NSValue *newValue = [NSValue valueWithUIEdgeInsets:
                         UIEdgeInsetsMake(
                                          [[topField text] floatValue], 
                                          [[leftField text] floatValue],
                                          [[bottomField text] floatValue],
                                          [[rightField text] floatValue])];
    [self.object setValue:newValue forKey:self.propertyName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
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
    [self updatePropertyValue];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    UIEdgeInsets insets = [[self.object valueForKey:self.propertyName] UIEdgeInsetsValue];
    
    topField = [[TTTextFieldTableField alloc] initWithTitle:@"Top" text:[NSString stringWithFormat:@"%.1f", insets.top]];
    topField.delegate = self;
    topField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    topField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    leftField = [[TTTextFieldTableField alloc] initWithTitle:@"Left" text:[NSString stringWithFormat:@"%.1f", insets.left]];
    leftField.delegate = self;
    leftField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    leftField.clearButtonMode = UITextFieldViewModeWhileEditing;

    bottomField = [[TTTextFieldTableField alloc] initWithTitle:@"Bottom" text:[NSString stringWithFormat:@"%.1f", insets.bottom]];
    bottomField.delegate = self;
    bottomField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    bottomField.clearButtonMode = UITextFieldViewModeWhileEditing;

    rightField = [[TTTextFieldTableField alloc] initWithTitle:@"Right" text:[NSString stringWithFormat:@"%.1f", insets.right]];
    rightField.delegate = self;
    rightField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    rightField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return [TTListDataSource dataSourceWithObjects:topField, leftField, bottomField, rightField, nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
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
    [topField release];
    [leftField release];
    [bottomField release];
    [rightField release];
    [super dealloc];
}


@end
