//
//  PropertyEditorSystem.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"
#import "RuntimeSupport.h"

@interface PropertyEditorSystem ()
+ (Class)lookupEditorClassForAtEncodeType:(NSString *)atEncodeType;
+ (NSString *)fallbackTypeForAtEncodeType:(NSString *)atEncodeType;
@end

static NSMutableDictionary *ClassHandlerMap = nil;

@implementation PropertyEditorSystem

// -------------------------------------------------------------------------------------
#pragma mark Plug-in system

+ (void)initialize
{
    if ( self != [PropertyEditorSystem class] )
        return;
    
    // Initialize the mapping.
    ClassHandlerMap = [[NSMutableDictionary alloc] init];

    // Find all classes that adopt the ValueEditor protocol
    // and ask them for the atEncodeType that they know how to handle.
    // Finally, map the type to the editor plugin's class.
    const char *protocolName = "ValueEditor";
    for (Class cls in ImplementationsForProtocol(objc_getProtocol(protocolName)))
        [ClassHandlerMap setObject:cls forKey:[cls atEncodeTypeHandler]];
}

+ (UIViewController<ValueEditor> *)editorForAtEncodeType:(NSString *)atEncodeType
{
    // Dispatch to an editor Class based on |atEncodeType|.
    Class cls = [self lookupEditorClassForAtEncodeType:atEncodeType];

    // Alloc
    UIViewController<ValueEditor> *instance = class_createInstance(cls, 0);
    
    // Init
    [instance init];
    
    return [instance autorelease];
}

+ (BOOL)canEdit:(NSString *)atEncodeType
{
    return [self lookupEditorClassForAtEncodeType:atEncodeType] != nil;
}

+ (Class)lookupEditorClassForAtEncodeType:(NSString *)atEncodeType
{
    // typical case: lookup and find a plugin that explicitly handles this type.
    Class cls = [ClassHandlerMap objectForKey:atEncodeType];
    if (cls)
        return cls;

    // a-typical case: attempt to find a fallback plugin
    NSString *fallback = [self fallbackTypeForAtEncodeType:atEncodeType];
    if (fallback) {
        return [self lookupEditorClassForAtEncodeType:fallback];
    } else {
        KLog(@"Failed to find an editor class for type %@, even after trying to use fallback type %@", atEncodeType, fallback);
        return nil;
    }
}

+ (NSString *)fallbackTypeForAtEncodeType:(NSString *)atEncodeType
{
     // If the property is an 'id', then fallback to the generic 'id' handler.
    return IsIdAtEncodeType(atEncodeType) 
            ? @"T@"
            : nil;
}

@end

// -------------------------------------------------------------------------------------
#pragma mark -

@implementation ValueEditorDispatch

// -------------------------------------------------------------------------------------
#pragma mark UIViewController/TTNavigator

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query
{
    // We're not actually going to use self here, this is just a dispatch stub that was
    // necessary to work with Three20's TTNavigator system. Maybe there's a better way to do
    // this.
    
    // TODO make sure that we are not leaking the prior, uninitialized instance from alloc.
    //      If I do [self release] here, an exception is raised later when an autorelease pool
    //      is drained because it tries to release a freed object (presumably the old self instance).

    // TODO I don't like how I'm conflating the property value case and the just-the-object case.
    //      There must be a more elegant way. Right now the only things that are being dealt with in 
    //      a "just-the-object" way are styles in the TTStyle linked list and the TTView that
    //      we use to display the live style preview (edited by the SettingsController).
    //      But as of right now, neither of those cases come through this dispatching method.
    
    NSString *atEncodeType = [query objectForKey:@"atEncodeType"];
    NSString *propertyName = [query objectForKey:@"propertyName"];
    id object = [query objectForKey:@"object"];
    
    UIViewController<ValueEditor> *editor = [PropertyEditorSystem editorForAtEncodeType:atEncodeType];
    [editor retain];
    
    if ([editor respondsToSelector:@selector(propertyName)]) {
        // CASE: ValueEditor is a PropertyEditor
        editor.propertyName = propertyName;
        editor.object = object;
    } else {
        // CASE: ValueEditor is an ObjectEditor
        editor.object = [object valueForKey:propertyName];
    }
    
    editor.title = [object className];
    
    return editor;
}

@end
