//
//  StylePreview.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@interface StylePreview : TTView
{
    CGSize size;
    UIColor *fillColor;
    NSString *textForDelegate;
    UIImage *imageForDelegate;
}

// the properties that you define here will be exposed
// to the object editor controller (SettingsController)
// when asked to display the settings for a StylePreview instance.
//
// because of how this works, we define some properties here (like size and fillColor)
// that really could just use their UIView counterpart, but then it wouldn't be displayed
// in the list of properties that can be edited. As a result, for such properties you will
// probably want to hook into -[StylePreview setValue:forKey:] to re-route the new values
// into the UIView property (like |frame| or |backgroundColor|).
//
@property (nonatomic, assign) CGSize size;
@property (nonatomic, retain) UIColor *fillColor;
@property (nonatomic, retain) NSString *textForDelegate;
@property (nonatomic, retain) UIImage *imageForDelegate;

@end
