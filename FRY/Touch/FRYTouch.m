//
//  FRYTouchDefinition.m
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouch.h"
#import "FRYPointInTime.h"

static const NSTimeInterval kFRYSwipeDefaultDuration = 0.6;
static const NSTimeInterval kFRYPressDuration = 0.2;

static const NSTimeInterval kFRYTouchLocationMid = 0.5f;
static const NSTimeInterval kFRYSwipeLocationStart = 0.3f;
static const NSTimeInterval kFRYSwipeLocationEnd   = 0.7f;

@interface FRYTouch()

@property (strong, nonatomic, readonly) NSMutableArray *pointsInTime;

@end

@implementation FRYTouch

+ (FRYTouch *)touchStarting:(NSTimeInterval)startingOffset points:(NSUInteger)points xyoffsets:(double)xYorOffset, ...
{
    FRYTouch *touch = [[self alloc] init];
    touch.startingOffset = startingOffset;
    va_list args;
    va_start(args, xYorOffset);
    for ( NSUInteger i = 0; i < points; i++ ) {
        CGFloat x = i == 0 ? xYorOffset : va_arg(args, double);
        CGFloat y = va_arg(args, double);
        NSTimeInterval offset = va_arg(args, double);
        
        [touch.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:CGPointMake(x, y) offset:offset]];
    }
    
    return touch;
}

+ (FRYTouch *)touchStarting:(NSTimeInterval)startingOffset points:(NSUInteger)points absoluteXyoffsets:(double)xYorOffset, ...
{
    // Not sure how to chain in va_args.  Dup code above.
    FRYTouch *touch = [[self alloc] init];
    touch.startingOffset = startingOffset;
    va_list args;
    va_start(args, xYorOffset);
    for ( NSUInteger i = 0; i < points; i++ ) {
        CGFloat x = i == 0 ? xYorOffset : va_arg(args, double);
        CGFloat y = va_arg(args, double);
        NSTimeInterval offset = va_arg(args, double);
        
        [touch.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:CGPointMake(x, y) offset:offset]];
    }
    touch.pointsAreAbsolute = YES;
    return touch;
}

+ (FRYTouch *)tap
{
    return [self tapAtPoint:CGPointMake(0.5, 0.5)];
}

+ (FRYTouch *)tapAtPoint:(CGPoint)point
{
    FRYTouch *definition = [[FRYTouch alloc] init];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:point offset:0.0]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:point offset:0.05]];
    return definition;
}

+ (FRYTouch *)dragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
{
    FRYTouch *definition = [[FRYTouch alloc] init];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:fromPoint offset:0.0]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:toPoint offset:duration]];
    return definition;
}

+ (FRYTouch *)pressAndDragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration
{
    FRYTouch *definition = [[FRYTouch alloc] init];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:fromPoint offset:0.0]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:fromPoint offset:kFRYPressDuration]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:toPoint offset:duration]];
    return definition;
}

+ (FRYTouch *)swipeInDirection:(FRYDirection)direction
{
    return [self swipeInDirection:direction duration:kFRYSwipeDefaultDuration];
}

+ (FRYTouch *)swipeInDirection:(FRYDirection)direction duration:(NSTimeInterval)duration
{
    FRYTouch *touch = nil;
    switch ( direction ) {
        case FRYDirectionUp:
            touch = [self dragFromPoint:CGPointMake(kFRYTouchLocationMid, kFRYSwipeLocationStart)
                                toPoint:CGPointMake(kFRYTouchLocationMid, kFRYSwipeLocationEnd)
                            forDuration:duration];
            break;
        case FRYDirectionDown:
            touch = [self dragFromPoint:CGPointMake(kFRYTouchLocationMid, kFRYSwipeLocationEnd)
                                toPoint:CGPointMake(kFRYTouchLocationMid, kFRYSwipeLocationStart)
                            forDuration:duration];
            break;
        case FRYDirectionRight:
            touch = [self dragFromPoint:CGPointMake(kFRYSwipeLocationStart, kFRYTouchLocationMid)
                                toPoint:CGPointMake(kFRYSwipeLocationEnd,   kFRYTouchLocationMid)
                            forDuration:duration];
            break;
        case FRYDirectionLeft:
            touch = [self dragFromPoint:CGPointMake(kFRYSwipeLocationEnd,   kFRYTouchLocationMid)
                                toPoint:CGPointMake(kFRYSwipeLocationStart, kFRYTouchLocationMid)
                            forDuration:duration];
            break;
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unknown touch direction %zd", direction];
    }
    return touch;
}


+ (NSArray *)pinchInToCenterOfPoint:(CGPoint)finger1 point:(CGPoint)finger2 withDuration:(NSTimeInterval)duration
{
    
    return @[];
}

+ (NSArray *)pinchOutFromCenterToPoint:(CGPoint)finger1 point:(CGPoint)finger2 withDuration:(NSTimeInterval)duration
{
    
    return @[];
}

+ (NSArray *)doubleTap
{
    return [self doubleTapAtPoint:CGPointMake(kFRYTouchLocationMid, kFRYTouchLocationMid)];
}

+ (NSArray *)doubleTapAtPoint:(CGPoint)point
{
    FRYTouch *tap1 = [self tapAtPoint:point];
    FRYTouch *tap2 = [tap1 copy];
    tap2.startingOffset = 0.5;
    return @[tap1, tap2];
}


- (id)init
{
    self = [super init];
    if ( self) {
        _pointsInTime = [NSMutableArray array];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    FRYTouch *copy  = [[self class] allocWithZone:zone];
    copy->_pointsInTime = [self.pointsInTime copyWithZone:zone];
    copy->_startingOffset = self.startingOffset;
    return copy;
}

- (NSTimeInterval)duration
{
    FRYPointInTime *pointInTime = [self.pointsInTime lastObject];
    return pointInTime.offset;
}

- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time
{
    FRYPointInTime *pointInTime = [[FRYPointInTime alloc] init];
    pointInTime.location = point;
    pointInTime.offset = time;
    [self.pointsInTime addObject:pointInTime];
}

- (FRYTouch *)touchInFrame:(CGRect)frame
{
    FRYTouch *touch = [[FRYTouch alloc] init];
    touch.startingOffset = self.startingOffset;
    for ( FRYPointInTime *pit in self.pointsInTime ) {
        CGPoint location = CGPointMake(pit.location.x * frame.size.width + frame.origin.x,
                                       pit.location.y * frame.size.height + frame.origin.y);
        [touch.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:location offset:pit.offset]];
    }
    return touch;
}

- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime
{
    relativeTime -= self.startingOffset;
    // don't over-translate, max out the relative time to the duration.
    relativeTime = MIN(relativeTime, self.duration);
    
            FRYPointInTime *lastPit   = [self.pointsInTime lastObject];
    __block FRYPointInTime *beforePit = [self.pointsInTime objectAtIndex:0];
    __block FRYPointInTime *afterPit  = lastPit;

    [self.pointsInTime enumerateObjectsUsingBlock:^(FRYPointInTime *pit, NSUInteger idx, BOOL *stop) {
        if ( beforePit.offset <= relativeTime &&  pit.offset > relativeTime ) {
            afterPit = pit;
            *stop = YES;
        }
        else {
            beforePit = pit;
        }
    }];
    NSTimeInterval gapInterval = afterPit.offset - beforePit.offset;
    NSTimeInterval interPointInterval = relativeTime - beforePit.offset;
    CGSize pointDifference = CGSizeMake(afterPit.location.x - beforePit.location.x, afterPit.location.y - beforePit.location.y);
    CGFloat timeTranslate = interPointInterval / gapInterval;
    
    CGPoint result = CGPointMake(beforePit.location.x + (pointDifference.width * timeTranslate),
                                 beforePit.location.y + (pointDifference.height * timeTranslate));
    if (isnan(result.x) || isnan(result.y)) {
        result = lastPit.location;
    }
    return result;
}

- (NSString *)description
{
    NSString *description = nil;
    if ( self.pointsInTime.count == 2 ) {
        FRYPointInTime *pointInTime = self.pointsInTime[0];
        description = [NSString stringWithFormat:@"<%@:%p @ %0.1f x %0.1f, startingOffset=%0.1f", self.class, self, pointInTime.location.x, pointInTime.location.y, self.startingOffset];
    } else {
        description = [NSString stringWithFormat:@"<%@:%p pointsInTime.count=%zd, startingOffset=%0.1f", self.class, self, self.pointsInTime.count, self.startingOffset];
    }
    return description;
}

@end
