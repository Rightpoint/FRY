//
//  FRYMethodSwizzling.h
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRYMethodSwizzling : NSObject

+ (void)exchangeClass:(Class)toClass method:(SEL)toSelector withClass:(Class)fromClass method:(SEL)fromSelector;

@end
