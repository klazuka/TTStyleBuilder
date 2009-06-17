//
//  StyleStructureController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleStructureController.h"

@interface StylePreview : TTView <TTStyleDelegate>
{
}
@end

@implementation StylePreview
- (void)drawRect:(CGRect)rect
{
    // for some reason, if you don't explicitly fill the gfx context
    // before you render the style, when you do something like
    // setNeedsDisplay, the style will be rendered *over* the old
    // image buffer. So if I were Joe, I would do this in -[TTView drawRect:]
    // but since I'm not, I'll just do it here in my subclass.
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor] setFill];
    CGContextFillRect(ctx, rect);
    [super drawRect:rect];
}
- (NSString*)textForLayerWithStyle:(TTStyle*)style
{
    return @"42";
}

- (UIImage*)imageForLayerWithStyle:(TTStyle*)style
{
    return TTIMAGE(@"bundle://Three20.bundle/images/nextIcon.png");
}
@end

@interface StyleStructureDataSource : TTListDataSource 
{
    TTStyle *rootStyle;
}
+ (StyleStructureDataSource*)dataSourceWithItems:(NSMutableArray*)items rootStyle:(TTStyle *)style;
- (id)initWithItems:(NSMutableArray*)items rootStyle:(TTStyle *)style;
@end

@implementation StyleStructureDataSource

+ (StyleStructureDataSource*)dataSourceWithItems:(NSMutableArray*)items rootStyle:(TTStyle *)style
{
    return [[[[self class] alloc] initWithItems:items rootStyle:style] autorelease];
}
- (id)initWithItems:(NSMutableArray*)items rootStyle:(TTStyle *)style
{
    if ((self = [super initWithItems:items])) {
        rootStyle = [style retain];
    }
    return self;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row != 0;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row == 0) {
            KLog(@"Cannot delete the first style in the pipeline because it is the head of the linked list.");
            return;
        }
        
        // unlink the node from the TTStyle pipeline
        KLog(@"Removing a node from the style pipeline");
        NSArray *styles = [rootStyle pipeline];
        TTStyle *toBeDeleted = [styles objectAtIndex:indexPath.row];
        TTStyle *prevStyle = [styles objectAtIndex:indexPath.row - 1];
        prevStyle.next = toBeDeleted.next;
        KLog(@"Un-linking %@", toBeDeleted);
        KLog(@"New style pipeline is:");
        int i = 0;
        for (TTStyle *style in [rootStyle pipeline])
            KLog(@"%d - %@", i++, [style className]);
        
        // remove the item from the table view
        [self.items removeObjectAtIndex:indexPath.row];
        
        // update the live style preview
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];

        // tell the tableview that a row has been removed from the datasource.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}
- (void)dealloc
{
    [rootStyle release];
    [super dealloc];
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation StyleStructureController

- (id)initForRootStyle:(TTStyle *)style
{
    if ((self = [super init])) {
        rootStyle = [style retain];
        self.title = @"Style Builder";
        self.navigationItem.leftBarButtonItem = [self editButtonItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawStylePreview) name:kRefreshStylePreviewNotification object:nil];
    }
    return self;
}

- (id)init
{
    // choose an arbitrary style from the system as an example.
    return [self initForRootStyle:TTSTYLE(tabBar)];
}

- (void)redrawStylePreview
{
    [previewView setNeedsDisplay];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    
    const CGFloat stylePreviewHeight = 80.f;
    
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height -= stylePreviewHeight;
    self.tableView = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    CGRect previewFrame = self.view.bounds;
    previewFrame.origin.y = self.view.height - stylePreviewHeight;
    previewFrame.size.height = stylePreviewHeight;
    previewFrame = CGRectInset(previewFrame, 4.f, 4.f);
    previewView = [[StylePreview alloc] initWithFrame:previewFrame];
    previewView.style = rootStyle;
    [self.view addSubview:previewView];
}

// TTTableViewController should do this for you but it doesn't
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *styleNames = [NSMutableArray array];
    
    for (TTStyle *style in [rootStyle pipeline]) {
        NSString *name = [style className];
        NSString *url = [NSString stringWithFormat:@"%@?style_config", [style viewURL]];
        [styleNames addObject:[[[TTTableField alloc] initWithText:name url:url] autorelease]];
    }
    
    return [StyleStructureDataSource dataSourceWithItems:styleNames rootStyle:rootStyle];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)dealloc
{
    [previewView release];
    [rootStyle release];
    [super dealloc];
}


@end
