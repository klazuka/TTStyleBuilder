//
//  StyleStructureController.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"
#import "NewObjectPickerController.h"  // needed for the NewObjectPickerDelegate protocol

@interface StyleStructureController : TTTableViewController <NewObjectPickerDelegate>
{
    TTStyle *headStyle;
    TTView *previewView;
}

- (id)initForRootStyle:(TTStyle *)style;    // designated initializer

@end
