# FRY: A UIKit Interaction Library
FRY is an iOS Test Driver. The purpose of this library is to simplify iteractions with UIKit and make writing UI tests simple. FRY aims to provide view lookup, touch interaction and idle detection, to simplify writing UI tests.

FRY also includes a library, `FRYolator`, which helps create integration tests when it is included in your target. The goal of FRYolator is to record all input to the target for later recreation. FRYolator will currently record and generate unit test commands to playback touch events, as well as Network Requests via OHHTTPStubs or Nocilla.

## Lookup and Perform 
FRY commands usually consist of two parts, the lookup, which finds something on the screen to interact with, and the action -- a touch, swipe, scroll, or type event.

```obj-c
// Tap the button "Share" button on row 5
FRY.lookup(atSectionAndRow(0, 5)).lookup(accessibilityLabel(@"Share")).tap();

// Return all the image views that are inside a UITableViewCell
FRY.lookup(ofKind([UITableViewCell class])).lookup(ofKind([UIImageView class]));

// Tap the OK button inside the alert view
FRY.lookup(ofKind([UIAlertView class])).lookup(accessibilityLabel(@"OK")).tap();

// Select the text in the first UITextField
FRY.selectText();

// Select the '180' on the first picker view component and 'lbs' on the second
FRY.selectPicker(@"180", 0).selectPicker(@"lbs", 1);

// Scroll down to row 9 in section 0, and tap that cell
FRY.searchFor(FRYDirectionDown, FRY_atSectionAndRow(0, 9)).tap();
```

More Information on [Queries](FRY/DSL/Query.md) or the [Lookup Implementation](FRY/Lookup/Lookup.md)

### Predicates
FRY provides some helpful macros to create compiler-checked predicates. There is a keypath predicate helper `FRY_PREDICATE_KEYPATH`, and selector predicate helper `FRY_PREDICATE_SELECTOR`. These predicates will make sure that the keypath or selector is valid, and add a `isKindOf:` check for safety. There are also a number short-hand helpers in [FRYDefines.h](FRY/FRYDefines.h) for more common lookups.


### Touch Synthesis
FRY uses strongly modeled touches to generate UIKit touch events.  This allows for simple arbitrary touch creation, and clear API's for creating common touch sequences.

```obj-c
FRY.lookup(@"My Label").tap();
FRY.lookup(@"My Label").touch([FRYTouch doubleTap]);
FRY.lookup(@"My Label").touch([FRYTouch dragFromPoint:p1 toPoint:p2 forDuration:1]);
```

More Information on [Touch Synthesis](FRY/Touch/Touch.md)

### Idle Detection
There is a helper [FRYIdleCheck](FRY/Idle/FRYIdleCheck.h) that will spin the runloop until all touches are finished and all UI animations have completed. This greatly simplifies flow control, and eliminiates the vast majority of `CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false)`. If you find yourself wanting to add these to your tests, consider adding an animation to your UI instead, or providing additional application-specific checks to the delegate.  All [FRYQuery](FRY/DSL/FRYQuery.h) actions will call [FRYIdleCheck](FRY/Idle/FRYIdleCheck.h) before and after the various actions.

## FRYolator
FRYolator will be enabled when a special tap sequence is performed. Once enabled, all touch and network activity will be recorded. When the app is backgrounded and put in the foreground, the event stream will be saved as a `.fry` file. Inside the `.fry` bundle are all of the touch events and network communication.

*To Enable Monitoring*
```obj-c
#ifdef DEBUG
[[FRYolatorUI shared] registerGestureEnablingOnView:self.window];
#endif
```

FRY will attempt to use relative coordinates with accessibility lookup information for the view that was touched. This will maximize the reliability of these commands when UI changes occur. If no accessibility information can be found, absoulte screen coordinates will be used.

### Touch Visualization
FRYolator can also visualize touch events. This is used by FRYolator to indicate that recording is active, but can also be easily enabled in the automated tests to aid in writing tests.

*To Enable Touch Visualization*
```obj-c
[[FRYTouchHighlightWindowLayer shared] enable];
```

## Installation
Add FRY to your Podfile to install. If you want to use touch recording, add FRYolator to your application target. Only add it to the 'Debug' configuration to ensure it is not submitted to the app store, or add it to a debug target.

*Podfile with Debug configuration*
```
pod 'FRY'

target :YourApplication do
  pod 'FRY/FRYolator', :configuration => "Debug"
end
```

## Influences

### KIF
KIF is amazing framework that basically started UI testing on iOS. The core design difference with KIF that pushed me to write FRY without looking to maintain compatibility is that looking up a view can modify the view heirarchy to find it. This causes a lot of bizarre issues, and it is not usually what I want from a testing perspective.

### Robot
Robot is a newer contender in the UI Testing world, and is very interesting, with a primary goal of speed.
