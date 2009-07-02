//
//  StyleStructureDataSource.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleStructureDataSource.h"


@implementation StyleStructureDataSource

+ (StyleStructureDataSource*)dataSourceWithItems:(NSMutableArray*)items headStyle:(TTStyle *)style
{
    return [[[[self class] alloc] initWithItems:items headStyle:style] autorelease];
}
- (id)initWithItems:(NSMutableArray*)items headStyle:(TTStyle *)style
{
    if ((self = [super initWithItems:items])) {
        headStyle = style;  // Pointer assignment. I am intentionally not retaining it.
        rootStyle = [[TTStyle alloc] initWithNext:headStyle];
    }
    return self;
}

- (TTStyle *)unlinkStyleAtIndex:(NSUInteger)index
{
    // Get a reference to the style that will be deleted
    TTStyle *styleToBeDeleted = nil;
    
    if (index == 0) {
        // We are deleting the node that headStyle points at, 
        // so in order to patch the linked list, we need to 
        // update rootStyle's next pointer and update the headStyle pointer.
        styleToBeDeleted = headStyle;
        [styleToBeDeleted retain];
        headStyle = rootStyle.next = styleToBeDeleted.next;
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
    
    NSAssert(rootStyle != nil && rootStyle != headStyle, @"un-linking: rootStyle and headStyle both point at the same object!");

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
        // so we need to make headStyle point at this node
        // as well as update rootStyle's next pointer.
        style.next = headStyle;
        headStyle = style;
        rootStyle.next = headStyle;
        KLog(@"SPECIAL CASE: Linked %@ into the head of the pipeline", style);
    } else {
        // Normal case: insert and patch up the linked list.
        TTStyle *previousStyle = [pipeline objectAtIndex:index - 1];
        previousStyle.next = style;
        TTStyle *bumpedStyle = index < [pipeline count] ? [pipeline objectAtIndex:index] : nil;
        style.next = bumpedStyle;
        KLog(@"Linked %@ into the pipeline at index: %u, bumping %@", style, index, bumpedStyle);
    }
    
    NSAssert(rootStyle != nil && rootStyle != headStyle, @"linking: rootStyle and headStyle both point at the same object!");
    
    int i = 0;
    for (TTStyle *style in [headStyle pipeline])
        KLog(@"%d - %@", i++, [style className]);
}

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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    KLog(@" >>>> [Moving row at %u to %u]", fromIndexPath.row, toIndexPath.row);
    
    // Update the rendering pipeline.
    // Move is like a delete followed by an insert
    TTStyle *movingStyle = [self unlinkStyleAtIndex:fromIndexPath.row];
    [self linkStyle:movingStyle atIndex:toIndexPath.row];
    
    // Update the tableview data source
    id toBeMoved = [self.items objectAtIndex:fromIndexPath.row];
    [[toBeMoved retain] autorelease];  // make sure it is alive during the shuffle
    [self.items removeObject:toBeMoved];
    if (toIndexPath.row > [self.items count])
        [self.items addObject:toBeMoved];
    else
        [self.items insertObject:toBeMoved atIndex:toIndexPath.row];
    
    // Verify correctness
    [self verifyState];
    
    // Update the live style preview
    [[NSNotificationCenter defaultCenter] postNotificationName:kStylePipelineUpdatedNotification object:headStyle];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        KLog(@" ---- [Deleting row %u]", indexPath.row);
        // Unlink the node from the TTStyle pipeline
        [self unlinkStyleAtIndex:indexPath.row];
        
        // Remove the item from the table view
        [self.items removeObjectAtIndex:indexPath.row];
        
        // Verify correctness
        [self verifyState];
        
        // Update the live style preview
        [[NSNotificationCenter defaultCenter] postNotificationName:kStylePipelineUpdatedNotification object:headStyle];
        
        // Tell the tableview that a row has been removed from the datasource.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}
- (void)dealloc
{
    [rootStyle release];
    [super dealloc];
}

@end
