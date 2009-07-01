/*
 *  TTStyleBuilderGlobal.h
 *  TTStyleBuilder
 *
 *  Created by Keith Lazuka on 6/15/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */


// ---- dependencies ----
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Three20/Three20.h"


// ---- class extensions ----
#import "TTStyleAdditions.h"
#import "TTShapeAdditions.h"
#import "NSObjectAdditions.h"


// ---- notifications ----
#define kRefreshStylePreviewNotification @"Refresh Style Preview Notification"
#define kNewObjectValueButtonTappedNotification @"New Object Value Button Notification"


// ---- macros -----
#ifndef KLog

#ifdef DEBUG
#define KLog(...) NSLog(__VA_ARGS__)
#else
#define KLog(...) do { } while (0)
#endif

#endif // KLog