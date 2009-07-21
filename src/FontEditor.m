//
//  FontEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 7/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FontEditor.h"


@implementation FontEditor     

@synthesize object, propertyName;

+ (NSString *)atEncodeTypeHandler
{
    return @"T@\"UIFont\"";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Total layout
    const CGFloat kVerticalPadding = 10.f;
    CGFloat offsetY = kVerticalPadding;
    
    // Label layout
    const CGFloat kOffsetX = 10.f;
    const CGFloat kLabelWidth = 100.f;
    const CGFloat kLabelHeight = 26.f;
    
    // Controls layout
    const CGFloat kControlOffsetX = 2 * kOffsetX + kLabelWidth;
    const CGFloat kControlWidth = 320.f - kControlOffsetX - kOffsetX; // Fill the remaining space, but leave some padding along the right edge
    const CGFloat kControlHeight = kLabelHeight;
    
    
    // --- Point Size -----------
    UILabel *sizeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kOffsetX, offsetY, kLabelWidth, kLabelHeight)] autorelease];
    [sizeLabel setText:@"Point Size"];
    [self.view addSubview:sizeLabel];
    
    fontSizeField = [[UITextField alloc] initWithFrame:CGRectMake(kControlOffsetX, offsetY, kControlWidth, kControlHeight)];
    fontSizeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:fontSizeField];
    offsetY += kLabelHeight + kVerticalPadding;
    
    
    // --- Boldness ----
    UILabel *boldnessLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kOffsetX, offsetY, kLabelWidth, kLabelHeight)] autorelease];
    [boldnessLabel setText:@"Bold"];
    [self.view addSubview:boldnessLabel];
    
    boldnessSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kControlOffsetX, offsetY, kControlWidth, kControlHeight)];
    [self.view addSubview:boldnessSwitch];
    offsetY += kLabelHeight + kVerticalPadding;
}

- (void)viewDidLoad
{
    UIFont *font = [self.object valueForKey:self.propertyName];
    [fontSizeField setText:[NSString stringWithFormat:@"%.0f", font.pointSize]];
    [boldnessSwitch setOn:[font.fontName hasSuffix:@"Bold"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    CGFloat pointSize = [[fontSizeField text] floatValue];
    
    UIFont *font = nil;
    if (boldnessSwitch.on)
        font = [UIFont boldSystemFontOfSize:pointSize];
    else
        font = [UIFont systemFontOfSize:pointSize];
    
    [self.object setValue:font forKey:self.propertyName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [object release];
    [propertyName release];
    [fontSizeField release];
    [boldnessSwitch release];
    [super dealloc];
}

@end
