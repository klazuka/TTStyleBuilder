//
//  ColorEditor.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ColorEditor.h"


@implementation ColorEditor     

@synthesize object, propertyName;

+ (NSString *)atEncodeTypeHandler
{
    return @"T@\"UIColor\"";
}

- (void)sliderValueChanged:(id)sender
{
    UIColor *color = [UIColor colorWithHue:[hueSlider value] 
                                saturation:[saturationSlider value] 
                                brightness:[brightnessSlider value] 
                                     alpha:1.f];
    
    [self.object setValue:color forKey:self.propertyName];
    
    [colorSwatchView setBackgroundColor:color];
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
    const CGFloat kLabelHeight = 40.f;
    
    // Slider layout
    const CGFloat kSliderOffsetX = 2 * kOffsetX + kLabelWidth;
    const CGFloat kSliderWidth = 320.f - kSliderOffsetX - kOffsetX; // fill the remaining space, but leave some padding along the right edge
    const CGFloat kSliderHeight = kLabelHeight;
    
    
    // --- Hue -----------
    UILabel *hueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kOffsetX, offsetY, kLabelWidth, kLabelHeight)] autorelease];
    [hueLabel setText:@"Hue"];
    [self.view addSubview:hueLabel];
    
    hueSlider = [[UISlider alloc] initWithFrame:CGRectMake(kSliderOffsetX, offsetY, kSliderWidth, kSliderHeight)];
    [hueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:hueSlider];
    offsetY += kLabelHeight + kVerticalPadding;
    
    
    // --- Saturation ----
    UILabel *saturationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kOffsetX, offsetY, kLabelWidth, kLabelHeight)] autorelease];
    [saturationLabel setText:@"Saturation"];
    [self.view addSubview:saturationLabel];
    
    saturationSlider = [[UISlider alloc] initWithFrame:CGRectMake(kSliderOffsetX, offsetY, kSliderWidth, kSliderHeight)];
    [saturationSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:saturationSlider];
    offsetY += kLabelHeight + kVerticalPadding;


    // --- Brightness ----
    UILabel *brightnessLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kOffsetX, offsetY, kLabelWidth, kLabelHeight)] autorelease];
    [brightnessLabel setText:@"Brightness"];
    [self.view addSubview:brightnessLabel];
    
    brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(kSliderOffsetX, offsetY, kSliderWidth, kSliderHeight)];
    [brightnessSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:brightnessSlider];
    offsetY += kLabelHeight + kVerticalPadding;
    
    
    // --- Color Preview -----
    const CGFloat kSwatchHeight = 100.f;
    colorSwatchView = [[TTView alloc] initWithFrame:CGRectMake(kOffsetX, offsetY, 320.f - (2 * kOffsetX), kSwatchHeight)];
    /*
     // I'd like to make it look pretty by clipping the background color to a rounded rectangle shape
     // and drawing a thin border around it, but this code doesn't work. I'll dig into it later.
    [colorSwatchView setStyle:[TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:6.f] next:
                               [TTSolidBorderStyle styleWithColor:[UIColor lightGrayColor] width:4.f next:
                                [TTContentStyle styleWithNext:nil]]]];
     */
    [colorSwatchView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:colorSwatchView];
    offsetY += kSwatchHeight + kVerticalPadding;
}

- (void)viewDidLoad
{
    UIColor *color = [self.object valueForKey:self.propertyName];
    [hueSlider setValue:([color hue] / 360.f)];
    [saturationSlider setValue:[color saturation]];
    [brightnessSlider setValue:[color value]];
    [colorSwatchView setBackgroundColor:color];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [object release];
    [propertyName release];
    [hueSlider release];
    [saturationSlider release];
    [brightnessSlider release];
    [colorSwatchView release];
    [super dealloc];
}

@end
