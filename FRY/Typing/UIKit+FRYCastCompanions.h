//
//  FRYKeyplaneView+Private.h
//  FRY
//
//  Created by Brian King on 11/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * It's a pain to bring "type safety" to private classes.  These are the private classes, with the FRY prefix instead of UI.
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
