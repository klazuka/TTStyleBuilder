//
//  PropertyEditorSystem.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"
#import "RuntimeSupport.h"

static NSMutableDictionary *ClassHandlerMap = nil;

@implementation PropertyEditorSystem

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Plug-in system

+ (void)initialize
{
    if ( self != [PropertyEditorSystem class] )
        return;
    
    // Initialize the mapping from property type to its property editor
    ClassHandlerMap = [[NSMutableDictionary alloc] init];

    // Find all classes that adopt the PropertyEditorImplementation protocol
    // and ask them for the property type that they know how to handle.
    // Finally, map the property type to the class.
    const char *protocolName = "PropertyEditorImplementation";
    for (Class klass in ImplementationsForProtocol(objc_getProtocol(protocolName))) {
        NSString *type = [klass typeHandler];
        [ClassHandlerMap setObject:klass forKey:type];
        NSLog(@"Registered %s as an editor plugin for type %@", class_getName(klass), type);
    }
}

+ (UIViewController<PropertyEditorImplementation> *)editorForPropertyType:(NSString *)encodeDirectiveType
{
    // dispatch to Class based on input format
    Class klass = [ClassHandlerMap objectForKey:encodeDirectiveType];
    if ( !klass ) {
        KLog(@"Failed to find a property editor class for type %@", encodeDirectiveType);
        return nil;
    }
    
    // alloc
    UIViewController<PropertyEditorImplementation> *instance = class_createInstance(klass, 0);
    
    // init
    [instance init];
    
    return [instance autorelease];
}

+ (BOOL)canEdit:(NSString *)encodeDirectiveType
{
    return [ClassHandlerMap objectForKey:encodeDirectiveType] != nil;
}

@end
