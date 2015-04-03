//
//  NSPredicate+FRY.h
//  FRY
//
//  Created by Brian King on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Category to help debug lookup failures. It will print out the 
 * actual values along side the predicate query.
 */
@interface NSPredicate(FRY)

- (NSString *)fry_descriptionOfEvaluationWithObject:(id)object;

@end
