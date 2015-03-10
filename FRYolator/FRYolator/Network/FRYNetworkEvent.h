//
//  FRYNetworkEvent.h
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYEvent.h"

typedef NS_ENUM(NSUInteger, FRYNetworkEventCodeGenerationStyle) {
    FRYNetworkEventCodeGenerationStyleOHHTTPStubs,
    FRYNetworkEventCodeGenerationStyleNocilla,
};

@interface FRYNetworkEvent : FRYEvent

+ (void)setCodeGenerationStyle:(FRYNetworkEventCodeGenerationStyle)codeStyle;

@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSError *error;

@end
