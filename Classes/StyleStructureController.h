//
//  StyleStructureController.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@interface StyleStructureController : TTTableViewController
{
    TTStyle *rootStyle;
}

- (id)initForRootStyle:(TTStyle *)style;    // designated initializer

@end
