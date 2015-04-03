# FRY: A UIKit Interaction Library

FRY is an iOS Test Driver. The purpose of this library is to simplify iteractions with UIKit and make writing UI tests simple.

NOTE: Everything is still in alpha, and is subject to change before the 1.0 release.

## Overview
FRY consists of three core features to implement touch driven integration tests:

- View Lookup
- Touch Modeling
- Idle Detection

FRY also includes a library, `FRYolator`, which helps create integration tests when it is included in your target. The goal of FRYolator is to record all input to the target for later recreation. FRYolator will currently record and generate unit test commands to playback the following:

- Touch
- Network (Nocilla + OHHTTPStubs)

### View Lookup
Two types of queries are supported, a shallow query, and a query that will return all matching objects.

```obj-c
// Tap the button "Share" in row 5
FRY.lookup(FRY_atSectionAndRow(0, 5)).lookup(FRY_accessibilityLabel(@"Share")).tap();

// Return all the image views that are inside a UITableViewCell
FRY.lookup(FRY_ofKind([UITableViewCell class])).lookup(FRY_ofKind([UIImageView class]));

// Tap the OK button inside the alert view
FRY.lookup(FRY_ofKind([UIAlertView class])).lookup(FRY_accessibilityLabel(@"OK")).tap();
```

More Information on [Queries](FRY/Query/Query.md)

For more information on the [Lookup Implementation](FRY/Lookup/Lookup.md)

### Touch Synthesis
FRY uses strongly modeled touches to generate UIKit touch events.  This allows for simple arbitrary touch re-creation, and clear API's for creating common touch sequences.

```obj-c
FRY.lookup(@"My Label").tap();
FRY.lookup(@"My Label").touch([FRYTouch doubleTap]);
FRY.lookup(@"My Label").touch([FRYTouch dragFromPoint:p1 toPoint:p2 forDuration:1]);
```

More Information on [Touch Synthesis](FRY/Touch/Touch.md)

### Idle Detection
There is a helper `FRYIdleCheck` that will spin the runloop until all touches are finished and all UI Animations have completed. This greatly simplifies flow-control, and eliminiates the vast majority of `CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false)`. If you find yourself wanting to add these to your tests, consider adding an animation to your UI instead.  

## FRYolator
FRYolator will be enabled when a special tap sequence is performed. Once enabled, all touch and network activity will be recorded. When the app is backgrounded and put in the foreground, the event stream will be saved as a `.fry` file. Inside the `.fry` bundle are all of the touch events and network communication.

*To Enable Monitoring*
```obj-c
[[FRYolatorUI shared] registerGestureEnablingOnView:self.window];
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
Robot is a newer contender in the UI Testing world, and is very interesting, but it's primary goal is speed, not accuracy of environment.

## Design Goals
- Complete Code Coverage and UIKit functionality.
- Clear separation of query and touching. UIView lookup will never modify the view heirarchy.
- Use simple logic to implement behavior, and categories to hide complex UIKit implementation details.
- Minimize knowledge of and checks against UIKit private classes.
- Isolate runloop spinning.


