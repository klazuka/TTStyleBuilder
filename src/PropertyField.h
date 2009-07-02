//
//  TTPropertyField.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"
#import <objc/runtime.h>
#import "NewObjectPickerController.h"

@interface PropertyField : TTTableField <NewObjectPickerDelegate>
{
    id object;
    NSString *propertyName;
    NSString *propertyType;
}

@property (nonatomic, retain) id object;                // the object that hosts the property
@property (nonatomic, retain) NSString *propertyName;
@property (nonatomic, retain) NSString *propertyType;   // expressed in the same format as the @encode() compiler directive would create. (e.g. an NSString* property would be @"T@\"NSString\"")

- (id)initWithObject:(id)anObject property:(objc_property_t)aProperty url:(NSString *)url;  // designated initializer

- (id)value;                        // the property value
- (NSString *)valueDescription;     // a textual description of the property value

@end