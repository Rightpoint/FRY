//
//  FRYQueryResult.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYLookupResult : NSObject

- (instancetype)initWithView:(UIView *)view frame:(CGRect)frame;

@property (strong, nonatomic, readonly) UIView *view;
@property (assign, nonatomic, readonly) CGRect frame;

@end
