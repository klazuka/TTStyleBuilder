//
//  StyleStructureDataSource.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleStructureDataSource.h"

#pragma mark Private Methods
@interface StyleStructureDataSource ()
- (void)linkStyle:(TTStyle *)style atIndex:(NSUInteger)index;
- (TTStyle *)unlinkStyleAtIndex:(NSUInteger)index;
- (void)verifyState;
@end

#pragma mark -
#pragma mark Implementation
#pragma mark -
@implementation StyleStructureDataSource

@synthesize headStyle;

+ (StyleStructureDataSource*)dataSourceWithHeadStyle:(TTStyle *)style
{
    return [[[[self class] alloc] initWithHeadStyle:style] autorelease];
}
- (id)initWithHeadStyle:(TTStyle *)theHeadStyle
{
    NSMutableArray *items = [NSMutableArray array];
    for (TTStyle *style in [theHeadStyle pipeline]) {
        NSString *name = [style className];
        NSString *url = [NSString stringWithFormat:@"%@?style_config", [style viewURL]];
        [items addObject:[[[TTTableField alloc] initWithText:name url:url] autorelease]];
    }
    
    if ((self = [super initWithItems:items])) {
        self.headStyle = theHeadStyle;
    }
    return self;
}

#pragma mark High-level data operations

- (void)appendStyle:(TTStyle *)style
{
    KLog(@" ++++ [Appending %@]", style);

    // Update the rendering pipeline
    [self linkStyle:style
            atIndex:(headStyle ? [[headStyle pipeline] count] : 0)];

    // Update the table view
    NSString *name = [style className];
    NSString *url = [NSString stringWithFormat:@"%@?style_config", [style viewURL]];
    [self.items addObject:[[[TTTableField alloc] initWithText:name url:url] autorelease]];
    
    // Verify correctness
    [self verifyState];
    
    // Post the notification
    [[NSNotificationCenter defaultCenter] postNotificationName:kStylePipelineUpdatedNotification object:headStyle];
}

- (BOOL)deleteStyleAtIndex:(NSUInteger)index
{
    KLog(@" ---- [Deleting style at index %u]", index);
    
    // Unlink the node from the TTStyle pipeline
    [self unlinkStyleAtIndex:index];
    
    // Remove the item from the table view
    [self.items removeObjectAtIndex:index];
    
    // Verify correctness
    [self verifyState];
    
    // Update the live style preview
    [[NSNotificationCenter defaultCenter] postNotificationName:kStylePipelineUpdatedNotification object:headStyle];
    
    // Signal to the caller that the desired data was deleted
    return YES;
}

- (void)moveStyleFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    KLog(@" >>>> [Moving row at %u to %u]", fromIndex, toIndex);
    
    // Update the rendering pipeline (delete followed by an insert)
    TTStyle *movingStyle = [self unlinkStyleAtIndex:fromIndex];
    [self linkStyle:movingStyle atIndex:toIndex];
    
    // Update the tableview data source
    id toBeMoved = [self.items objectAtIndex:fromIndex];
    [[toBeMoved retain] autorelease];  // make sure it is alive during the shuffle
    [self.items removeObject:toBeMoved];
    if (toIndex > [self.items count])
        [self.items addObject:toBeMoved];
    else
        [self.items insertObject:toBeMoved atIndex:toIndex];
    
    // Verify correctness
    [self verifyState];
    
    // Update the live style preview
    [[NSNotificationCenter defaultCenter] postNotificationName:kStylePipelineUpdatedNotification object:headStyle];
}

#pragma mark Low-level linked list operations

- (TTStyle *)unlinkStyleAtIndex:(NSUInteger)index
{
    // Get a reference to the style that will be deleted
    TTStyle *styleToBeDeleted = nil;
    
    if (index == 0) {
        // We are deleting the node that headStyle points at, 
        // so in order to patch the linked list, we need to 
        // replace the headStyle pointer.
        styleToBeDeleted = headStyle;
        [styleToBeDeleted retain];
        self.headStyle = styleToBeDeleted.next;
        KLog(@"SPECIAL CASE: Un-linked %@ from the head of the pipeline. New head is %@", styleToBeDeleted, headStyle);
    } else {
        // Normal case: patch the linked list around the deleted node.
        NSArray *pipeline = [headStyle pipeline];
        styleToBeDeleted = [pipeline objectAtIndex:index];
        [styleToBeDeleted retain];
        TTStyle *previousStyle = [pipeline objectAtIndex:index - 1];
        previousStyle.next = styleToBeDeleted.next;
        KLog(@"Un-linked %@", styleToBeDeleted);
    }
    
    int i = 0;
    for (TTStyle *style in [headStyle pipeline])
        KLog(@"%d - %@", i++, [style className]);
    
    return [styleToBeDeleted autorelease];
}

- (void)linkStyle:(TTStyle *)style atIndex:(NSUInteger)index
{
    // Link the node into the rendering pipeline
    NSArray *pipeline = [headStyle pipeline];
    
    if (index == 0) {
        // We are inserting a node at the front of the list,
        // so we need to make headStyle point at this node.
        style.next = headStyle;
        self.headStyle = style;
        KLog(@"SPECIAL CASE: Linked %@ into the head of the pipeline", style);
    } else {
        // Normal case: insert and patch up the linked list.
        TTStyle *previousStyle = [pipeline objectAtIndex:index - 1];
        previousStyle.next = style;
        TTStyle *bumpedStyle = index < [pipeline count] ? [pipeline objectAtIndex:index] : nil;
        style.next = bumpedStyle;
        KLog(@"Linked %@ into the pipeline at index: %u, bumping %@", style, index, bumpedStyle);
    }
    
    int i = 0;
    for (TTStyle *style in [headStyle pipeline])
        KLog(@"%d - %@", i++, [style className]);
}

#pragma mark UITableViewDataSource hooks

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self moveStyleFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        BOOL deleted = [self deleteStyleAtIndex:indexPath.row];
        if (deleted)
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}

#pragma mark -

- (void)verifyState
{
    // Verify that the TTStyle linked list matches
    // the table view data source representation.
    int i = 0;
    for (TTStyle *style in [headStyle pipeline]) {
        NSString *a = [style className];
        NSString *b = [[self.items objectAtIndex:i] text];
        NSAssert2([a isEqualToString:b], @"pipeline/datasource mismatch! %@ != %@", a, b);
        i++;
    }
}

- (void)dealloc
{
    [headStyle release];
    [super dealloc];
}

@end
