//
//  NSURLSessionConfiguration+FRYNetworkTrackerProtocol.m
//  FRYolator
//
//  Created by Brian King on 3/9/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__IPHONE_7_0) || defined(__MAC_10_9)

#import <objc/runtime.h>
#import "FRYNetworkTrackerProtocol.h"


//////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Swizzle a private method that constructs an array of
 * default protocol handlers.   This will allow insertion
 * of the monitor to all sessions, including AVFoundation on iOS 8.0.
 *
 * This does not work on iOS 7.x :(
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

