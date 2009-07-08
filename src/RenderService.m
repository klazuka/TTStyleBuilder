//
//  RenderService.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RenderService.h"
#import "BLIP.h"
#import "StylePreview.h"

// TODO this should be a singleton

@implementation RenderService

- (id)init
{
    if ((self = [super init])) {
        listener = [[BLIPListener alloc] initWithPort: 12345];
        listener.delegate = self;
        listener.pickAvailablePort = YES;
        listener.bonjourServiceType = @"_blipecho._tcp";
        [listener open];
        
        offscreenView = [[StylePreview alloc] initWithFrame:CGRectMake(0.f, 0.f, 120.f, 60.f)]; // TODO size should come from RenderClient
        offscreenView.backgroundColor = [UIColor colorWithWhite:0.953f alpha:1.f];  // Matches the bg color of the NSImageView in the MacRenderClient.
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(render:) name:kStylePipelineUpdatedNotification object:nil];
    }
    return self;
}

- (void)render:(NSNotification *)notification
{
    id obj = [notification object];
    if (obj)
        NSAssert([obj isKindOfClass:[TTStyle class]], @"Style pipeline update notification payload must be either a TTStyle instance or nil.");
    
    // Rasterization
    TTLOG(@"Rasterizing style (%@) on behalf of RenderClient.", obj);
    offscreenView.style = obj;
    UIGraphicsBeginImageContext(offscreenView.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[offscreenView layer] renderInContext:ctx];
    UIImage *raster = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // TODO this is temporary (delete the ivar when you're done)
    [cachedRaster release];
    cachedRaster = [raster retain];
}

// --------------------------------------------------------------------------------
#pragma mark TCP Listener delegate

- (void)listenerDidOpen:(TCPListener*)aListener
{
    TTLOG(@"Listening on port %i", aListener.port);
}

- (void) listener:(TCPListener*)aListener failedToOpen:(NSError*)error
{
    TTLOG(@"Failed to open listener on port %i: %@", aListener.port, error);
}

- (void) listener:(TCPListener*)aListener didAcceptConnection:(TCPConnection*)connection
{
    TTLOG(@"Accepted connection from %@", connection.address);
    connection.delegate = self;
}

// --------------------------------------------------------------------------------
#pragma mark BLIP Connection delegate

- (void) connection:(TCPConnection*)connection failedToOpen:(NSError*)error
{
    TTLOG(@"Failed to open connection from %@: %@", connection.address, error);
}

- (void) connection:(BLIPConnection*)connection receivedRequest:(BLIPRequest*)request
{
    NSString *message = [[NSString alloc] initWithData: request.body encoding: NSUTF8StringEncoding];
    TTLOG(@"Incoming Request:\n“%@”", message);
    [request respondWithData:UIImageJPEGRepresentation(cachedRaster ? cachedRaster : [UIImage imageNamed:@"white-data.png"], 0.6f) contentType:@"image/jpeg"];
	[message release];
}

- (void) connectionDidClose:(TCPConnection*)connection;
{
    TTLOG(@"Connection closed from %@", connection.address);
}

// ------------------------------------------------------------------------------------
#pragma mark -

- (void) dealloc
{
    [cachedRaster release];
    [offscreenView release];
    [listener release];
    [super dealloc];
}


@end
