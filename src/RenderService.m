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
        listener.bonjourServiceType = @"_ttstylebuilder._tcp";
        [listener open];
        
        clients = [[NSMutableArray alloc] init];
        
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
    
    // Render the style for each client.
    for (NSDictionary *client in clients) {
        TTLOG(@"Rasterizing style (%@) on behalf of RenderClient (%@).", obj, client);
        CGSize clientSize = CGSizeMake([[client objectForKey:@"width"] floatValue], [[client objectForKey:@"height"] floatValue]);
        [offscreenView setFrame:CGRectMake(offscreenView.left, offscreenView.top, clientSize.width, clientSize.height)];
        offscreenView.style = obj;
        [offscreenView setNeedsDisplay];
        UIGraphicsBeginImageContext(clientSize);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[offscreenView layer] renderInContext:ctx];
        UIImage *raster = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        BLIPRequest *r = [(BLIPConnection*)[client objectForKey:@"connection"] request];
        r.body = UIImagePNGRepresentation(raster);
        r.contentType = @"image/png";
        r.noReply = YES;
        [r send];
    }
}

// --------------------------------------------------------------------------------
#pragma mark TCP Listener delegate

- (void)listenerDidOpen:(TCPListener*)aListener
{
    TTLOG(@"Listening on port %i", aListener.port);
}

- (void)listener:(TCPListener*)aListener failedToOpen:(NSError*)error
{
    TTLOG(@"Failed to open listener on port %i: %@", aListener.port, error);
}

- (void)listener:(TCPListener*)aListener didAcceptConnection:(TCPConnection*)connection
{
    TTLOG(@"Accepted connection from %@", connection.address);
    connection.delegate = self;
}

// --------------------------------------------------------------------------------
#pragma mark BLIP Connection delegate

- (void)connection:(TCPConnection*)connection failedToOpen:(NSError*)error
{
    TTLOG(@"Failed to open connection from %@: %@", connection.address, error);
}

- (void)connection:(BLIPConnection*)connection receivedRequest:(BLIPRequest*)request
{
    TTLOG(@"Incoming Request:\n%@", request);
    
    // Process the client configuration
    NSDictionary *props = [NSKeyedUnarchiver unarchiveObjectWithData:request.body];
    NSMutableDictionary *config = [props mutableCopy];
    [config setObject:connection forKey:@"connection"];
    [clients addObject:[config autorelease]];
    [request respondWithString:@"OK"];
}

- (void)connectionDidClose:(TCPConnection*)connection;
{
    TTLOG(@"Connection closed from %@", connection.address);
}

// ------------------------------------------------------------------------------------
#pragma mark -

- (void)dealloc
{
    [clients release];
    [offscreenView release];
    [listener release];
    [super dealloc];
}


@end
