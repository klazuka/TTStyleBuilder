//
//  StyleStructureDataSource.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@interface StyleStructureDataSource : TTListDataSource 
{
    TTStyle *rootStyle;     // retained
    TTStyle *headStyle;     // assigned
}

// |headStyle| will not be retained since it is assumed that while we are editing
// a TTStyle rendering pipeline, that structure will not be freed during editing.
// (by not retaining |headStyle|, it makes it easier for me to do the pointer manipulation
//  when patching up the linked list during delete/rearrange operations).
+ (StyleStructureDataSource*)dataSourceWithItems:(NSMutableArray*)items headStyle:(TTStyle *)style;

- (id)initWithItems:(NSMutableArray*)items headStyle:(TTStyle *)style;

- (void)appendStyle:(TTStyle *)style;   // Appends |style| to the end of the rendering pipeline.

@end