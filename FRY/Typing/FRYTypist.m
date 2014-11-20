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
        [self tapKeyWithRepresentedString:representedString];
    }
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
