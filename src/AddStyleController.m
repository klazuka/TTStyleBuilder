//
//  AddStyleController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddStyleController.h"
#import "RuntimeSupport.h"
#import "objc/runtime.h"

static SEL PrototypeSelector;
static NSMutableSet *StylesWithPrototypes;

@implementation AddStyleController

@synthesize delegate;

+ (void)initialize
{
    if ( self != [AddStyleController class] )
        return;
    
    PrototypeSelector = @selector(prototypicalInstance);
    StylesWithPrototypes = [[NSMutableSet alloc] init];
    
    // find all sub-classes of TTStyle that implement the prototypicalInstance selector.
    // then add that class name to the set of all styles which can provide a prototypical instance.
    for (Class klass in SubclassEnumeratorForClass([TTStyle class])) {
        NSString *klassName = [NSString stringWithCString:class_getName(klass) encoding:NSUTF8StringEncoding];
        if ([klass respondsToSelector:PrototypeSelector]) {
            [StylesWithPrototypes addObject:klassName];
            KLog(@"Yay... %@ can provide a prototypical style instance", klassName);
        } else {
            KLog(@"Found %@ but it does not implement %@", klassName, NSStringFromSelector(PrototypeSelector));
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSString *styleClassName in StylesWithPrototypes) 
        [items addObject:[[[TTTableField alloc] initWithText:styleClassName] autorelease]];
    
    return [TTListDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    NSAssert(self.delegate, @"AddStyleController requires the delegate property to be non-nil in order to pick a new style.");

    NSString *klassName = [object text];
    Class klass = objc_lookUpClass([klassName cStringUsingEncoding:NSUTF8StringEncoding]);
    [self.delegate didPickNewStyleForAppend:[klass performSelector:PrototypeSelector]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
