//
//  RuntimeSupport.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RuntimeSupport.h"

/*
 *      SubclassEnumeratorForClass
 *
 *  This creates an enumerator of the *direct* subclasses of the class
 *  that you provide. You can use this with fast enumeration.
 *
 *  Example usage:
 *
 *  for (Class klass in SubclassEnumeratorForClass([UIView class]))
 *      NSLog(@"Found subclass: %s", class_getName(klass));
 */
NSEnumerator *SubclassEnumeratorForClass(Class baseClass)
{
    NSMutableArray *subclasses = [NSMutableArray array];
    
    // find all sub-classes of baseClass
    Class * classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
        classes = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        for (int i = 0; i < numClasses; i++) {
            Class klass = classes[i];
            
            if (class_getSuperclass(klass) == baseClass) {
                // yes, addObject: expects an |id|, but I give it a |Class|
                // since they are both pointers. Of course, Apple could break
                // this in the future, but this is not meant to be bullet-proof
                // software here.
                [subclasses addObject:klass];
            }
        }
        
        free(classes);
    }
    
    return [subclasses objectEnumerator];
}















