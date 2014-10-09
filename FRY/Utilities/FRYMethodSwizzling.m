//
//  FRYMethodSwizzling.m
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYMethodSwizzling.h"
#import <objc/runtime.h>


@implementation FRYMethodSwizzling

#pragma mark - Swizzling

// Technique introduced by Mike Ash on the CocoaDev wiki: http://cocoadev.com/MethodSwizzling
void FRYSwizzleSelector(Class class, SEL originalSelector, SEL newSelector)
{
    Method origMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    
    if( class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) )
    {
        class_replaceMethod(class, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

+ (void)exchangeClass:(Class)toClass method:(SEL)toSelector withClass:(Class)fromClass method:(SEL)fromSelector
{
    Method toMethod = class_getInstanceMethod(toClass, toSelector);
    const char *toMethodTypes = method_getTypeEncoding(toMethod);
    IMP fromMethodImp = class_getMethodImplementation(fromClass, fromSelector);
    class_addMethod(toClass, fromSelector, fromMethodImp, toMethodTypes);
    FRYSwizzleSelector(toClass, toSelector, fromSelector);
}

@end
