//
//  FRYLookupSupport.h
//  FRY
//
//  Created by Brian King on 11/13/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRYLookupSupport <NSObject>
@optional
/**
 * The keypaths that should be traversed.
 */
+ (NSSet *)fry_childKeyPaths;

/**
 * The view object that contains this object
 */
- (UIView *)fry_representingView;

/**
 * The location inside the frame where this object exists.
 */
- (CGRect)fry_frameInView;

@end
