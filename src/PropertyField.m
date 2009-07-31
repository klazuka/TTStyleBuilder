//
//  TTPropertyField.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyField.h"
#import "RuntimeSupport.h"


@implementation PropertyField

@synthesize object, propertyName, atEncodeType, readOnly;

- (id)initWithObject:(id)anObject property:(objc_property_t)aProperty url:(NSString *)url
{
    if (self = [self init]) {
        NSString *propName = [NSString stringWithCString:property_getName(aProperty) encoding:NSUTF8StringEncoding];
        self.text = propName;
        object = [anObject retain];
        propertyName = [propName retain];
        NSString *propertyAttributes = [[NSString alloc] initWithCString:property_getAttributes(aProperty) encoding:NSUTF8StringEncoding];
        NSArray *components = [propertyAttributes componentsSeparatedByString:@","];
        atEncodeType = [[components objectAtIndex:0] retain];
        readOnly = [components containsObject:@"R"];
    }
    return self;
}

- (id)value
{
    return [object valueForKey:propertyName];
}

- (NSString *)valueDescription
{
    return [[self value] description];
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
    [atEncodeType release];
    [super dealloc];
}


@end
