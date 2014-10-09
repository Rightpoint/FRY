//
//  FRYQueryResult.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYLookupResult : NSObject

@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) CGRect frame;

// The thought here is to have lookup's generate actions that can cause visibility.   TBD.
//@property (copy, nonatomic) NSArray *actions;

@end
