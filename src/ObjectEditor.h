//
//  ObjectEditor.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PropertyEditorSystem.h"

/*
 *      ObjectEditor
 *
 *  Uses a tableview to display each Obj-C 2.0 property
 *  defined on the object that it is told to edit.
 *
 *  Tap an individual property to open a sub-editor
 *  for that value. If a sub-editor is not implemented
 *  for the property's type, an alert message will be shown.
 *
 *  I chose to create a plug-in system for low-level data types
 *  rather than domain objects. This means that if you create a 
 *  sub-class of TTStyle and use basic property types like
 *  CGSize, CGFloat, UIEdgeInsets, UIColor, etc. your custom
 *  subclass will get the editor behavior for free. And if you
 *  do have a few properties that are more complex, you can 
 *  implement your own editor plugin for that complex type.
 *  In the mean-time, you can stil use the editor to edit 
 *  the subset of properties in your custom subclass
 *  that *are* supported.
 *
 *  TODO: design a mechanism for automatically wrapping
 *        instances of this class in a UINavigationController
 *        if being used in a modal context (e.g. the way
 *        that I use SettingsController in this app).
 *
 */

@interface ObjectEditor : TTTableViewController <ValueEditor>
{
    // ValueEditor
    id object;
}

@end
