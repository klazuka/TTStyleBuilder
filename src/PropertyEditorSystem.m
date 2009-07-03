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

///////////////////////////////////////////////////////////////////////////////////////////////////
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
