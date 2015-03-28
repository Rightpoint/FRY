//
//  FRYPredicateBuilder.m
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "FRYPredicateBuilder.h"
#import "NSPredicate+FRY.h"

@interface FRYPredicateBuilder ()

@property (strong, nonatomic) NSMutableArray *subPredicates;

@end

@implementation FRYPredicateBuilder

- (NSPredicate *)predicate
{
    return [NSCompoundPredicate andPredicateWithSubpredicates:self.subPredicates];
}

- (FRYDSLStringBlock)a11yLabel
{
    return ^(NSString *accessibilityLabel) {
        [self.subPredicates addObject:[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel]];
        return self;
    };
}

- (FRYDSLStringBlock)a11yValue
{
    return ^(NSString *accessibilityValue) {
        [self.subPredicates addObject:[NSPredicate fry_matchAccessibilityValue:accessibilityValue]];
        return self;
    };
}

- (FRYDSLTraitsBlock)a11yTraits
{
    return ^(UIAccessibilityTraits traits) {
        [self.subPredicates addObject:[NSPredicate fry_matchAccessibilityTrait:traits]];
        return self;
    };
}

- (FRYDSLClassBlock)ofClass
{
    return ^(Class klass) {
        [self.subPredicates addObject:[NSPredicate fry_matchClass:klass]];
        return self;
    };
}

- (FRYDSLIndexPathBlock)atIndexPath
{
    return ^(NSIndexPath *indexPath) {
        [self.subPredicates addObject:[NSPredicate fry_matchContainerIndexPath:indexPath]];
        return self;
    };
}

- (FRYDSLIndexPathBlock)rowAtIndexPath
{
    return ^(NSIndexPath *indexPath) {
        [self.subPredicates addObject:[NSPredicate fry_matchClass:[UITableViewCell class]]];
        [self.subPredicates addObject:[NSPredicate fry_matchContainerIndexPath:indexPath]];
        return self;
    };
}

- (FRYDSLIndexPathBlock)itemAtIndexPath
{
    return ^(NSIndexPath *indexPath) {
        [self.subPredicates addObject:[NSPredicate fry_matchClass:[UICollectionViewCell class]]];
        [self.subPredicates addObject:[NSPredicate fry_matchContainerIndexPath:indexPath]];
        return self;
    };
}

- (FRYDSLPredicateBlock)matching
{
    return ^(NSPredicate *predicate) {
        [self.subPredicates addObject:predicate];
        return self;
    };
}

- (BOOL)evaluateWithObject:(id)object
{
    return [self.predicate evaluateWithObject:object];
}

@end
