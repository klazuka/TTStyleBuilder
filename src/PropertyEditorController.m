//
//  PropertyEditorController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorController.h"
#import "objc/runtime.h"

static NSMutableDictionary *ClassHandlerMap = nil;

@interface PropertyEditorController (SubclassesMustImplement)
+ (NSString *)typeHandler;
@end

@implementation PropertyEditorController

@synthesize object, propertyName;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Plug-in system

+ (void)initialize
{
    if ( self != [PropertyEditorController class] )
        return;
    
    // Initialize the mapping from property type to its property editor
    ClassHandlerMap = [[NSMutableDictionary alloc] init];
    
    // find all sub-classes of PropertyEditorController and ask them 
    // for the property type that they know how to handle.
    // Then create the mapping.
    Class * classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
        classes = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        for ( int i = 0; i < numClasses; i++ ) {
            Class klass = classes[i];
            
            if ( class_getSuperclass(klass) == self ) {
                NSString *type = [klass typeHandler];
                [ClassHandlerMap setObject:klass forKey:type];
            }
        }
        
        free(classes);
    }
}

+ (PropertyEditorController *)editorForPropertyType:(NSString *)encodeDirectiveType
{
    // dispatch to Class based on input format
    Class klass = [ClassHandlerMap objectForKey:encodeDirectiveType];
    if ( !klass ) {
        KLog(@"Failed to find a property editor class for type %@", encodeDirectiveType);
        return nil;
    }
    
    // alloc
    PropertyEditorController *instance = class_createInstance(klass, 0);
    
    // init
    [instance init];
    
    return [instance autorelease];
}

+ (NSString *)typeHandler
{
    NSAssert(NO, @"+[PropertyEditorController typeHandler] is abstract. Your subclass is incomplete.");
    return nil;
}

+ (BOOL)canEdit:(NSString *)encodeDirectiveType
{
    return [ClassHandlerMap objectForKey:encodeDirectiveType] != nil;
}

+ (id)allocWithZone:(NSZone *)zone
{
    if ( [PropertyEditorController class] == self ) {
        NSAssert(NO, @"Cannot alloc PropertyEditorController base class. Use class factory method instead!");
        return nil;
    }
    
    return [super allocWithZone:zone];
}

#pragma mark -

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void) dealloc
{
    [object release];
    [propertyName release];
    [super dealloc];
}


@end
