//
//  AppDelegate.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, TTNavigationDelegate>
{    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

