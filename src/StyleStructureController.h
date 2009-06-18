//
//  StyleStructureController.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"
#import "AddStyleController.h"  // needed for the AddStyleDelegate protocol

@interface StyleStructureController : TTTableViewController <AddStyleDelegate>
{
    TTStyle *rootStyle;
    TTView *previewView;
}

- (id)initForRootStyle:(TTStyle *)style;    // designated initializer

@end
