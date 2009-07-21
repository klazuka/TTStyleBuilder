//
//  FontEditor.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 7/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"

@interface FontEditor : UIViewController <ValueEditor>
{
    // ValueEditor
    id object;
    NSString *propertyName;
    
    // font editor
    UITextField *fontSizeField;
    UISwitch *boldnessSwitch;
}

@end
