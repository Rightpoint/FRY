FRY is an iOS Testing Library inspired by KIF.  The purpose is to simplify the creation and execution of reliable automated UI tests.

NOTE: Everything is still in alpha, and is subject to change before the 1.0 release.

# Features

- View Lookup
- Touch Synthesis
- Touch Recording and Playback

## View Lookup
Easily Lookup views via Accessibility values.

```obj-c
[[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"Tapping"}
                      whenFound:^(NSArray *lookupResults) {
}];
```

## Touch Synthesis

Touch synthesis simulates fingers on the screen interacting with your application.  This is performed by registering touch objects with FRY, which then creates UIEvent objects to dispatch to your application.   Touches are defined using a series of points, and a duration.   Every time the dispatch timer fires, the touch object interpolates where the finger is at that point in time.

```obj-c
[[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
               matchingView:@{kFRYLookupAccessibilityLabel : @"Label To Tap"}];
// Other touch helpers
[FRYSyntheticTouch dragFromPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(1.0f, 1.0f) forDuration:2];
[FRYSyntheticTouch pinchInToCenterOfPoint:CGPointMake(0.0f, 0.0f) point:CGPointMake(1.0f, 1.0f) withDuration:1];
[FRYSyntheticTouch pinchOutFromCenterOfPoint:CGPointMake(0.0f, 0.0f) point:CGPointMake(1.0f, 1.0f) withDuration:1];
```

**NOTE:** The touches above define points on a relative scale from 0-1.  These values are interpolated to span the views entire frame when initiated.

**FIXME:** The distinction between 0-1 interpolation vs window coordinates is done via subclassing, and sort of sucks.  Any thoughts?

Touch synthesis also has a more powerful, gritty API for creating arbitrary touches.   The last argument provides an array of X, Y, and time offsets.   The last time offset in the array is the duration of the touch.

**A touch in the lower left corner, initiated 3 seconds after start**
```obj-c
[[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:3.0
                                                      points:2
                                                   xyoffsets:0.292,0.632,0.000, 0.292,0.632,0.070]
               matchingView:@{@"accessibilityLabel" : @"Gritty Label Tap"}];
```

Touches can also specify screen coordinates instead of relative coordinates.  To do this, use FRYSimulatedTouch instead of FRYSyntheticTouch.

## Touch Recording and Playback

FRY is also able to enable touch monitoring and record all live touch events sent to your application for later playback.  Then, when the home button is pressed, FRY prints out all recorded touches as FRY commands to re-create the touch events.  FRY will do it's best to print out commands that lookup the touched view and then use relative touches to simulate the event since this is more resilient to UI changes.

To playback the recorded touches, create a new test in your unit test framework, and copy and paste the touch sequence into the test.

**Enable Monitoring**
```obj-c
[[FRYEventMonitor sharedEventMonitor] enable];
```

**NOTE:** I'm still looking for ideas of how to better integrate this.

# Installation

Add FRY to your Podfile to install.   If you want to use touch recording, add FRY to your application target, otherwise add FRY to your test target.

```
   pod 'FRY', :git => 'git@github.com:Raizlabs/FRY.git'
```

# Design Goals

- Maximize authentic interactions when possible, driving events via API calls otherwise.
- Allow for multi-threaded use
- Keep runloop spinning outside of the library code
- Keep library logic clean and accomidate UIKit quirks via UIView category extensions.



