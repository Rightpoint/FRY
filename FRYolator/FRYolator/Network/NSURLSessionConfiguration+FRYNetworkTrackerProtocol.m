//
//  NSURLSessionConfiguration+FRYNetworkTrackerProtocol.m
//  FRYolator
//
//  Created by Brian King on 3/9/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

// OHHTPStubs doesn't provide a friendly way of re-using this with our own class, so
// this is a clone of their insertion into NSURLSessionConfiguration.

#import <Foundation/Foundation.h>

#if defined(__IPHONE_7_0) || defined(__MAC_10_9)

#import <objc/runtime.h>
#import "FRYNetworkTrackerProtocol.h"


//////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  This helper is used to swizzle NSURLSessionConfiguration constructor methods
 *  defaultSessionConfiguration and ephemeralSessionConfiguration to insert the private
 *  OHHTTPStubsProtocol into their protocolClasses array so that OHHTTPStubs is automagically
 *  supported when you create a new NSURLSession based on one of there configurations.
 */

typedef NSArray*(*DefaultProtocolMethod)(id,SEL);
static DefaultProtocolMethod originalDefaultProtocolMethod;

static DefaultProtocolMethod FRYolatorStubsSwizzle(SEL selector, DefaultProtocolMethod newImpl)
{
    Class cls = NSURLSessionConfiguration.class;
    Class metaClass = object_getClass(cls);

    Method origMethod = class_getClassMethod(cls, selector);
    DefaultProtocolMethod origImpl = (DefaultProtocolMethod)method_getImplementation(origMethod);
    if (!class_addMethod(metaClass, selector, (IMP)newImpl, method_getTypeEncoding(origMethod)))
    {
        method_setImplementation(origMethod, (IMP)newImpl);
    }
    return origImpl;
}

static NSArray* FRYolator_DefaultProtocolMethod(id self, SEL _cmd)
{
    NSArray* defaultProtocols = originalDefaultProtocolMethod(self,_cmd);
    defaultProtocols = [@[[FRYNetworkTrackerProtocol class]] arrayByAddingObjectsFromArray:defaultProtocols];
    return defaultProtocols;
}

@interface NSURLSessionConfiguration(OHHTTPStubsSupport) @end
@implementation NSURLSessionConfiguration(OHHTTPStubsSupport)
+(void)load
{
    originalDefaultProtocolMethod = FRYolatorStubsSwizzle(NSSelectorFromString(@"_defaultProtocolClasses"),
                                                          FRYolator_DefaultProtocolMethod);
}
@end

#endif

