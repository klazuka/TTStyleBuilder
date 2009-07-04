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
    TTStyle *headStyle;
}

@property (nonatomic, retain) TTStyle *headStyle; // The head of the style rendering pipeline

+ (StyleStructureDataSource*)dataSourceWithHeadStyle:(TTStyle *)style;

- (id)initWithHeadStyle:(TTStyle *)style;

- (void)appendStyle:(TTStyle *)style;   // Appends |style| to the end of the rendering pipeline.

@end