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
#import "NewObjectPickerController.h"
#import "SettingsController.h"

@implementation StyleStructureController

- (id)initForRootStyle:(TTStyle *)style
{
    if ((self = [super init])) {
        rootStyle = [style retain];
        self.title = @"Style Builder";
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

- (void)redrawStylePreview
{
    [previewView setNeedsDisplay];
}

- (void)displaySettingsScreen
{
    // display settings for the "live preview" area
    SettingsController *controller = [[[SettingsController alloc] init] autorelease];
    [controller showObject:previewView inView:nil withState:nil];
    [self presentModalViewController:[[[UINavigationController alloc] initWithRootViewController:controller] autorelease] animated:YES];
}

- (void)displayAddStylePicker
{
    NewObjectPickerController *controller = [[[NewObjectPickerController alloc] initWithBaseClass:[TTStyle class]] autorelease];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)appendStyleToPipeline:(TTStyle *)style
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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NewObjectPickerDelegate

- (void)didPickNewObject:(id)newObject
{
    NSAssert1([newObject isKindOfClass:[TTStyle class]], @"expected new object to be of kind TTStyle, but its class is actually %@", [newObject className]);
    [self appendStyleToPipeline:newObject];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    
    const CGFloat stylePreviewHeight = 80.f;
    
    // table view (each row is a style in the rendering pipeline)
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height -= stylePreviewHeight;
    self.tableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    // live preview display of the current rendering pipeline
    CGRect previewFrame = self.view.bounds;
    previewFrame.origin.y = self.view.height - stylePreviewHeight;
    previewFrame.size.height = stylePreviewHeight;
    previewFrame = CGRectInset(previewFrame, 40.f, 10.f);
    previewView = [[StylePreview alloc] initWithFrame:previewFrame];
    previewView.style = rootStyle;
    previewView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:previewView];
    
    // info button to open app settings
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [infoButton addTarget:self action:@selector(displaySettingsScreen) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setFrame:UIEdgeInsetsInsetRect(self.view.frame, UIEdgeInsetsMake(self.view.height - 40.f, self.view.width - 40.f, 0.f, 0.f))];
    [self.view addSubview:infoButton];
}

// TTTableViewController should do this for you but it doesn't
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

// until I can find a place to put the 'edit' button
// the only way to toggle the editing state is
// to double-tap somewhere inside self.view but outside
// the tableview (in this case, the best place to double-tap
// is the style preview view).
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 2) {
        // toggle editing mode (allows for deleting and rearranging styles)
        [self setEditing:!self.editing animated:YES];
    }
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
