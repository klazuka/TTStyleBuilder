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

@interface PropertyField : TTTableTextItem <NewObjectPickerDelegate>
{
    id object;
    NSString *propertyName;
    NSString *atEncodeType;
    BOOL readOnly;
}

@property (nonatomic, retain) id object;                // The object that hosts the property.
@property (nonatomic, retain) NSString *propertyName;   // The key that can be used with KVC on |object| to obtain this property's current value.
@property (nonatomic, retain) NSString *atEncodeType;   // Expressed in the same format as the @encode() compiler directive would create. (e.g. an NSString* property would be @"T@\"NSString\"")
@property (nonatomic, getter=isReadOnly) BOOL readOnly; // Is the property read-only.

- (id)initWithObject:(id)anObject property:(objc_property_t)aProperty url:(NSString *)url;  // Designated initializer

- (id)value;                        // Lookup the property's current value.
- (NSString *)valueDescription;     // A textual description of the property value for display to the user.

@end