//
//  ObjectEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ObjectEditor.h"
#import "PropertyField.h"
#import "PropertyFieldCell.h"
#import <objc/runtime.h>

@interface ObjectEditorDataSource : TTListDataSource {} @end
@implementation ObjectEditorDataSource
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[PropertyField class]])
        return [PropertyFieldCell class];
    else
        return [super tableView:tableView cellClassForObject:object];
}
@end


@implementation ObjectEditor

@synthesize object;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ValueEditor protocol

+ (NSString *)typeHandler
{
    return @"T@";
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
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (void)showObject:(id)anObject inView:(NSString*)viewType withState:(NSDictionary*)state
{
    [super showObject:anObject inView:viewType withState:state];
    self.object = anObject;
    self.title = [anObject className];
}

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *items = [NSMutableArray array];
    
    unsigned int numProperties = -1;
    objc_property_t *properties = class_copyPropertyList([object class], &numProperties);
    
    for (unsigned int i = 0; i < numProperties; i++) {
        objc_property_t prop = properties[i];
        [items addObject:[[[PropertyField alloc] initWithObject:object property:prop url:nil] autorelease]];
    }
    
    free(properties);
    return [ObjectEditorDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)propertyField atIndexPath:(NSIndexPath*)indexPath
{
    NSString *propertyType = [propertyField propertyType];
    if (![PropertyEditorSystem canEdit:propertyType]) {
        [self alert:propertyType title:@"No Editor Available" delegate:nil];
        return;
    }
    
    UIViewController<ValueEditor> *editor = [PropertyEditorSystem editorForPropertyType:propertyType];
    
    if ([editor respondsToSelector:@selector(propertyName)]) {
        // CASE: ValueEditor is a PropertyEditor
        editor.propertyName = [propertyField propertyName];
        editor.object = [propertyField object];
    } else {
        // CASE: ValueEditor is an ObjectEditor
        editor.object = [[propertyField object] valueForKey:[propertyField propertyName]];
    }

    [self.navigationController pushViewController:editor animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [object release];
    [super dealloc];
}

@end
