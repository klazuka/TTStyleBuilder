//
//  MacRenderClient.h
//  MYNetwork
//
//  Adapted from Jen Aflke's MYNetwork echo client example code:
//  http://bitbucket.org/snej/mynetwork/wiki/Home
//

#import <Cocoa/Cocoa.h>
#import "BLIPConnection.h"
@class MYBonjourBrowser;


@interface MacRenderClient : NSObject <BLIPConnectionDelegate>
{
    IBOutlet NSTextField *widthField;
    IBOutlet NSTextField *heightField;
    IBOutlet NSTextField *exampleStringField;
    IBOutlet NSTextField *statusField;
    IBOutlet NSButton *submitButton;
    IBOutlet NSImageView *imageView;
    
    MYBonjourBrowser *_serviceBrowser;
    BLIPConnection *_connection;
}

@property (readonly) MYBonjourBrowser *serviceBrowser;
@property (readonly) NSArray *serviceList;

- (IBAction)sendConfiguration:(id)sender;

@end
