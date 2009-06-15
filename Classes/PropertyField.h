//
//  TTPropertyField.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TTStyleBuilderGlobal.h"

@interface PropertyField : TTTableField
{
    objc_property_t property;
}

@property (nonatomic, assign) objc_property_t property;

- (id)initWithProperty:(objc_property_t)property;
- (id)initWithProperty:(objc_property_t)property url:(NSString *)url;

@end