//
//  StyleStructureController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleStructureController.h"
#import "StylePreview.h"
#import "StyleStructureDataSource.h"
#import "AddStyleController.h"

@implementation StyleStructureController

- (id)initForRootStyle:(TTStyle *)style
{
    if ((self = [super init])) {
        rootStyle = [style retain];
        self.title = @"Style Builder";
        self.navigationItem.leftBarButtonItem = [self editButtonItem];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(displayAddStylePicker)] autorelease];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawStylePreview) name:kRefreshStylePreviewNotification object:nil];
    }
    return self;
}

- (id)init
{
    // choose an arbitrary style from the system as an example.
    return [self initForRootStyle:TTSTYLE(tabBar)];
}

- (void)displayAddStylePicker
{
    AddStyleController *controller = [[[AddStyleController alloc] init] autorelease];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addStyle:(TTStyle *)style
{
    NSString *name = [style className];
    NSString *url = [NSString stringWithFormat:@"%@?style_config", [style viewURL]];
    
    // update the table view
    [((TTListDataSource*)self.dataSource).items addObject:[[[TTTableField alloc] initWithText:name url:url] autorelease]];
    [self.tableView reloadData];
    
    // add the new style to the end of the rendering pipeline
    NSArray *pipeline = [rootStyle pipeline];
    [[pipeline lastObject] setNext:style];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
}

- (void)redrawStylePreview
{
    [previewView setNeedsDisplay];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark AddStyleDelegate

- (void)didPickNewStyleForAppend:(TTStyle *)style
{
    [self addStyle:style];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    
    const CGFloat stylePreviewHeight = 80.f;
    
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height -= stylePreviewHeight;
    self.tableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    CGRect previewFrame = self.view.bounds;
    previewFrame.origin.y = self.view.height - stylePreviewHeight;
    previewFrame.size.height = stylePreviewHeight;
    previewFrame = CGRectInset(previewFrame, 4.f, 4.f);
    previewView = [[StylePreview alloc] initWithFrame:previewFrame];
    previewView.style = rootStyle;
    [self.view addSubview:previewView];
}

// TTTableViewController should do this for you but it doesn't
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
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
    
    return [StyleStructureDataSource dataSourceWithItems:styleNames rootStyle:rootStyle];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [previewView release];
    [rootStyle release];
    [super dealloc];
}


@end
