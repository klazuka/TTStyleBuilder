//
//  PropertyFieldCell.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TTStyleBuilderGlobal.h"

@interface PropertyFieldCell : TTTextTableFieldCell
{
    UILabel *valueLabel;        // Displays the blue value part near right edge of cell
    UIButton *newValueButton;   // Tap this button to bring up the picker to replace this property's value with a new value.
}

@end
