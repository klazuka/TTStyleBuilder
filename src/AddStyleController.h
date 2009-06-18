//
//  AddStyleController.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@protocol AddStyleDelegate
- (void)didPickNewStyleForAppend:(TTStyle *)style;
@end


@interface AddStyleController : TTTableViewController
{
    id<AddStyleDelegate> delegate;
}

@property (nonatomic, assign) id<AddStyleDelegate> delegate;

@end
