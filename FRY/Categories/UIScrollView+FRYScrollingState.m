//
//  UIScrollView+FRYScrollingState.m
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIScrollView+FRYScrollingState.h"
#import "FRYMethodSwizzling.h"
#import <objc/runtime.h>
#import "UIView+FRY.h"
#import "UIKit+FRYExposePrivate.h"

static void *FRYScrollingStateScrollingKey = &FRYScrollingStateScrollingKey;

@implementation UIScrollView(FRYScrollingState)

+ (void)load
{
    @autoreleasepool {
        // Using TEST_HOST, it is common for the FRY .a to be loaded twice, and for
        // two separate symbol spaces of this .m file to be executed, and this load
        // to be triggered twice. All static variables in this space are duplicated
        // so it is very painful to control in state that's isolated in this file,
        // so hold a flag in NSThread until I can figure out a better way...
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        if ( threadDictionary[@"FRYScrollingState"] == nil ) {
            threadDictionary[@"FRYScrollingState"] = @(YES);
            [self fry_swizzleProgramaticScrollDetection];
        }
    }
}

+ (void)fry_swizzleProgramaticScrollDetection
{
    [FRYMethodSwizzling exchangeClass:[UIScrollView class]
                               method:@selector(_scrollViewDidEndDecelerating)
                            withClass:[UIScrollView class]
                               method:@selector(fry_scrollViewDidEndDecelerating)];
    [FRYMethodSwizzling exchangeClass:[UIScrollView class]
                               method:@selector(setContentOffset:animated:)
                            withClass:[UIScrollView class]
                               method:@selector(fry_setContentOffset:animated:)];
    [FRYMethodSwizzling exchangeClass:[UIScrollView class]
                               method:@selector(_startTimer:)
                            withClass:[UIScrollView class]
                               method:@selector(fry_startTimer:)];
}

- (BOOL)fry_isAnimating
{
    if ( self.fry_isScrolling || self.tracking || self.dragging ) {
        return YES;
    }
    else {
        return [super fry_isAnimating];
    }
}

-(void)fry_scrollViewDidEndDecelerating
{
    [self fry_setIsScrolling:NO];
    [self fry_scrollViewDidEndDecelerating];
}

- (void)fry_startTimer:(BOOL)timer
{
    [self fry_setIsScrolling:YES];
    [self fry_startTimer:timer];
}

- (void)fry_setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [self fry_setIsScrolling:YES];
    [UIView animateWithDuration:animated ? 0.25 : 0.0
                     animations:^{
                         [self fry_setContentOffset:contentOffset animated:NO];
                     } completion:^(BOOL finished) {
                         [self fry_setIsScrolling:NO];
                     }];

}

- (BOOL)fry_isScrolling;
{
    NSNumber *number = objc_getAssociatedObject(self, FRYScrollingStateScrollingKey);
    return [number boolValue];
}

- (void)fry_setIsScrolling:(BOOL)scrolling
{
    objc_setAssociatedObject(self, FRYScrollingStateScrollingKey, [NSNumber numberWithBool:scrolling], OBJC_ASSOCIATION_RETAIN);
}

@end
