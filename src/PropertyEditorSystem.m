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
+ (Class)lookupEditorClassForPropertyType:(NSString *)encodeDirectiveType;
+ (NSString *)fallbackTypeForPropertyType:(NSString *)encodeDirectiveType;
@end

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

    // Find all classes that adopt the ValueEditor protocol
    // and ask them for the property type that they know how to handle.
    // Finally, map the property type to the class.
    const char *protocolName = "ValueEditor";
    for (Class cls in ImplementationsForProtocol(objc_getProtocol(protocolName))) {
        NSString *type = [cls typeHandler];
        [ClassHandlerMap setObject:cls forKey:type];
    }
}

+ (UIViewController<ValueEditor> *)editorForPropertyType:(NSString *)encodeDirectiveType
{
    // Dispatch to Class based on input format
    Class cls = [self lookupEditorClassForPropertyType:encodeDirectiveType];

    // Alloc
    UIViewController<ValueEditor> *instance = class_createInstance(cls, 0);
    
    // Init
    [instance init];
    
    return [instance autorelease];
}

+ (BOOL)canEdit:(NSString *)encodeDirectiveType
{
    return [self lookupEditorClassForPropertyType:encodeDirectiveType] != nil;
}

+ (Class)lookupEditorClassForPropertyType:(NSString *)encodeDirectiveType
{
    // typical case: lookup and find a plugin that explicitly handles this type.
    Class cls = [ClassHandlerMap objectForKey:encodeDirectiveType];
    if (cls)
        return cls;

    // a-typical case: attempt to find a fallback plugin
    NSString *fallback = [self fallbackTypeForPropertyType:encodeDirectiveType];
    if (fallback) {
        return [self lookupEditorClassForPropertyType:fallback];
    } else {
        KLog(@"Failed to find an editor class for type %@, even after trying to use fallback type %@", encodeDirectiveType, fallback);
        return nil;
    }
}

+ (NSString *)fallbackTypeForPropertyType:(NSString *)encodeDirectiveType
{
     // If the property is an 'id', then fallback to the generic 'id' handler.
    return IsIdType(encodeDirectiveType) 
            ? @"T@"
            : nil;
}

@end
