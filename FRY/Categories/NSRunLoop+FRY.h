//
//  NSRunloop+FRY.h
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRunLoop(FRY)

- (void)fry_runUntilEventsAndLookupsComplete;

@end
