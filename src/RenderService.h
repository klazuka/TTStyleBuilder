//
//  RenderService.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"
#import "BLIPConnection.h"

@interface RenderService : NSObject <TCPListenerDelegate, BLIPConnectionDelegate>
{
    BLIPListener *listener;
    NSMutableDictionary *clients;   // The keys are IP address:port strings. The values are NSDictionary (keys: width, height, connection)
    TTView *offscreenView;
    TTStyle *cachedStyle;           // Every time a style is rasterized, it is cached here so that if a client configuration request comes in, we can use the cached style to re-rasterize according to the new configuration and send it back to the client immediately.
}

@end
