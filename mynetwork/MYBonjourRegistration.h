//
//  MYBonjourRegistration.h
//  MYNetwork
//
//  Created by Jens Alfke on 4/27/09.
//  Copyright 2009 Jens Alfke. All rights reserved.
//

#import "MYDNSService.h"
@class MYBonjourService;


/** Registers a local network service with Bonjour, so it can be browsed by other computers. */
@interface MYBonjourRegistration : MYDNSService
{
    NSString *_name, *_type, *_domain;
    UInt16 _port;
    BOOL _autoRename;
    BOOL _registered;
    NSMutableDictionary *_txtRecord;
}

/** Initializes a new registration.
    If you're also browsing for the same service type, you should instead get an instance of this via
    the MYBonjourBrowser's 'myRegistration' property -- that way the browser knows about the
    registration and won't echo it back to you.
    Either way, don't forget to call -start! */
- (id) initWithServiceType: (NSString*)serviceType port: (UInt16)port;

/** The name to register this service under.
    This is often left nil, in which case the user's chosen "Computer Name" (from the Sharing system
    pref pane) will be used.
    This can only be set before calling -start! */
@property (copy) NSString *name;

/** The registration's service type. */
@property (readonly) NSString *type;

/** The registration's IP port number.
    You'll need to set this if you got this object from MYBonjourBrowser's 'myRegistration' property,
    as that object doesn't have a pre-set port number yet.
    This can only be set before calling -start!  */
@property UInt16 port;

/** The registration's full name -- the name, type and domain concatenated together. */
@property (readonly) NSString *fullName;

/** Is the registration currently active? */
@property (readonly) BOOL registered;

/** The service's metadata dictionary, stored in its DNS TXT record */
@property (copy) NSDictionary *txtRecord;

/** Convenience to store a string value in a single TXT record key. */
- (void) setString: (NSString*)value forTxtKey: (NSString*)key;


/** @name Expert
 *  Advanced methods you likely won't need
 */
//@{

/** The registration's domain name.
    This is almost always left nil, in which case the default registration domain is used
    (usually ".local".)
    This can only be set before calling -start!  */
@property (copy) NSString *domain;

/** Determines what to do if there's a name conflict with an already-registered service on the
    network.
    If set to YES (the default), a number will be appended to the name to make it unique.
    If set to NO, the registration will fail, and you can choose a different name and try again.
    This can only be set before calling -start!  */
@property BOOL autoRename;

/** Is this browsed service an echo of this local registration? (Compares fullNames.) */
- (BOOL) isSameAsService: (MYBonjourService*)service;

//@}

@end
