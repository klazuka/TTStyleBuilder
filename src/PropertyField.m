//
//  TTPropertyField.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyField.h"


@implementation PropertyField

@synthesize object;
@synthesize propertyName;
@synthesize propertyType;

- (id)initWithObject:(id)anObject property:(objc_property_t)aProperty url:(NSString *)url
{
    NSString *propName = [NSString stringWithCString:property_getName(aProperty) encoding:NSUTF8StringEncoding];
    if (self = [self initWithText:propName url:url]) {
        object = [anObject retain];
        propertyName = [propName retain];
        NSString *propertyAttributes = [[NSString alloc] initWithCString:property_getAttributes(aProperty) encoding:NSUTF8StringEncoding];
        NSArray *components = [propertyAttributes componentsSeparatedByString:@","];
        propertyType = [[components objectAtIndex:0] retain];
    }
    return self;
}

- (NSString *)valueDescription
{
    return [[object valueForKey:propertyName] description];
}

- (Class)propertyClass
{
    NSAssert([propertyType hasPrefix:@"T@"], @"the propertyClass method requires that the underlying property type is an 'id'");
    
    if ([propertyType isEqualToString:@"T@"]) {
        // What I'm about to do here isn't strictly correct since the dynamic type 'id' 
        // imposes no restraints on the object's root class, but it will work for our purposes.
        NSLog(@"WARNING: asked to determine the Class of a property with type 'id'. Returning [NSObject class] as the result, even though it is not strictly correct.");
        return [NSObject class];
    }
    
    NSString *className = [propertyType substringWithRange:NSMakeRange(3, [propertyType length] - 4)]; // drop the 'T@"' from the beginning and the trailing '"' at the end.
    return objc_lookUpClass([className cStringUsingEncoding:NSUTF8StringEncoding]);
}

// ------------------------------------------
#pragma mark NewObjectPickerDelegate protocol

- (void)didPickNewObject:(id)newObject
{
    // Take the |newObject| that the user picked and 
    // replace the old property value with |newObject|.
    [object setValue:newObject forKey:propertyName];
}

#pragma mark - 

- (void)dealloc
{
    [object release];
    [propertyName release];
    [propertyType release];
    [super dealloc];
}


@end
