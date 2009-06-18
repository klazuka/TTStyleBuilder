//
//  AppDelegate.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "StyleStructureController.h"
#import "StyleConfigController.h"

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // setup the initial view of the style structure
    TTStyle *styleToBeEdited = TTSTYLE(tabGrid);
    UIViewController *rootController = [[StyleStructureController alloc] initForRootStyle:styleToBeEdited];
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    // configure TTNavigationCenter
    TTNavigationCenter *nav = [TTNavigationCenter defaultCenter];
    nav.mainViewController = navigationController;
    nav.delegate = self;
    
    // hookup the in-memory object URL loading system
    // (This should belong in TTNavigationCenter initialization)
    nav.urlSchemes = [NSArray arrayWithObject:[NSObject inMemoryUrlScheme]];
    [nav addObjectLoader:[NSObject class] name:[NSObject inMemoryUrlHost]];
    
    // define the view controllers for TTStyle objects
    [nav addView:@"style_structure" controller:[StyleStructureController class]];
    [nav addView:@"style_config" controller:[StyleConfigController class]];
    
    // create the window and show everything
    window = [[UIWindow alloc] initWithFrame:TTApplicationFrame()];
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark -
#pragma mark TTNavigationDelegate

- (BOOL)shouldLoadExternalURL:(NSURL*)url
{
    KLog(@"shouldLoadExternalURL:%@", url);
    return NO;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

