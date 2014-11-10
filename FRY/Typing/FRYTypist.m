//
//  FRYTypist.m
//  FRY
//
//  Created by Brian King on 11/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTypist.h"
#import "UIKit+FRYCastCompanions.h"
#import "NSObject+FRYLookup.h"
#import "UIView+FRY.h"
#import "NSRunLoop+FRY.h"

@interface FRYTypist()

@property (strong, nonatomic) FRYKeyboardLayoutStar *keyboard;

@end

@implementation FRYTypist

+ (NSString *)privateKeyboardClassName
{
    return @"UIKeyboardLayoutStar";
}

+ (Class)privateKeyboardClass
{
    return NSClassFromString([self privateKeyboardClassName]);
}

+ (NSPredicate *)privateKeyboardPredicate;
{
    return [NSPredicate predicateWithFormat:@"class.description = %@",
            [self privateKeyboardClassName]];
}

- (id)initWithPrivateKeyboard:(UIView *)keyboard
{
    NSAssert([keyboard isKindOfClass:[self.class privateKeyboardClass]], @"");
    self = [super init];
    if ( self ) {
        _keyboard = (id)keyboard;
    }
    return self;
}

- (void)typeString:(NSString *)string
{
    unichar         buffer[string.length+1];
    [string getCharacters:buffer range:NSMakeRange(0, string.length)];

    for ( NSUInteger i=0; i < string.length; i++ ) {
        NSString *representedString = [NSString stringWithFormat: @"%C", buffer[i]];
        [self tapKeyWithRepresentedString:representedString];
    }
#warning Fix issue with fry_waitForIdle not waiting for the key-press to finish.
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
}

- (void)tapKeyWithRepresentedString:(NSString *)representedString
{
    FRYKBKeyTree *key = [self.keyboard baseKeyForString:representedString];

    FRYKBKeyTree *nextKeyPlane = nil;
    // Calling keyplaneForKey: on this keyplane can return a layout keyplane rather than self.keyboard.keyplane
    // So check the keys array instead.
    if ( [self.keyboard.keyplane.keys containsObject:key] ) {
        nextKeyPlane = self.keyboard.keyplane;
    }
    else {
        nextKeyPlane = [self.keyboard.keyboard keyplaneForKey:key];
    }

    if ( nextKeyPlane != self.keyboard.keyplane ) {
        if ( [self.keyboard.keyplane isLetters] != [nextKeyPlane isLetters]) {
            [self tapKeyWithRepresentedString:@"More"];
            [self tapKeyWithRepresentedString:representedString];
        }
        else if ( [self.keyboard.keyplane isShiftKeyplane] != [nextKeyPlane isShiftKeyplane]) {
            [self tapKeyWithRepresentedString:@"Shift"];
            [self tapKeyWithRepresentedString:representedString];
        }
        else {
            [NSException raise:NSInvalidArgumentException format:@"Can not find key"];
        }
    }
    else {
        [self.keyboard fry_simulateTouch:[FRYSyntheticTouch tap]
                              insideRect:[key frame]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
    }
}


@end
