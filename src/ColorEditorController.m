//
//  ColorEditorController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ColorEditorController.h"


@implementation ColorEditorController

+ (NSString *)typeHandler
{
    return @"T@\"UIColor\"";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *fields = [NSMutableArray array];
    
    for (NSString *colorName in [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Black", @"White", nil]) {
        [fields addObject:[[[TTTableField alloc] initWithText:colorName url:nil] autorelease]];
    }
    
    return [TTListDataSource dataSourceWithItems:fields];
}

- (void)didSelectObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath
{
    NSString *selectedColorName = [anObject text];
    NSDictionary *colors = [NSDictionary dictionaryWithObjectsAndKeys:
                            [UIColor colorWithRed:0.9f green:0.1f blue:0.1f alpha:1.f], @"Red",
                            [UIColor colorWithRed:0.1f green:0.75f blue:0.1f alpha:1.f], @"Green",
                            [UIColor colorWithRed:0.f green:0.5f blue:1.f alpha:1.f], @"Blue",
                            [UIColor blackColor], @"Black",
                            [UIColor whiteColor], @"White",
                            nil];
    
    UIColor *selectedColor = [colors objectForKey:selectedColorName];
    [self.object setValue:selectedColor forKey:self.propertyName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
