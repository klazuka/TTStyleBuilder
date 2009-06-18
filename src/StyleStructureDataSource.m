//
//  StyleStructureDataSource.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleStructureDataSource.h"


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

- (TTStyle *)unlinkStyleAtIndex:(NSUInteger)index
{
    // unlink the node from the TTStyle pipeline
    NSArray *pipeline = [rootStyle pipeline];
    TTStyle *styleToBeDeleted = [pipeline objectAtIndex:index];
    [styleToBeDeleted retain];
    TTStyle *prevStyle = [pipeline objectAtIndex:index - 1];
    prevStyle.next = styleToBeDeleted.next;
    KLog(@"Un-linking %@ from the pipeline at index: %u", styleToBeDeleted, index);
    KLog(@"New style pipeline after un-linking is:");
    int i = 0;
    for (TTStyle *style in [rootStyle pipeline])
        KLog(@"%d - %@", i++, [style className]);
    
    return [styleToBeDeleted autorelease];
}

- (void)linkStyle:(TTStyle *)style atIndex:(NSUInteger)index
{
    // link the node into the rendering pipeline
    NSArray *pipeline = [rootStyle pipeline];
    TTStyle *prevStyle = index > 0 ? [pipeline objectAtIndex:index - 1] : nil;
    prevStyle.next = style;
    TTStyle *bumpedStyle = index < [pipeline count] ? [pipeline objectAtIndex:index] : nil;
    style.next = bumpedStyle;
    
    KLog(@"Linked %@ into the pipeline at index: %u, bumping %@", style, index, bumpedStyle);
    KLog(@"New style pipeline after linking is:");
    int i = 0;
    for (TTStyle *style in [rootStyle pipeline])
        KLog(@"%d - %@", i++, [style className]);
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    KLog(@"Moving row at %u to %u", fromIndexPath.row, toIndexPath.row);
    
    // update the rendering pipeline
    // move is like a delete followed by an insert
    TTStyle *movingStyle = [self unlinkStyleAtIndex:fromIndexPath.row];
    [self linkStyle:movingStyle atIndex:toIndexPath.row];
    
    // update the tableview data source
    [self.items exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    
    // update the live style preview
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
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
        [self unlinkStyleAtIndex:indexPath.row];
        
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
