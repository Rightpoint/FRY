//
//  FRYTouchMonitor.h
//  FRY
//
//  Created by Brian King on 12/20/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYTouchMonitor : NSObject

+ (FRYTouchMonitor *)shared;

- (void)enable;
- (void)disable;

@end
