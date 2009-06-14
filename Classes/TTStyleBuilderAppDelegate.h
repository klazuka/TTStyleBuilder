//
//  TTStyleBuilderAppDelegate.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface TTStyleBuilderAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

