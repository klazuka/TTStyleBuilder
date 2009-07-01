//
//  NewObjectPickerController.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@protocol NewObjectPickerDelegate
- (void)didPickNewObject:(id)newObject;
@end


@interface NewObjectPickerController : TTTableViewController
{
    NSMutableSet *subclassNamesWithPrototypes;
    id<NewObjectPickerDelegate> delegate;
}

@property (nonatomic, assign) id<NewObjectPickerDelegate> delegate;

- (id)initWithBaseClass:(Class)cls;

@end
