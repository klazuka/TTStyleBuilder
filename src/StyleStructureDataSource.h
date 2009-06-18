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
    TTStyle *rootStyle;
}

+ (StyleStructureDataSource*)dataSourceWithItems:(NSMutableArray*)items rootStyle:(TTStyle *)style;

- (id)initWithItems:(NSMutableArray*)items rootStyle:(TTStyle *)style;

@end