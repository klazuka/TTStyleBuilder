//
//  StyleConfigController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleConfigController.h"

@implementation StyleConfigController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
}

@end
