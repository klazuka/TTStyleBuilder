//
//  UIEdgeInsetsEditor.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"

@interface UIEdgeInsetsEditor : TTTableViewController <PropertyEditorImplementation>
{
    // PropertyEditorImplementation
    id object;
    NSString *propertyName;
    
    // UIEdgeInsets editor specific
    TTTextFieldTableField *topField;
    TTTextFieldTableField *leftField;
    TTTextFieldTableField *bottomField;
    TTTextFieldTableField *rightField;
}

@end
