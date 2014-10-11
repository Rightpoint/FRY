//
//  FRYEventMonitor.h
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYEventMonitor : NSObject

+ (FRYEventMonitor *)sharedEventMonitor;

- (void)enable;
- (void)disable;

@end
