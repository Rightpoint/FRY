//
//  FRYEventLog.h
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYTouchEventLog : NSObject

@property (assign, nonatomic) NSTimeInterval startingOffset;
@property (strong, nonatomic) NSDictionary *viewLookupVariables;
@property (strong, nonatomic, readonly) NSArray *pointsInTime;

- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time;

- (void)translateTouchesIntoViewCoordinates:(UIView *)view;

- (NSString *)recreationCode;

@end
