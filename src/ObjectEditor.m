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

@synthesize object;

- (id)init
{
    if ((self = [super init])) {
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
    Class baseClass = ClassFromPropertyType([propertyField propertyType]);
    NSAssert1(baseClass, @"Failed to find a Class for propertyType %@", [propertyField propertyType]);
    NewObjectPickerController *controller = [[[NewObjectPickerController alloc] initWithBaseClass:baseClass] autorelease];
    controller.delegate = propertyField;
    [self.navigationController pushViewController:controller animated:YES];
}

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
    
    // TODO the property list should also include inherited properties for superclasses.
    //      For instance, right now if you try to edit a TTInnerShadowStyle, it will say
    //      that there are no editable properties, but it actually inherits 3 properties
    //      from TTShadowStyle.
    unsigned int numProperties = -1;
    objc_property_t *properties = class_copyPropertyList([object class], &numProperties);
    
    for (unsigned int i = 0; i < numProperties; i++) {
        objc_property_t prop = properties[i];
        // --- ugly hack between these lines ---------
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
        if (strstr(property_getName(prop), "CGImage"))  // breaks ObjectEditor on a UIImage
            continue;
        // -------------------------------------------
        [items addObject:[[[PropertyField alloc] initWithObject:object property:prop url:nil] autorelease]];
    }
    
    if ([items count] == 0)
        [self alert:@"Sorry, there are no editable properties on this object"];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [object release];
    [super dealloc];
}

@end
