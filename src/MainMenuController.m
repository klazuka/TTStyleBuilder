//
//  MainMenuController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainMenuController.h"

@implementation MainMenuController

// -------------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)loadView
{
    self.tableViewStyle = UITableViewStyleGrouped;
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Main Menu";
    [[NSNotificationCenter defaultCenter] postNotificationName:kEraseStylePreviewNotification object:nil];
}

// -------------------------------------------------------------------------------------
#pragma mark TTTableViewController

- (void)createModel
{
    self.dataSource = [TTListDataSource dataSourceWithObjects:
                       [TTTableTextItem itemWithText:@"Create New Style" URL:@"tt://style/pipeline/edit/(init)"],
                       [TTTableTextItem itemWithText:@"Explore a Stylesheet" URL:@"tt://styleSheet/browse"],
                       [TTTableTextItem itemWithText:@"Load from Disk" URL:@"tt://style/archives/browse"],
                       nil];
}

@end
