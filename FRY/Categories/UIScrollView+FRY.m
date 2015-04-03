//
//  UIScrollView+FRY.m
//  FRY
//
//  Created by Brian King on 11/16/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIScrollView+FRY.h"
#import "NSObject+FRYLookup.h"
#import "FRYTouch.h"
#import "FRYIdleCheck.h"

@implementation UIScrollView(FRY)

- (BOOL)fry_searchForViewsMatching:(NSPredicate *)predicate lookInDirection:(FRYDirection)direction
{
    NSSet *results = [self fry_nonExhaustiveShallowSearchForChildrenMatching:predicate];
    while ( results.count == 0 && [self fry_moreSpaceInSearchDirection:direction] ) {
        @autoreleasepool {
            [self fry_scrollInDirection:direction];
            results = [self fry_nonExhaustiveShallowSearchForChildrenMatching:predicate];
        }
    }
    
    return [self fry_scrollToLookupResultMatching:predicate];
}

- (BOOL)fry_scrollToLookupResultMatching:(NSPredicate *)predicate
{
    id<FRYLookup> result = [self fry_farthestDescendentMatching:predicate];
    BOOL ok = result != nil;
    if ( result ) {
        CGRect viewFrame = [self convertRect:[result fry_frameInWindow] fromView:[result fry_representingView].window];
        viewFrame.origin.x -= self.contentInset.left;
        viewFrame.origin.y -= self.contentInset.top;

        [self setContentOffset:viewFrame.origin animated:YES];
        ok = [[FRYIdleCheck system] waitForIdle] == NO;
    }
    return result != nil;
}

- (BOOL)fry_moreSpaceInSearchDirection:(FRYDirection)direction
{
    BOOL moreSpace = NO;
    switch ( direction ) {
        case FRYDirectionUp:
            moreSpace = self.contentOffset.y > self.contentInset.top;
            break;
        case FRYDirectionDown:
            moreSpace = self.contentOffset.y + self.bounds.size.height < self.contentSize.height + self.contentInset.bottom;
            break;
        case FRYDirectionLeft:
            moreSpace = self.contentOffset.x > self.contentInset.left;
            break;
        case FRYDirectionRight:
            moreSpace = self.contentOffset.x + self.bounds.size.width < self.contentSize.width + self.contentInset.top;
            break;
    }
    return moreSpace;
}

- (void)fry_scrollInDirection:(FRYDirection)direction
{
    CGPoint offset = self.contentOffset;
    switch ( direction ) {
        case FRYDirectionUp:
            offset.y -= self.frame.size.height;
            break;
        case FRYDirectionDown:
            offset.y += self.frame.size.height;
            break;
        case FRYDirectionLeft:
            offset.x -= self.frame.size.width;
            break;
        case FRYDirectionRight:
            offset.x += self.frame.size.width;
            break;
    }
    offset.x = MIN(offset.x, self.contentSize.width - self.bounds.size.width);
    offset.y = MIN(offset.y, self.contentSize.height - self.bounds.size.height);
    [self setContentOffset:offset animated:YES];
    [[FRYIdleCheck system] waitForIdle];
}

@end
