//
//  FRYTypist.m
//  FRY
//
//  Created by Brian King on 11/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTypist.h"
#import "NSObject+FRYLookup.h"
#import "FRYTouchDispatch.h"
#import "FRYTouch.h"
#import "UIKit+FRYExposePrivate.h"
#import "NSRunLoop+FRY.h"

/**
 * It's a pain to bring "type safety" to private classes. These are the private classes, with the FRY prefix instead of UI.
 * These classes never actually exist, but we cast to them to get some help from the compiler.
 */
@interface FRYKBKeyTree : NSObject

- (BOOL)isLetters;
- (BOOL)isShiftKeyplane;
- (id)keys;
- (id)keyplaneForKey:(id)arg1;
- (struct CGRect)frame;

@end

@interface FRYKeyboardLayoutStar : UIView

@property(retain, nonatomic) FRYKBKeyTree *activeKey;
@property(readonly, nonatomic) FRYKBKeyTree *keyplane;
@property(readonly, nonatomic) FRYKBKeyTree *keyboard;
- (FRYKBKeyTree *)baseKeyForString:(NSString *)arg1;

@end

@implementation FRYTypist

+ (FRYKeyboardLayoutStar *)keyboard
{
    NSPredicate *privateKeyboardPredicate = [NSPredicate predicateWithFormat:@"class.description = %@", @"UIKeyboardLayoutStar"];   
    UIView *keyboard = [[[UIApplication sharedApplication] fry_farthestDescendentMatching:privateKeyboardPredicate] fry_representingView];
    NSAssert(keyboard != nil, @"Could not find the keyboard. Wait till it appears, or try command-k to reveal the keyboard.");
    return (FRYKeyboardLayoutStar *)keyboard;
}

+ (void)typeString:(NSString *)string
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
    [[[UIKeyboardImpl sharedInstance] taskQueue] waitUntilAllTasksAreFinished];
    // Give UIKit a chance to update the view so as to not confuse anyone.
    [[NSRunLoop currentRunLoop] fry_handleSources];
}

+ (void)tapHardwareKeyWithString:(NSString *)string
{
    if ([string isEqualToString:@"\b"]) {
        [[UIKeyboardImpl sharedInstance] deleteFromInput];
    } else {
        [[UIKeyboardImpl sharedInstance] addInputString:string];
    }

}

+ (void)tapSoftwareKeyWithRepresentedString:(NSString *)representedString
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
        [[FRYTouchDispatch shared] simulateTouches:@[[FRYTouch tap]]
                                            inView:self.keyboard
                                             frame:[key frame]];
    }
}

@end
