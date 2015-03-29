//
//  FRYActionContext.h
//  FRY
//
//  Created by Brian King on 3/29/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FRY_ACTION_CONTEXT ({[[FRYActionContext alloc] initWithTestTarget:self inFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__];})

@class FRYAction;

@interface FRYActionContext : NSObject

- (id)initWithTestTarget:(id)target inFile:(NSString *)filename atLine:(NSUInteger)lineNumber;

@property (strong, nonatomic) id testTarget;
@property (copy, nonatomic) NSString *filename;
@property (assign, nonatomic) NSUInteger lineNumber;

- (void)recordFailureWithMessage:(NSString *)message action:(FRYAction *)action results:(NSSet *)results;

@end
