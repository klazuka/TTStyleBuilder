//
//  ColorEditor.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"

@interface ColorEditor : UIViewController <ValueEditor>
{
    // ValueEditor
    id object;
    NSString *propertyName;
    
    // color editor
    UISlider *hueSlider;
    UISlider *saturationSlider;
    UISlider *brightnessSlider;
    UISlider *alphaSlider;
    TTView *colorSwatchView;
}

@end
