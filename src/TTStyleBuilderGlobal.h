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
#import "UIColorAdditions.h"


// ---- notifications ----
#define kStylePipelineUpdatedNotification @"Style Pipeline Updated Notification"            // structural change
#define kRefreshStylePreviewNotification @"Refresh Style Preview Notification"              // property change
#define kEraseStylePreviewNotification @"Erase Style Preview Notification"                  // nil-out the style preview
#define kNewObjectValueButtonTappedNotification @"New Object Value Button Notification"     // user tapped the "New" button on an object property to invoke a picker to select a replacement object for the row's property value.


// ---- macros -----
#ifndef KLog

#ifdef DEBUG
#define KLog(...) NSLog(__VA_ARGS__)
#else
#define KLog(...) do { } while (0)
#endif

#endif // KLog

NSString *StyleArchivesDir(void);