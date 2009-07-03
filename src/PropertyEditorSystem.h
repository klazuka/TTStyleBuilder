//
//  PropertyEditorSystem.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@protocol ValueEditor

@required
+ (NSString *)atEncodeTypeHandler;                      // Announces the atEncodeType that this editor knows how to handle. The resulting string should be equivalent to the result of @encode(ThePropertyTypeToEdit).
@property (nonatomic, retain) id object;                // The object that hosts the property being edited. This reference is needed so that the plugin can both query and set the value using |propertyName|.

@optional
@property (nonatomic, retain) NSString *propertyName;   // The name of the property to edit.

@end

#pragma mark -

@interface PropertyEditorSystem : NSObject
{
}

+ (UIViewController<ValueEditor> *)editorForAtEncodeType:(NSString *)atEncodeType;  // Factory method to create a view controller that knows how to edit values of type |atEncodeType|. |atEncodeType| is the result of doing @encode(YourProperty).
+ (BOOL)canEdit:(NSString *)atEncodeType;                                           // Answers YES if there is a plugin for values of type |atEncodeType|

@end


