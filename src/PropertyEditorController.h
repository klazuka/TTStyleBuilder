//
//  PropertyEditorController.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@interface PropertyEditorController : TTTableViewController
{
    id object;
    NSString *propertyName;
}

@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString *propertyName;

+ (PropertyEditorController *)editorForPropertyType:(NSString *)encodeDirectiveType; // designated initializer / factory method. |encodeDirectiveType| is the result of doing @encode(YourProperty).

+ (BOOL)canEdit:(NSString *)encodeDirectiveType;    // answers YES if there is a plugin for this property type.

@end


