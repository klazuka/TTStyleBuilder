//
//  MacRenderClient.m
//  MYNetwork
//
//  Adapted from Jen Aflke's MYNetwork echo client example code:
//  http://bitbucket.org/snej/mynetwork/wiki/Home
//

#import "MacRenderClient.h"
#import "MYBonjourBrowser.h"
#import "MYBonjourService.h"
#import "CollectionUtils.h"
#import "MYNetwork.h"
#import "Target.h"

@interface MacRenderClient ()
- (void)openConnection:(MYBonjourService*)service;
@end


@implementation MacRenderClient

- (void)awakeFromNib 
{
    [self.serviceBrowser start];
    
    [self addObserver:self forKeyPath:@"serviceList" options:NSKeyValueObservingOptionNew context:NULL];
    
    [widthField setStringValue:[NSString stringWithFormat:@"%.0f", imageView.frame.size.width]];
    [heightField setStringValue:[NSString stringWithFormat:@"%.0f", imageView.frame.size.height]];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"serviceList"]) {
        // Automatically connect to an arbitrary service from the list if we are not already connected.
        // YES, we should give the user a choice, but in practice, there will only be one
        // TTStyleBuilder RenderService available.
        if (!_connection) {
            NSArray *services = [change objectForKey:NSKeyValueChangeNewKey];
            if ([services count] > 0)  {
                [self openConnection:[services objectAtIndex:0]];                
            }
        }

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (MYBonjourBrowser*) serviceBrowser {
    if (!_serviceBrowser)
        _serviceBrowser = [[MYBonjourBrowser alloc] initWithServiceType:@"_ttstylebuilder._tcp."];
    return _serviceBrowser;
}

- (NSArray*) serviceList {
    return [_serviceBrowser.services.allObjects sortedArrayUsingSelector:@selector(compare:)];
}

+ (NSArray*) keyPathsForValuesAffectingServiceList {
    return $array(@"serviceBrowser.services");
}

// ----------------------------------------------------------------------------------------
#pragma mark -
#pragma mark BLIPConnection support

/* Opens a BLIP connection to the given address. */
- (void)openConnection:(MYBonjourService*)service 
{
    _connection = [[BLIPConnection alloc] initToBonjourService:service];
    if( _connection ) {
        _connection.delegate = self;
        [_connection open];
    } else
        NSBeep();
}

/* Closes the currently open BLIP connection. */
- (void)closeConnection
{
    [_connection close];
}

// ----------------------------------------------------------------------------------------
#pragma mark TCPConnection delegate

/** Called after the connection successfully opens. */
- (void)connectionDidOpen:(TCPConnection*)connection {
    if (connection==_connection) {
        [submitButton setEnabled:YES];
        [widthField setEnabled:YES];
        [heightField setEnabled:YES];
        [exampleStringField setEnabled:YES];
        [statusField setStringValue:@"Status: Connected"];
        [self sendConfiguration:nil];
    }
}

/** Called after the connection fails to open due to an error. */
- (void)connection: (TCPConnection*)connection failedToOpen:(NSError*)error {
    NSLog(@"connection:failedToOpen: %@", error);
}

- (void)connection:(BLIPConnection*)connection receivedRequest:(BLIPRequest*)request
{
    NSLog(@"Incoming Request:\n%@", request);
    [imageView setImage:[[[NSImage alloc] initWithData:request.body] autorelease]];
}

/** Called after the connection closes. */
- (void)connectionDidClose:(TCPConnection*)connection {
    if (connection == _connection) {
        if (connection.error)
            NSLog(@"connectionDidClose: %@", connection.error);
        [_connection release];
        _connection = nil;
        [submitButton setEnabled:NO];
        [widthField setEnabled:NO];
        [heightField setEnabled:NO];
        [exampleStringField setEnabled:NO];
        [imageView setImage:nil];
        [statusField setStringValue:@"Status: Disconnected"];
    }
}

// ----------------------------------------------------------------------------------------
#pragma mark -
#pragma mark GUI action methods

/* Send a BLIP request containing the client configuration */
- (IBAction)sendConfiguration:(id)sender 
{
    NSDictionary *props = [NSDictionary dictionaryWithObjectsAndKeys:
                            [widthField stringValue], @"width",
                            [heightField stringValue], @"height",
                            [exampleStringField stringValue], @"exampleString",
                            nil];
    
    BLIPRequest *r = [_connection request];
    r.body = [NSKeyedArchiver archivedDataWithRootObject:props];
    BLIPResponse *response = [r send];
    if (response)
        response.onComplete = $target(self, gotConfigurationResponse:);
    else
        NSBeep();
}

- (void)gotConfigurationResponse:(BLIPResponse*)response
{
    NSLog(@"Got configuration response %@", response);
}    

@end

#pragma mark -

int main(int argc, char *argv[])
{
    return NSApplicationMain(argc,  (const char **) argv);
}
