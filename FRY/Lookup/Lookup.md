# Lookup
The primary design goal of FRY's lookup mechanism was extensibility. The design of FRY's lookup mechanism allows it to be extended to support UIAccessibility, CALayer, SceneKit, or SpriteKit.

## Query API

`FRYQuery` provides a consistent DSL to lookup and interact with UI components, as well as mechanisms to retry queries until they are satisfied, and report failures to test frameworks. The primary goal of `FRYQuery` is to simplify test writing as much as possible.

Query objects traverse all of the focused objects children, and return the matching objects as results. The query object has `lookup` methods that provide predicates to filter which of the children objects are matched as results. `FRY` is a macro for setting up the default query object. This returns a new FRYQuery object that sets it's target to `[UIApplication sharedApplication]`.

### Sub Query
Sub-Queries are a way of starting a new query starting with the results from the previous query. For Example:

*Return all of the UIImageView objects that are subviews of UITableView*
```obj-c
FRY.lookup(FRY_ofKind([UITableViewCell class])).lookup(FRY_ofKind([UIImageView class]));
```

### Shallow Queries
By default, FRYQuery will match all objects that match the configured filter. If `shallow()` is specified, the query will become a shallow query, and return the first object that matches. All Query Actions enable shallow queries. A depth first query is not available, because I have not had a reason to need it, although it would be simple to add.

### Query Actions
Query Actions provide an easy way of initiating FRY actions from inside the FRYQuery. Once an query is focused enough, the user can touch, scroll, or select. The query actions are smart, and will perform their own sub-query if needed to ensure that the object they are working with is accurate. For instance, the scrolling actions will look for the first UIScrollView before attempting to perform a scroll. More details are included inline with the Query Action method declarations.

### Check Actions
The other use of a query is to perform checks on the view hierarchy. There are a few simple checks provided, to see if an element is present, absent, or in certain quantity. The method `check` is available for more advanced view interrogation.

### Lookup Helpers
There is one lookup helper, `lookupByAccessibilityLabel`, which will perform a search that matches the accessibilityLabel, is on the screen, and is not hidden. This is provided as a convienence, and is the most common lookup to use in the majority of cases.

## Lookup Implementation
`FRYLookup` provides 3 different lookup algorithms for finding object. A full query, a shallow query, and a depth first query. The depth first query turns out to be the least helpful, and is rarely used. This API is usually only used internally, but it is available for public consumption, if the block-based `FRYQuery` API is not needed

### Lookup Support
FRY can lookup any object hierarchy, as long as the object can report it's backing view, it's frame inside that view, and the keypaths that provide child objects. The protocol `FRYLookupSupport` encapsulates this state, and is currently implemented by `UIView`, `UIAccessibilityElement` as you would expect. `UIApplication` also implements `FRYLookupSupport`. This allows FRY to transparently query all windows in the application. Even `FRYQuery` implements `FRYLookupSupport` to provide support for the query chaining functionality.

### Other Frameworks
It should be easy to add support for `SpriteKit`, `SceneKit`, or `CALayer`. If you have a project and are interested in adding support, it should be very simple to add. Any complexity that is encountered, is best solved via categories on the objects. This allows the predicate system to work accross frameworks. So for instance, if `CALayer` did not support `accessibilityLabel`, it would be easy to add a category implementation to return the text value of `CATextLayer`.

### Debugging Lookup
Sometimes a query doesn't go as expected, and you want to find out more information. To enable deubg logging, run the following command, and specify a list of objects that are being traversed. All queries that traverse one of the objects specified will log matching information.

```obj-c
[NSObject fry_enableLookupDebugForObjects:@[view1, view2]];
```

This debug logging will print out all predicate information it can, with the values for all of the keypaths specified in all of the predicates and sub predicates. This feature is still new, but very clearly shows where your queries have gone wrong.
