//
//  StyleSheetController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleSheetController.h"
#import "StyleStructureController.h"
#import "objc/runtime.h"

@interface StyleSheetController ()
- (void)showStyle:(TTStyle *)style;
@end

@implementation StyleSheetController

+ (NSArray *)styleSelectorNames
{
    NSMutableArray *names = [NSMutableArray array];
    
    TTStyleSheet *styleSheet = [TTStyleSheet globalStyleSheet];
    unsigned int count = 0;
    Method *methods = class_copyMethodList([styleSheet class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
        // WARNING: This depends on the current naming convention of methods on TTDefaultStyleSheet.
        //          Ideally we would just check the return type of the method to see if it returns a TTStyle*
        //          but the only return type info we get is that it is a pointer to struct objc_object (e.g. "id")
        //          So I make do with what I have, even though it's not ideal.
        //
        //          There is some degree of protection provided further down in this source file.
        //          When the StyleSheet is asked to performSelector:methodName, the resulting object's class
        //          is verified to be an actual TTStyle subclass instance.
        //
        //          The final check here is to make sure that the method is nil-adic (does not take any parameters).
        //          Again, this is less than ideal, but if you can think of a way to figure out what values
        //          each method needs at runtime, then please, go ahead.
        if ( ![methodName hasSuffix:@"Font"] && ![methodName hasSuffix:@"Color"] && ![methodName hasSuffix:@":"] )
            [names addObject:methodName];
    }
    
    free(methods);
    
    return names;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.title = @"StyleSheet";
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *selectorName in [[self class] styleSelectorNames])
        [items addObject:[[[TTTableField alloc] initWithText:selectorName] autorelease]];
    
    return [TTListDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    id style = [[TTStyleSheet globalStyleSheet] performSelector:NSSelectorFromString([object text])];
    if ( ![style isKindOfClass:[TTStyle class]] ){
        NSLog(@"WARNING: table view had putative style method '%@'. It returned a %@ but I expected a TTStyle object.", [object text], style);
        [self alert:@"This stylesheet method name does not actually return a TTStyle. Sorry."];
        return;
    }

    [self showStyle:style];
}

- (void)showStyle:(TTStyle *)style
{
    UIViewController *controller = [[StyleStructureController alloc] initWithHeadStyle:style];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


@end
