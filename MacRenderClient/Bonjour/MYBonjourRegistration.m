//
//  MYBonjourRegistration.m
//  MYNetwork
//
//  Created by Jens Alfke on 4/27/09.
//  Copyright 2009 Jens Alfke. All rights reserved.
//

#import "MYBonjourRegistration.h"
#import "MYBonjourService.h"
#import "ExceptionUtils.h"
#import "Test.h"
#import "Logging.h"
#import <dns_sd.h>


#define kTXTTTL 60          // TTL in seconds for TXT records I register


@interface MYBonjourRegistration ()
@property BOOL registered;
@end


@implementation MYBonjourRegistration


static NSMutableDictionary *sAllRegistrations;


+ (void) priv_addRegistration: (MYBonjourRegistration*)reg {
    if (!sAllRegistrations)
        sAllRegistrations = [[NSMutableDictionary alloc] init];
    [sAllRegistrations setObject: reg forKey: reg.fullName];
}

+ (void) priv_removeRegistration: (MYBonjourRegistration*)reg {
    [sAllRegistrations removeObjectForKey: reg.fullName];
}

+ (MYBonjourRegistration*) registrationWithFullName: (NSString*)fullName {
    return [sAllRegistrations objectForKey: fullName];
}


- (id) initWithServiceType: (NSString*)serviceType port: (UInt16)port
{
    self = [super init];
    if (self != nil) {
        self.continuous = YES;
        self.usePrivateConnection = YES;    // DNSServiceUpdateRecord doesn't work with shared conn :(
        _type = [serviceType copy];
        _port = port;
        _autoRename = YES;
    }
    return self;
}

- (void) dealloc {
    [_name release];
    [_type release];
    [_domain release];
    [_txtRecord release];
    [super dealloc];
}


@synthesize name=_name, type=_type, domain=_domain, port=_port, autoRename=_autoRename;
@synthesize registered=_registered;


- (NSString*) fullName {
    return [[self class] fullNameOfService: _name ofType: _type inDomain: _domain];
}


- (BOOL) isSameAsService: (MYBonjourService*)service {
    return _name && _domain && [self.fullName isEqualToString: service.fullName];
}


- (NSString*) description
{
    return $sprintf(@"%@['%@'.%@%@]", self.class,_name,_type,_domain);
}


- (void) priv_registeredAsName: (NSString*)name 
                          type: (NSString*)regtype
                        domain: (NSString*)domain
{
    if (!$equal(name,_name))
        self.name = name;
    if (!$equal(domain,_domain))
        self.domain = domain;
    LogTo(Bonjour,@"Registered %@", self);
    self.registered = YES;
    [[self class] priv_addRegistration: self];
}


static void regCallback(DNSServiceRef                       sdRef,
                        DNSServiceFlags                     flags,
                        DNSServiceErrorType                 errorCode,
                        const char                          *name,
                        const char                          *regtype,
                        const char                          *domain,
                        void                                *context)
{
    MYBonjourRegistration *reg = context;
    @try{
        if (!errorCode)
            [reg priv_registeredAsName: [NSString stringWithUTF8String: name]
                                  type: [NSString stringWithUTF8String: regtype]
                                domain: [NSString stringWithUTF8String: domain]];
    }catchAndReport(@"MYBonjourRegistration callback");
    [reg gotResponse: errorCode];
}


- (DNSServiceErrorType) createServiceRef: (DNSServiceRef*)sdRefPtr {
    DNSServiceFlags flags = 0;
    if (!_autoRename)
        flags |= kDNSServiceFlagsNoAutoRename;
    NSData *txtData = nil;
    if (_txtRecord)
        txtData = [NSNetService dataFromTXTRecordDictionary: _txtRecord];
    return DNSServiceRegister(sdRefPtr,
                              flags,
                              0,
                              _name.UTF8String,         // _name is likely to be nil
                              _type.UTF8String,
                              _domain.UTF8String,       // _domain is most likely nil
                              NULL,
                              htons(_port),
                              txtData.length,
                              txtData.bytes,
                              &regCallback,
                              self);
}


- (void) cancel {
    [super cancel];
    if (_registered) {
        [[self class] priv_removeRegistration: self];
        self.registered = NO;
    }
}


+ (NSData*) dataFromTXTRecordDictionary: (NSDictionary*)txtDict {
    if (!txtDict)
        return nil;
    // First translate any non-NSData values into UTF-8 formatted description data:
    NSMutableDictionary *encodedDict = $mdict();
    for (NSString *key in txtDict) {
        id value = [txtDict objectForKey: key];
        if (![value isKindOfClass: [NSData class]]) {
            value = [[value description] dataUsingEncoding: NSUTF8StringEncoding];
        }
        [encodedDict setObject: value forKey: key];
    }
    return [NSNetService dataFromTXTRecordDictionary: encodedDict];
}


- (void) updateTxtRecord {
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(updateTxtRecord) object: nil];
    if (self.serviceRef) {
        NSData *data = [[self class] dataFromTXTRecordDictionary: _txtRecord];
        Assert(data!=nil || _txtRecord==nil, @"Can't convert dictionary to TXT record: %@", _txtRecord);
        DNSServiceErrorType err = DNSServiceUpdateRecord(self.serviceRef,
                                                         NULL,
                                                         0,
                                                         data.length,
                                                         data.bytes,
                                                         kTXTTTL);
        if (err)
            Warn(@"%@ failed to update TXT (err=%i)", self,err);
        else
            LogTo(Bonjour,@"%@ updated TXT to %@", self,data);
    }
}


- (NSDictionary*) txtRecord {
    return _txtRecord;
}

- (void) setTxtRecord: (NSDictionary*)txtDict {
    if (!$equal(_txtRecord,txtDict)) {
        setObjCopy(&_txtRecord, txtDict);
        [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(updateTxtRecord) object: nil];
        [self performSelector: @selector(updateTxtRecord) withObject: nil afterDelay: 0.1];
    }
}

- (void) setString: (NSString*)value forTxtKey: (NSString*)key
{
    NSData *data = [value dataUsingEncoding: NSUTF8StringEncoding];
    if (!$equal(data, [_txtRecord objectForKey: key])) {
        if (data) {
            if (!_txtRecord) _txtRecord = [[NSMutableDictionary alloc] init];
            [_txtRecord setObject: data forKey: key];
        } else
            [_txtRecord removeObjectForKey: key];
        [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(updateTxtRecord) object: nil];
        [self performSelector: @selector(updateTxtRecord) withObject: nil afterDelay: 0.1];
    }
}

@end




#pragma mark -
#pragma mark TESTING:

#if DEBUG

#import "MYBonjourQuery.h"
#import "MYAddressLookup.h"

@interface BonjourRegTester : NSObject
{
    MYBonjourRegistration *_reg;
    BOOL _updating;
}
@end

@implementation BonjourRegTester

- (void) updateTXT {
    NSDictionary *txt = $dict({@"time", $sprintf(@"%.3lf", CFAbsoluteTimeGetCurrent())});
    _reg.txtRecord = txt;
    CAssertEqual(_reg.txtRecord, txt);
    [self performSelector: @selector(updateTXT) withObject: nil afterDelay: 3.0];
}

- (id) init
{
    self = [super init];
    if (self != nil) {
        _reg = [[MYBonjourRegistration alloc] initWithServiceType: @"_foo._tcp" port: 12345];
        [_reg addObserver: self forKeyPath: @"registered" options: NSKeyValueObservingOptionNew context: NULL];
        [_reg addObserver: self forKeyPath: @"name" options: NSKeyValueObservingOptionNew context: NULL];
        
        [self updateTXT];
        [_reg start];
    }
    return self;
}

- (void) dealloc
{
    [_reg stop];
    [_reg removeObserver: self forKeyPath: @"registered"];
    [_reg removeObserver: self forKeyPath: @"name"];
    [_reg release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    LogTo(Bonjour,@"Observed change in %@: %@",keyPath,change);
}

@end

TestCase(BonjourReg) {
    EnableLogTo(Bonjour,YES);
    EnableLogTo(DNS,YES);
    [NSRunLoop currentRunLoop]; // create runloop
    BonjourRegTester *tester = [[BonjourRegTester alloc] init];
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 15]];
    [tester release];
}

#endif


/*
 Copyright (c) 2008-2009, Jens Alfke <jens@mooseyard.com>. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted
 provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions
 and the following disclaimer in the documentation and/or other materials provided with the
 distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRI-
 BUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
 THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
