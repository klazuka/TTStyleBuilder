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
    NSMutableArray *clients;    // array of NSDictionary (keys are: width, height, connection)
    TTView *offscreenView;
}

@end
