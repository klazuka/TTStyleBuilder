//
//  StyleStructureController.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"
#import "NewObjectPickerController.h"  // Needed for the NewObjectPickerDelegate protocol

@class StyleStructureDataSource;

@interface StyleStructureController : TTTableViewController <NewObjectPickerDelegate>
{
    StyleStructureDataSource *styleDataSource;  // Same as the TTTableViewController dataSource property
    TTView *previewView;
    NSString *filePath;                         // the path to the archived TTStyle or nil if it was not deserialized.
}

- (id)initWithHeadStyle:(TTStyle *)style filePath:(NSString *)filePath;    // Designated initializer. |style| may be nil. |filePath| may be nil.
- (id)initWithHeadStyle:(TTStyle *)style;

@end
