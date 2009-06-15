//
//  StyleConfigController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleConfigController.h"


@implementation StyleConfigController

@synthesize style;

- (id)initForStyle:(TTStyle *)aStyle
{
    if ((self = [super init])) {
        style = [aStyle retain];
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

- (void)showObject:(id)object inView:(NSString*)viewType withState:(NSDictionary*)state
{
    [super showObject:object inView:viewType withState:state];
    KLog(@"showObject:%@", object);
    self.style = object;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *propNames = [NSMutableArray array];
    
    for (NSString *name in [style propertyNames]) {
        [propNames addObject:[[[TTTableField alloc] initWithText:name url:nil] autorelease]];
    }
    
    return [TTListDataSource dataSourceWithItems:propNames];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [style release];
    [super dealloc];
}

@end
