//
//  StyleConfigController.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@interface StyleConfigController : TTTableViewController
{
    TTStyle *style;
}

- (id)initForStyle:(TTStyle *)aStyle;   // designated initializer

@property (nonatomic, retain) TTStyle *style;

@end
