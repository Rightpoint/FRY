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
#import "FRYIdleCheck.h"
#import "UIKit+FRYExposePrivate.h"

@interface FRYTypist()


@end

@implementation FRYTypist

- (FRYKeyboardLayoutStar *)keyboard
{
    NSPredicate *privateKeyboardPredicate = [NSPredicate predicateWithFormat:@"class.description = %@", @"UIKeyboardLayoutStar"];   
    UIView *keyboard = [[[UIApplication sharedApplication] fry_farthestDescendentMatching:privateKeyboardPredicate] fry_representingView];
    NSAssert(keyboard != nil, @"Could not find the keyboard.  Wait till it appears, or try command-k to reveal the keyboard.");
    return (FRYKeyboardLayoutStar *)keyboard;
}

- (void)typeString:(NSString *)string
{
    unichar         buffer[string.length+1];
    [string getCharacters:buffer range:NSMakeRange(0, string.length)];
    
    for ( NSUInteger i=0; i < string.length; i++ ) {
        NSString *representedString = [NSString stringWithFormat: @"%C", buffer[i]];
        if ( [UIKeyboardImpl sharedInstance].isInHardwareKeyboardMode ) {
            [self tapHardwareKeyWithString:representedString];
        }
        else {
            [self tapSoftwareKeyWithRepresentedString:representedString];
        }
    }
    // Violating my own rule here, and adding a wait.
    // There is probably some state I can check, but I'm not up for snooping
    // around on private api's and it's fixed time for any sized string.
    if ( [UIKeyboardImpl sharedInstance].isInHardwareKeyboardMode ) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

- (void)tapHardwareKeyWithString:(NSString *)string
{
    if ([string isEqualToString:@"\b"]) {
        [[UIKeyboardImpl sharedInstance] deleteFromInput];
    } else {
        [[UIKeyboardImpl sharedInstance] addInputString:string];
    }
}

- (void)tapSoftwareKeyWithRepresentedString:(NSString *)representedString
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
            [self tapSoftwareKeyWithRepresentedString:@"More"];
            [self tapSoftwareKeyWithRepresentedString:representedString];
        }
        else if ( [self.keyboard.keyplane isShiftKeyplane] != [nextKeyPlane isShiftKeyplane]) {
            [self tapSoftwareKeyWithRepresentedString:@"Shift"];
            [self tapSoftwareKeyWithRepresentedString:representedString];
        }
        else {
            [NSException raise:NSInvalidArgumentException format:@"Can not find key"];
        }
    }
    else {
        [self.keyboard fry_simulateTouch:[FRYTouch tap]
                              insideRect:[key frame]];
        BOOL isOK = [[NSRunLoop currentRunLoop] fry_waitWithTimeout:1
                                                           forCheck:^BOOL{
                                                               return self.keyboard.activeKey == nil;
                                                           }];
        NSAssert(isOK, @"active key did not go nil.");
    }
}


@end
