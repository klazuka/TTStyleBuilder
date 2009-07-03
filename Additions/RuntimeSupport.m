//
//  RuntimeSupport.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RuntimeSupport.h"


NSEnumerator *AllClasses(void)
{
    // Create a non-retaining/non-releasing array to hold our values
    // because Class objects have static lifetime.
    CFMutableArrayRef result = CFArrayCreateMutable(NULL, 0, NULL); 
    
    // Iterate over every class in the runtime
    Class * classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 ) {
        classes = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        for (int i = 0; i < numClasses; i++)
            CFArrayAppendValue(result, classes[i]);
        
        free(classes);
    }
    
    return [(NSArray*)result objectEnumerator];
}

NSEnumerator *ImplementationsForProtocol(Protocol *protocol)
{
    CFMutableArrayRef implementations = CFArrayCreateMutable(NULL, 0, NULL);
    
    // Find all classes that conform to |protocol|
    for (Class cls in AllClasses())
        if (class_conformsToProtocol(cls, protocol))
            CFArrayAppendValue(implementations, cls);
    
    return [(NSArray*)implementations objectEnumerator];
}

NSEnumerator *SubclassEnumeratorForClass(Class baseClass)
{
    CFMutableArrayRef subclasses = CFArrayCreateMutable(NULL, 0, NULL);
    
    // Find all sub-classes of |baseClass|
    for (Class cls in AllClasses())
        if (class_getSuperclass(cls) == baseClass)
            CFArrayAppendValue(subclasses, cls);
    
    return [(NSArray*)subclasses objectEnumerator];
}

BOOL IsIdAtEncodeType(NSString *atEncodeType)
{
    return [atEncodeType hasPrefix:@"T@"];
}

Class ClassFromAtEncodeType(NSString *atEncodeType)
{
    NSCAssert(IsIdAtEncodeType(atEncodeType), @"Cannot call ClassFromAtEncodeType() when |atEncodeType| is not an 'id' or equivalent.");
    
    if ([atEncodeType isEqualToString:[NSString stringWithCString:@encode(id)]]) {
        // What I'm about to do here isn't strictly correct since the dynamic type 'id' 
        // imposes no restraints on the object's root class, but it will work for our purposes.
        NSLog(@"WARNING: asked to determine the Class of a property with type 'id'. Returning [NSObject class] as the result, even though it is not strictly correct.");
        return [NSObject class];
    }
    
    // Drop the 'T@"' from the beginning and the trailing '"' at the end.
    NSString *className = [atEncodeType substringWithRange:NSMakeRange(3, [atEncodeType length] - 4)]; 
    
    // Lookup and return the class
    return objc_lookUpClass([className cStringUsingEncoding:NSUTF8StringEncoding]);
}

NSArray *PropertiesOfClass(Class cls, BOOL includeInheritedProperties)
{
    if (cls == Nil) // Recursion base case
        return nil;
    
    // Create a non-retaining/non-releasing array to hold our values
    // because the values that objc_property_t point to
    // have static lifetime (or so I hope!)
    CFMutableArrayRef result = CFArrayCreateMutable(NULL, 0, NULL);
    
    unsigned int numProperties = -1;
    objc_property_t *properties = class_copyPropertyList(cls, &numProperties);
    
    for (unsigned int i = 0; i < numProperties; i++) {
        objc_property_t prop = *(properties+i);
        CFArrayAppendValue(result, prop);
        //NSLog(@"%s.%s with type %s", class_getName(cls), property_getName(prop), property_getAttributes(prop));
    }
    
    free(properties);
    
    if (includeInheritedProperties) {
        // Get the properties from the superclass chain (if any)
        CFArrayRef propertiesFromSuperclasses = (CFArrayRef)PropertiesOfClass(class_getSuperclass(cls), YES);
        if (!propertiesFromSuperclasses)
            return (NSArray*)result;
        
        // Join together the properties defined on |cls| and its superclass chain.
        CFRange entireRange = CFRangeMake(0, CFArrayGetCount(propertiesFromSuperclasses));
        CFArrayAppendArray(result, propertiesFromSuperclasses, entireRange);
    }
    
    return (NSArray*)result;

}
