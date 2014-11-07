FRY is an iOS Library inspired by KIF.  The purpose is to simplify iteractions with UIKit and to make writing UI tests simple.

NOTE: Everything is still in alpha, and is subject to change before the 1.0 release.

# Overview
FRY consists of four features to help writing integration tests:

- View Lookup
- Touch Synthesis
- Runloop helper
- Touch Recording and Playback

## View Lookup
Two types of queries are supported, a depth first query that mimics hitTest traversal, and a query that will return all matching objects.

```obj-c
#define FRY_KEY UIApplication.sharedApplication.keyWindow
[FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:actionConfirmation]
                                  usingBlock:^(UIView *view, CGRect frameInView) {
                                          }];
```

View lookup is a simple system based on NSPredicate and KeyPaths.  Add implementation to any object (like CALayer or SceneKit) using -fry_childKeyPaths and -fry_lookupSupport.  Both the accessibilityElements and subviews are searched on UIView.

## Touch Synthesis
FRY uses strongly modeled touches to generate UIKit touch events.  This allows for simple arbitrary touch re-creation, and clear API's for creating common touch sequences.

```obj-c
[FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
         onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel]];
// Other touch objects:
FRYSyntheticTouch *t1 = [FRYSyntheticTouch dragFromPoint:p1 toPoint:p2 forDuration:1];
FRYSyntheticTouch *t2 = [FRYSyntheticTouch pinchInToCenterOfPoint:p3 point:p4 duration:1];
// Or, slightly more complex.
FRYSyntheticTouch *t3 = [FRYSyntheticTouch touchStarting:0.000 points:33 xyoffsets:0.941f,0.597f,0.000, 0.934f,0.597f,0.094, 0.919f,0.597f,0.121, 0.853f,0.597f,0.147, 0.801f,0.597f,0.164, 0.750f,0.597f,0.182, 0.686f,0.597f,0.215, 0.667f,0.597f,0.232, 0.625f,0.548f,0.264, 0.610f,0.548f,0.282, 0.571f,0.548f,0.322, 0.547f,0.548f,0.350, 0.542f,0.548f,0.367, 0.534f,0.548f,0.386, 0.532f,0.548f,0.416, 0.527f,0.548f,0.448, 0.522f,0.548f,0.472, 0.517f,0.548f,0.504, 0.517f,0.581f,0.604, 0.512f,0.581f,0.692, 0.510f,0.581f,0.720, 0.505f,0.581f,0.737, 0.500f,0.581f,0.765, 0.505f,0.581f,1.170, 0.510f,0.581f,1.216, 0.515f,0.581f,1.263, 0.517f,0.581f,1.350, 0.522f,0.581f,1.382, 0.525f,0.581f,1.452, 0.520f,0.581f,1.624, 0.515f,0.581f,1.641, 0.510f,0.581f,1.670, 0.500f,0.581f,1.698];
```

Notice that points and touches are specified as multiples of the frame they are dispatched in.   So a tap at point 0.5 0.5 will touch in the center of the view, regardless of the views frame.  All touches are dispatched on the runloop and do not block the main thread.   Touches are complete when -[FRYTouchDispatch hasActiveTouches] returns NO.

## Runloop Helper
FRY simplifies runloop management of UIKit code (and FRY touch synthesis), with a runloop helper that waits until all animations are complete, all touches have been dispatched, and user interaction is complete.

```obj-c
[[NSRunLoop currentRunLoop] fry_waitForIdle];
```

## Touch Recording and Playback
A side effect of strong touch modeling is that FRY can record live touch events in your application, for later playback.  When the home button is pressed, The FRY commands to reproduce these touches are printed on the console.

**Enable Monitoring**
```obj-c
[[FRYEventMonitor sharedEventMonitor] enable];
```

FRY will attempt to determine an accessibility lookup for the view that was touched, to avoid using screen coordinates if possible and maximize the durability of these commands.  If no accessibility information can be found, absoulte screen coordinates will be used.

# Installation

Add FRY to your Podfile to install.   If you want to use touch recording, add FRY to your application target, otherwise add FRY to your test target.

```
   pod 'FRY', :git => 'git@github.com:Raizlabs/FRY.git'
```

# Design Goals
- Complete Code Coverage and UIKit functionality.
- Clear separation of query and touching.  UIView lookup will never modify the view heirarchy.
- Isolate runloop spinning, and minimize test code (XCTest, specta) dependencies.
- Use simple logic to implement behavior, and categories to hide complex UIKit implementation details.

## Design Questions
- I've never used so many categories, and I'm not sure how to best organize them.

