//
//  CGSizeEditor.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"


@interface CGSizeEditor : TTTableViewController <PropertyEditorImplementation>
{
    // PropertyEditorImplementation
    id object;
    NSString *propertyName;
    
    // CGSize editor specific
    TTTextFieldTableField *widthField;
    TTTextFieldTableField *heightField;
}

@end
