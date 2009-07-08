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


@implementation MacRenderClient


- (void)awakeFromNib 
{
    [self.serviceBrowser start];
    [widthField setStringValue:[NSString stringWithFormat:@"%.0f", imageView.frame.size.width]];
    [heightField setStringValue:[NSString stringWithFormat:@"%.0f", imageView.frame.size.height]];
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

/** Called after the connection successfully opens. */
- (void)connectionDidOpen:(TCPConnection*)connection {
    if (connection==_connection) {
        [submitButton setEnabled:YES];
        [self sendConfiguration:nil];
    }
}

/** Called after the connection fails to open due to an error. */
- (void)connection: (TCPConnection*)connection failedToOpen:(NSError*)error {
    [serverTableView.window presentError:error];
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
            [serverTableView.window presentError:connection.error];
        [_connection release];
        _connection = nil;
        [submitButton setEnabled:NO];
    }
}


#pragma mark -
#pragma mark GUI action methods

- (IBAction)serverClicked:(id)sender {
    NSTableView * table = (NSTableView *)sender;
    int selectedRow = [table selectedRow];
    
    [self closeConnection];
    if (-1 != selectedRow)
        [self openConnection: [self.serviceList objectAtIndex:selectedRow]];
}

/* Send a BLIP request containing the client configuration */
- (IBAction)sendConfiguration:(id)sender 
{
    NSDictionary *props = [NSDictionary dictionaryWithObjectsAndKeys:
                            [widthField stringValue], @"width",
                            [heightField stringValue], @"height",
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

int main(int argc, char *argv[])
{
    return NSApplicationMain(argc,  (const char **) argv);
}
