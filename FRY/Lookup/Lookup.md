# Lookup
The primary design goal of FRY's lookup mechanism was extensibility. The design of FRY's lookup mechanism allows it to be extended to support UIAccessibility, CALayer, SceneKit, or SpriteKit.

## Lookup Support
FRY can lookup any object hierarchy, as long as the object can report it's backing view, it's frame inside that view, and the keypaths that provide child objects. The protocol `FRYLookupSupport` encapsulates this state, and is currently implemented by `UIView`, `UIAccessibilityElement` as you would expect. `UIApplication` also implements `FRYLookupSupport`. This allows FRY to transparently query all windows in the application. Even `FRYQuery` implements `FRYLookupSupport` to provide support for the query chaining functionality.

## Other Frameworks
It should be easy to add support for `SpriteKit`, `SceneKit`, or `CALayer`. If you have a project and are interested in adding support, it should be very simple to add. Any complexity that is encountered, is best solved via categories on the objects. This allows the predicate system to work accross frameworks. So for instance, if `CALayer` did not support `accessibilityLabel`, it would be easy to add a category implementation to return the text value of `CATextLayer`.

## Debugging Lookup
Sometimes a query doesn't go as expected, and you want to find out more information. To enable deubg logging, run the following command, and specify a list of objects that are being traversed. All queries that traverse one of the objects specified will log matching information.

```obj-c
[NSObject fry_enableLookupDebugForObjects:@[view1, view2]];
```

This debug logging will print out all predicate information it can, with the values for all of the keypaths specified in all of the predicates and sub predicates. This feature is still new, but very clearly shows where your queries have gone wrong.
