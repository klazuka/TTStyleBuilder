//
//  StyleStructureController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleStructureController.h"

@implementation StyleStructureController

- (id)initForStyle:(TTStyle *)style
{
    if ((self = [super init])) {
        rootStyle = [style retain];
    }
    return self;
}

- (id)init
{
    // choose an arbitrary style from the system as an example.
    return [self initForStyle:TTSTYLE(tabBar)];
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
    
    for (NSString *name in [rootStyle pipelineClassNames]) {
        [styleNames addObject:[[[TTTableField alloc] initWithText:name url:nil] autorelease]];
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
