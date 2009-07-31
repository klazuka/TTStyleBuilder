//
//  CGSizeEditor.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"


@interface CGSizeEditor : TTTableViewController <ValueEditor, UITextFieldDelegate>
{
    // ValueEditor
    id object;
    NSString *propertyName;
    
    // CGSize editor specific
    UITextField *widthField;
    UITextField *heightField;
}

@end
