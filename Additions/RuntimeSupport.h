//
//  RuntimeSupport.h
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"


/* 
 *      AllClasses()
 *
 *  Returns an enumerator of every class that has
 *  been registered in the runtime system. 
 *
 *  Example usage:
 *
 *  for (Class cls in AllClasses())
 *      NSLog(@"Found class %s", class_getName(cls));
 */
NSEnumerator *AllClasses(void);

/*
 *      SubclassEnumeratorForClass()
 *
 *  Returns an enumerator of the *direct* subclasses of the class
 *  that you provide. You can use this with fast enumeration.
 *
 *  Example usage:
 *
 *  for (Class cls in SubclassEnumeratorForClass([UIView class]))
 *      NSLog(@"Found subclass: %s", class_getName(cls));
 */
NSEnumerator *SubclassEnumeratorForClass(Class klass);

/*
 *      ImplementationsForProtocol()
 *
 *  Returns an enumerator of every class that conforms
 *  to the provided protocol. You can use the resulting
 *  enumerator with fast enumeration.
 *
 *  Example usage:
 *
 *  const char *protocolName = "MyDataSourceProtocol";
 *  for (Class cls in ImplementationsForProtocol(objc_getProtocol(protocolName)))
 *      NSLog(@"%s conforms to protocol %s", class_getName(cls), protocolName);
 */
NSEnumerator *ImplementationsForProtocol(Protocol *protocol);

/*
 *      IsIdAtEncodeType()
 *
 *  Returns YES if |atEncodeType| is of the
 *  general format that describes an object of
 *  type 'id' (which is to say, struct objc_object*).
 *
 */
BOOL IsIdAtEncodeType(NSString *atEncodeType);

/*
 *      ClassFromAtEncodeType()
 *
 *  Uses |atEncodeType| to lookup the corresponding 
 *  Class data structure in the runtime.
 */
Class ClassFromAtEncodeType(NSString *atEncodeType);

/*
 *      PropertiesOfClass()
 *
 *  Constructs an array of the properties defined
 *  for a class. If |includeInheritedProperties| is YES,
 *  then this function will also return properties
 *  defined in cls's superclass chain.
 */
NSArray *PropertiesOfClass(Class cls, BOOL includeInheritedProperties);
