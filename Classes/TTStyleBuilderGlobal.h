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

// macros
#ifndef KLog

#ifdef DEBUG
#define KLog(...) NSLog(__VA_ARGS__)
#define PINCH_TRACKING_CODE @"70774c86eccaf34ec7cc82f5b28341c9"
#else
#define KLog(...) do { } while (0)
#define PINCH_TRACKING_CODE @"cbb84e658001ff8d28010aba58d2ee57"
#endif

#endif // KLog