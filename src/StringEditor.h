//
//  StringEditor.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"

@interface StringEditor : TTTableViewController <ValueEditor>
{
    // ValueEditor
    id object;
    NSString *propertyName;
    
    // NSString editor specific
    TTTextFieldTableField *stringField;
}

@end
