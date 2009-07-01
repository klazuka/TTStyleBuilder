//
//  NewObjectPickerController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NewObjectPickerController.h"
#import "RuntimeSupport.h"
#import "objc/runtime.h"

static SEL PrototypeSelector;

@implementation NewObjectPickerController

@synthesize delegate;

+ (void)initialize
{
    PrototypeSelector = @selector(prototypicalInstance);
}

- (id)initWithBaseClass:(Class)baseClass
{
    if ((self = [super init])) {
        subclassNamesWithPrototypes = [[NSMutableSet alloc] init];
        
        // Find all sub-classes of |baseClass| that implement the prototypicalInstance selector.
        // then add that class name to the set of all subclasses which can provide a prototypical instance.
        for (Class cls in SubclassEnumeratorForClass(baseClass)) {
            NSString *klassName = [NSString stringWithCString:class_getName(cls) encoding:NSUTF8StringEncoding];
            if ([cls respondsToSelector:PrototypeSelector]) {
                [subclassNamesWithPrototypes addObject:klassName];
                KLog(@"Yay... %@ can provide a prototypical instance", klassName);
            } else {
                KLog(@"Found %@ but it does not implement %@", klassName, NSStringFromSelector(PrototypeSelector));
            }
        }
    }
    
    return self;
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
    
    for (NSString *styleClassName in subclassNamesWithPrototypes) 
        [items addObject:[[[TTTableField alloc] initWithText:styleClassName] autorelease]];
    
    return [TTListDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    NSAssert(self.delegate, @"NewObjectPickerController requires the delegate property to be non-nil in order to pick a new object.");

    NSString *klassName = [object text];
    Class klass = objc_lookUpClass([klassName cStringUsingEncoding:NSUTF8StringEncoding]);
    [self.delegate didPickNewObject:[klass performSelector:PrototypeSelector]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (void)dealloc
{
    [subclassNamesWithPrototypes release];
    [super dealloc];
}


@end
