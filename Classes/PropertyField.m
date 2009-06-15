//
//  TTPropertyField.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyField.h"


@implementation PropertyField

@synthesize property;

- (id)initWithProperty:(objc_property_t)aProperty
{
    return [self initWithProperty:aProperty url:nil];
}

- (id)initWithProperty:(objc_property_t)aProperty url:(NSString *)url
{
    NSString *propName = [NSString stringWithCString:property_getName(aProperty) encoding:NSUTF8StringEncoding];
    if (self = [self initWithText:propName url:url]) {
        property = aProperty;
    }
    return self;
}


@end
