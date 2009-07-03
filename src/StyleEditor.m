//
//  StyleEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleEditor.h"

@implementation StyleEditor

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ValueEditor protocol

+ (NSString *)atEncodeTypeHandler
{
    return @"T@\"TTStyle\"";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
}

@end
