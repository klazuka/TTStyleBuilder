//
//  StyleStructureController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleStructureController.h"

@implementation StyleStructureController

- (id)initForRootStyle:(TTStyle *)style
{
    if ((self = [super init])) {
        rootStyle = [style retain];
        self.title = @"Style Builder";
    }
    return self;
}

- (id)init
{
    // choose an arbitrary style from the system as an example.
    return [self initForRootStyle:TTSTYLE(tabBar)];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *styleNames = [NSMutableArray array];
    
    for (TTStyle *style in [rootStyle pipeline]) {
        NSString *name = [style className];
        NSString *url = [NSString stringWithFormat:@"%@?style_config", [style viewURL]];
        [styleNames addObject:[[[TTTableField alloc] initWithText:name url:url] autorelease]];
    }
    
    return [TTListDataSource dataSourceWithItems:styleNames];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [rootStyle release];
    [super dealloc];
}


@end
