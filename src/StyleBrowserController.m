//
//  StyleBrowserController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleBrowserController.h"

@implementation StyleBrowserController

// -------------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"Archived Styles";
    [[NSNotificationCenter defaultCenter] postNotificationName:kEraseStylePreviewNotification object:nil];
    [self invalidateModel];
}

// -------------------------------------------------------------------------------------
#pragma mark TTTableViewController

- (void)createModel
{
    NSMutableArray *items = [NSMutableArray array];
    
    // Search for all available .ttstyle file archives
    NSString *dir = StyleArchivesDir();
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:dir];
    
    for (NSString *filename in dirEnum) {
        if ([[filename pathExtension] isEqualToString: @"ttstyle"]) {
            NSString *filePath = [StyleArchivesDir() stringByAppendingPathComponent:filename];
            TTStyle *style = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            TTTableTextItem *item = [TTTableTextItem itemWithText:filename URL:@"tt://style/pipeline/edit?"];
            item.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             style, @"style",
                             filePath, @"styleFilePath", 
                             nil];
            [items addObject:item];
        }        
    }
    
    self.dataSource = [TTListDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshStylePreviewNotification object:nil];
}

@end
