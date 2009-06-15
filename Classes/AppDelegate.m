//
//  AppDelegate.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "StyleStructureController.h"

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{    
    TTStyle *styleToBeEdited = TTSTYLE(tabBar);
    UIViewController *rootController = [[StyleStructureController alloc] initForStyle:styleToBeEdited];
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    
    window = [[UIWindow alloc] initWithFrame:TTApplicationFrame()];
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
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

