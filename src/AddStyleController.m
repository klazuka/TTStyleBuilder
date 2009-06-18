//
//  AddStyleController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddStyleController.h"
#import "objc/runtime.h"

static NSMutableDictionary *StyleMap;

@implementation AddStyleController

@synthesize delegate;

+ (void)initialize
{
    if ( self != [AddStyleController class] )
        return;
    
    // Initialize the mapping from displayed style name to style instance
    StyleMap = [[NSMutableDictionary alloc] init];
    
    // find all sub-classes of TTStyle and ask it for its prototypical instance.
    // then register that instance under the class name in the map.

    Class * classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
        classes = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        for ( int i = 0; i < numClasses; i++ ) {
            Class klass = classes[i];
            
            if ( class_getSuperclass(klass) == [TTStyle class] ) {
                NSString *klassName = [NSString stringWithCString:class_getName(klass) encoding:NSUTF8StringEncoding];
                SEL prototypeSelector = @selector(prototypicalInstance);
                if ([klass respondsToSelector:prototypeSelector]) {
                    TTStyle *instance = [klass performSelector:prototypeSelector];
                    [StyleMap setObject:instance forKey:klassName];
                    KLog(@"Yay... registered %@ in the StyleMap", klassName);
                } else {
                    KLog(@"found %@ but it does not implement %@", klassName, NSStringFromSelector(prototypeSelector));
                }
            }
        }
        
        free(classes);
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
    
    for (NSString *styleClassName in StyleMap) 
        [items addObject:[[[TTTableField alloc] initWithText:styleClassName] autorelease]];
    
    return [TTListDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    NSAssert(self.delegate, @"AddStyleController requires the delegate property to be non-nil in order to pick a new style.");
    
    // TODO give the delegate the real TTStyle object
    KLog(@"Selected style %@", object);
//    [self.delegate didPickNewStyleForAppend:[TTLinearGradientFillStyle styleWithColor1:RGBACOLOR(0, 0.5, 0.5, 0.75) color2:[UIColor clearColor] next:nil]];
    [self.delegate didPickNewStyleForAppend:[StyleMap objectForKey:[object text]]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
