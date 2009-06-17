/*
 *  TTStyleBuilderGlobal.h
 *  TTStyleBuilder
 *
 *  Created by Keith Lazuka on 6/15/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#import "Three20/Three20.h"

// class extensions
#import "TTStyleAdditions.h"
#import "NSObjectAdditions.h"

// macros

#define kRefreshStylePreviewNotification @"Refresh Style Preview Notification"

#ifndef KLog

#ifdef DEBUG
#define KLog(...) NSLog(__VA_ARGS__)
#else
#define KLog(...) do { } while (0)
#endif

#endif // KLog