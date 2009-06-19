//
//  UIEdgeInsetsEditor.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorController.h"

@interface UIEdgeInsetsEditor : PropertyEditorController
{
    TTTextFieldTableField *topField;
    TTTextFieldTableField *leftField;
    TTTextFieldTableField *bottomField;
    TTTextFieldTableField *rightField;
}

@end
