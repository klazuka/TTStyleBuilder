//
//  AppDelegate.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "StyleStructureController.h"
#import "StyleEditor.h"
#import "MainMenuController.h"
#import "StyleSheetController.h"
#import "StyleBrowserController.h"
#import "PropertyEditorSystem.h"
#import "SettingsController.h"
#import "RenderService.h"

@implementation AppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // start-up the Render Service (available via Bonjour)
    renderService = [[RenderService alloc] init];
    
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    TTURLMap* map = navigator.URLMap;
    [map from:@"*" toViewController:[TTWebController class]];
    [map from:@"tt://mainMenu" toSharedViewController:[MainMenuController class]];
    
    // Entry-point into the generic object and C data type editing system.
    // TTNavigator query keys: atEncodeType, object and propertyName
    [map from:@"tt://value/edit?" toViewController:[ValueEditorDispatch class]];
    
    // Allow the user to replace a property value by picking a new value.
    // This part of the generic object editing system.
    // TTNavigator query keys: baseClass, delegate
    [map from:@"tt://value/new?" toViewController:[NewObjectPickerController class]];
    
    // Edit an individual style's properties.
    // TTNavigator query keys: style
    [map from:@"tt://style/edit?" toViewController:[StyleEditor class]];
    
    // Configure the settings for the live preview area.
    // TTNavigator query keys: object
    [map from:@"tt://style/preview/settings?" toModalViewController:[SettingsController class]];
    
    // Edit a TTStyle rendering pipeline (or create a new one)
    [map from:@"tt://style/pipeline/edit?" toViewController:[StyleStructureController class]];          // TTNavigator query keys: style and, optionally, file path to style archive on disk
    [map from:@"tt://style/pipeline/edit/(init)" toViewController:[StyleStructureController class]];    // plain init, create a new blank style.
    
    // List styles that can be edited
    [map from:@"tt://styleSheet/browse" toViewController:[StyleSheetController class]];
    [map from:@"tt://style/archives/browse" toViewController:[StyleBrowserController class]];
    
    [navigator openURL:@"tt://mainMenu" animated:NO];
}

#pragma mark -

NSString *StyleArchivesDir(void)
{
#if TARGET_IPHONE_SIMULATOR
    // I would use NSHomeDirectory() here but when you build for iPhone simulator, 
    // NSHomeDirectory() instead gives the app's directory in 
    // ~/Library/Application Support/iPhone Simulator/User/Applications/
    // which is not what we want.
    return [[NSString stringWithFormat:@"/Users/%@/Desktop", NSUserName()] stringByExpandingTildeInPath];
#else
    return TTPathForDocumentsResource(@".");
#endif
}

#pragma mark -

- (void)dealloc
{
    [renderService release];
	[super dealloc];
}


@end

