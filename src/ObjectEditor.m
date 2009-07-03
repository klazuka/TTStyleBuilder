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
#import "RuntimeSupport.h"
#import "NewObjectPickerController.h"

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

@synthesize object, showInheritedProperties;

- (id)init
{
    if ((self = [super init])) {
        
        showInheritedProperties = YES;
        
        // This is an ugly hack, but right now I don't have an easy way for the PropertyFieldCell
        // to directly talk to the ObjectEditor controller.
        // The PropertyFieldCell will pass along its reference to the PropertyField object 
        // via the NSNotification object's payload. This PropertyField object should, in turn,
        // be used as the delegate to the NewObjectPickerController since it has all of the
        // data that is needed to replace the old property value when the user finally
        // picks a new value.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newValueButtonTapped:) name:kNewObjectValueButtonTappedNotification object:nil];
    }
    return self;
}

- (void)newValueButtonTapped:(NSNotification *)notification
{
    PropertyField *propertyField = [notification object];
    Class baseClass = ClassFromAtEncodeType([propertyField atEncodeType]);
    NSAssert1(baseClass, @"Failed to find a Class for %@", [propertyField atEncodeType]);
    NewObjectPickerController *controller = [[[NewObjectPickerController alloc] initWithBaseClass:baseClass] autorelease];
    controller.delegate = propertyField;
    [self.navigationController pushViewController:controller animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ValueEditor protocol

+ (NSString *)atEncodeTypeHandler
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
    
    NSArray *allProperties = PropertiesOfClass([object class], showInheritedProperties);
    for (NSUInteger i = 0; i < [allProperties count]; i++) {
        objc_property_t prop = (objc_property_t)[allProperties objectAtIndex:i];    // TODO is this cast safe? CFArray lets you you append void*, but NSArray vends id.
        // --- FIXME ugly hack between these lines ---------
        // There are some types, like CGImageRef, that KVC cannot handle
        // For the most common non-id types, KVC will wrap the value
        // in an NSValue object.
        //
        // The right way to do this would be to skip every property
        // whose type is not an 'id' or not on the white-list of
        // automatically wrapped types (like int, float, CGSize, etc.)
        //
        // Until I fix this for real, I'll just manually skip the types
        // that I encounter problems with.
        if (strstr(property_getName(prop), "CGImage"))  // otherwise it would break ObjectEditor on a UIImage
            continue;
        // -------------------------------------------
        // Another ugly hack. We should make an explicit black list of properties that we want to ignore.
        if (strstr(property_getAttributes(prop), "T@\"TTStyle\",&,N,V_next")) // ignored b/c we don't want the user traversing the linked list--we provide our own UI for that (StyleStructureController's tableview).
            continue;
        [items addObject:[[[PropertyField alloc] initWithObject:object property:prop url:nil] autorelease]];
    }
    
    if ([items count] == 0) {
        [self alert:[NSString stringWithFormat:@"There are no editable properties on this object. You should consider implementing an editor plugin for class %@", [object className]]
              title:@"Cannot Edit"
           delegate:nil];
    }
    
    return [ObjectEditorDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)propertyField atIndexPath:(NSIndexPath*)indexPath
{
    // ensure that we are dealing with a true PropertyField
    if (![propertyField isKindOfClass:[PropertyField class]]) {
        NSLog(@"WARNING: didSelectObject: expected a PropertyField but got %@", propertyField);
        return;
    }
    
    NSString *atEncodeType = [propertyField atEncodeType];
    
    if ([propertyField isReadOnly] && !IsIdAtEncodeType(atEncodeType)) {
        [self alert:[NSString stringWithFormat:@"%@ is a read-only, scalar property.", [propertyField propertyName]]];
        return;
    }

    if (![PropertyEditorSystem canEdit:atEncodeType]) {
        [self alert:atEncodeType title:@"No Editor Available" delegate:nil];
        return;
    }
    
    UIViewController<ValueEditor> *editor = [PropertyEditorSystem editorForAtEncodeType:atEncodeType];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [object release];
    [super dealloc];
}

@end
