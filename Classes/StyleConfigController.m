//
//  StyleConfigController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleConfigController.h"
#import "PropertyField.h"
#import "PropertyFieldCell.h"
#import "PropertyEditorController.h"
#import <objc/runtime.h>

@interface StyleConfigDataSource : TTListDataSource {} @end
@implementation StyleConfigDataSource
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[PropertyField class]])
        return [PropertyFieldCell class];
    else
        return [super tableView:tableView cellClassForObject:object];
}
@end


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];    // ensure that the displayed values are up-to-date.
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (void)showObject:(id)object inView:(NSString*)viewType withState:(NSDictionary*)state
{
    [super showObject:object inView:viewType withState:state];
    self.style = object;
    self.title = [object className];
}

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *items = [NSMutableArray array];
    
    unsigned int numProperties = -1;
    objc_property_t *properties = class_copyPropertyList([style class], &numProperties);
    
    for (unsigned int i = 0; i < numProperties; i++) {
        objc_property_t prop = properties[i];
        [items addObject:[[[PropertyField alloc] initWithObject:style property:prop url:nil] autorelease]];
    }
    
    free(properties);
    return [StyleConfigDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    if (![PropertyEditorController canEdit:[object propertyType]]) {
        UIAlertView *prompt = [[[UIAlertView alloc] initWithTitle:@"No Editor Available" message:[object propertyType] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] autorelease];
        [prompt show];
        return;
    }
    
    PropertyEditorController *editor = [PropertyEditorController editorForPropertyType:[object propertyType]];
    editor.object = [object object]; // TODO yes this is weird, but that's how they're named!
    editor.propertyName = [object propertyName];
    [self.navigationController pushViewController:editor animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [style release];
    [super dealloc];
}

@end
