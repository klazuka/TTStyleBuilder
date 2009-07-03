//
//  SettingsController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

- (id)init
{
    if ((self = [super init])) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)] autorelease];
        self.showInheritedProperties = NO;  // We don't want to allow the user to see/edit the inherited TTView/UIView superclass properties.
    }
    return self;
}

- (void)dismiss
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end



















