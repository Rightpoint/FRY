//
//  NSPredicate+FRY.m
//  FRY
//
//  Created by Brian King on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSPredicate+FRY.h"
#import "UIView+FRY.h"
#import "UIAccessibility+FRY.h"

@implementation NSPredicate(FRY)

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel
{
    NSParameterAssert(accessibilityLabel);
    return [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(fry_accessibilityLabel)), accessibilityLabel];
}

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue
{
    NSParameterAssert(accessibilityLabel);
    NSParameterAssert(accessibilityValue);
    return [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@",
            NSStringFromSelector(@selector(fry_accessibilityLabel)), accessibilityLabel,
            NSStringFromSelector(@selector(fry_accessibilityValue)), accessibilityValue];
}

+ (NSPredicate *)fry_matchAccessibilityValue:(NSString *)accessibilityValue;
{
    NSParameterAssert(accessibilityValue);
    return [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(fry_accessibilityValue)), accessibilityValue];
}

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel accessibilityTrait:(UIAccessibilityTraits)traits
{
    return [NSPredicate predicateWithFormat:@"%K = %@ && (%K & %@) = %@",
            NSStringFromSelector(@selector(fry_accessibilityLabel)), accessibilityLabel,
            NSStringFromSelector(@selector(accessibilityTraits)), @(traits), @(traits)];
}

+ (NSPredicate *)fry_matchAccessibilityTrait:(UIAccessibilityTraits)traits
{
    return [NSPredicate predicateWithFormat:@"(%K & %@) = %@",
            NSStringFromSelector(@selector(accessibilityTraits)), @(traits), @(traits)];
}

+ (NSPredicate *)fry_matchAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    return [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(accessibilityIdentifier)), accessibilityIdentifier];
}

+ (NSPredicate *)fry_matchContainerIndexPath:(NSIndexPath *)indexPath
{
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate fry_matchClass:[UIView class]],
                                                                [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(fry_indexPathInContainer)), indexPath]
                                                                ]];
    
}

+ (NSPredicate *)fry_matchClass:(Class)klass
{
    return [NSPredicate predicateWithFormat:@"SELF isKindOfClass:%@", klass];
}

- (NSString *)fry_descriptionOfEvaluationWithObject:(id)object
{
    return @"Unknown";
}

@end

@implementation NSCompoundPredicate (FRY)

- (NSString *)fry_descriptionOfEvaluationWithObject:(id)object
{
    NSMutableArray *descriptions = [NSMutableArray array];
    for ( NSPredicate *sub in self.subpredicates ) {
        [descriptions addObject:[sub fry_descriptionOfEvaluationWithObject:object]];
    }
    return [descriptions componentsJoinedByString:[self fry_descriptionOfCompoundPredicateType]];
}

- (NSString *)fry_descriptionOfCompoundPredicateType
{
    NSString *result = nil;
    switch ( self.compoundPredicateType) {
        case NSNotPredicateType:
            result = @"NOT";
            break;
        case NSAndPredicateType:
            result = @"AND";
            break;
        case NSOrPredicateType:
            result = @"OR";
            break;
        default:
            break;
    }
    return result;
}

@end

NSString *FRYStringFromPredicateOperatorType(NSPredicateOperatorType operator) {
    switch ( operator ) {
        case NSLessThanPredicateOperatorType:
            return @"<";
        case NSLessThanOrEqualToPredicateOperatorType:
            return @"<=";
        case NSGreaterThanPredicateOperatorType:
            return @">";
        case NSGreaterThanOrEqualToPredicateOperatorType:
            return @">=";
        case NSEqualToPredicateOperatorType:
            return @"==";
        case NSNotEqualToPredicateOperatorType:
            return @"!=";
        case NSMatchesPredicateOperatorType:
            return @"MATCHES";
        case NSLikePredicateOperatorType:
            return @"LIKE";
        case NSBeginsWithPredicateOperatorType:
            return @"BEGINS WITH";
        case NSEndsWithPredicateOperatorType:
            return @"ENDS WITH";
        case NSInPredicateOperatorType:
            return @"IN";
        case NSCustomSelectorPredicateOperatorType:
            return @"CUSTOM SELECTOR";
        case NSContainsPredicateOperatorType:
            return @"CONTAINS";
        case NSBetweenPredicateOperatorType:
            return @"BETWEEN";
    }
    return @"<Unknown>";
}

@implementation NSExpression (FRY)

- (NSString *)fry_descriptionOfDirectEvaluationWithObject:(id)object
{
    NSString *result = [self description];
    switch ( self.expressionType ) {
        case NSKeyPathExpressionType:
            // All that work to add this.
            result = [NSString stringWithFormat:@"(%p.%@ = '%@')", object, self.keyPath, [object valueForKeyPath:self.keyPath]];
            break;
        default: ;
    }
    return result;
}

@end

@implementation NSComparisonPredicate (FRY)

- (NSString *)fry_descriptionOfEvaluationWithObject:(id)object
{
    NSString *result = nil;
    switch ( self.comparisonPredicateModifier ) {
        case NSDirectPredicateModifier:
            result = [self fry_descriptionOfDirectEvaluationWithObject:object];
            break;
        default:
            result = @"Unsupported to-many description.  FIXME!";
            break;
    }
    return result;
}

- (NSString *)fry_descriptionOfDirectEvaluationWithObject:(id)object
{
    NSString *lhs = [self.leftExpression fry_descriptionOfDirectEvaluationWithObject:object];
    NSString *rhs = [self.rightExpression fry_descriptionOfDirectEvaluationWithObject:object];

    return [NSString stringWithFormat:@"(%@ %@ %@)", lhs, FRYStringFromPredicateOperatorType(self.predicateOperatorType), rhs];
}

@end


