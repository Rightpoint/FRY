//
//  FRYDefines.m
//  FRY
//
//  Created by Brian King on 10/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYDefines.h"
#import <CommonCrypto/CommonCrypto.h>
#import <dlfcn.h>
#import <objc/runtime.h>

NSTimeInterval const kFRYEventDispatchInterval = 0.01;
NSString *kFRYCheckFailedExcetion = @"FRY Failed Check";

@interface FRYCleanupSimulator : NSObject
@end

@implementation FRYCleanupSimulator
+ (void)load
{
    @autoreleasepool {
        [self enableAccessibility];
    }
}

+ (void)enableAccessibility;
{
    NSString *appSupportLocation =  @"/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport";
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *simulatorRoot = [environment objectForKey:@"IPHONE_SIMULATOR_ROOT"];
    if (simulatorRoot) {
        appSupportLocation = [simulatorRoot stringByAppendingString:appSupportLocation];
    }
    
    void *appSupportLibrary = dlopen([appSupportLocation fileSystemRepresentation], RTLD_LAZY);
    
    CFStringRef (*copySharedResourcesPreferencesDomainForDomain)(CFStringRef domain) = dlsym(appSupportLibrary, "CPCopySharedResourcesPreferencesDomainForDomain");
    
    if (copySharedResourcesPreferencesDomainForDomain) {
        CFStringRef accessibilityDomain = copySharedResourcesPreferencesDomainForDomain(CFSTR("com.apple.Accessibility"));
        
        if (accessibilityDomain) {
            CFPreferencesSetValue(CFSTR("ApplicationAccessibilityEnabled"), kCFBooleanTrue, accessibilityDomain, kCFPreferencesAnyUser, kCFPreferencesAnyHost);
            CFRelease(accessibilityDomain);
        }
    }
}

@end