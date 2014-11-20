# Idle Checks

Idle checks are a helper concept to allow the flow control of the unit tests be respectful of any asynchronous activity in your application.
Idle checks can be composed together to ensure that the system has settled down before performing the next action.

By default, the system will wait for:

```
[[UIApplication sharedApplication] isIgnoringInteractionEvents] == NO
[[UIApplication sharedApplication] fry_animatingViews].count == 0
[[FRYTouchDispatch shared] hasActiveTouches] == NO
```

More idle checks can be if your application requires it.  A proper UI design, theoretically should not require any modifications, as a UI element should be animating at all times if the system is not idle.   However this is not always the case.  You can add a FRYIdleOperationQueueCheck that, for instance, ensures that the NSOperationQueue managing your network requests is empty before proceeding.


Also, some times, ignoring specific views, or types of views is required since the animation does not want to block iteraction with the application.   To do this, there is a class method on FRYAnimationCompleteCheck that allows you to specify predicates of views that should be ignored.

[FRYAnimationCompleteCheck addIgnorePredicate:[NSPredicate fry_parentViewOfClass:[UIActivityIndicatorView class]]];

Animation checks are determined by looking at the CAAnimation objects on the backing CALayer in the fry_isAnimating method.   Subclasses can change this behavior to perform additional checks if required.

This is a pretty wordy API, for a pretty basic BOOL check, but was chosen for:

- Composability:
I wanted to be able to allow customization and re-use existing checks

- Debug-ability
If an idle check fails, the error it reports should be very clear to the test writer.