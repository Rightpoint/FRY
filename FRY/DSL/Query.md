# Query API

`FRYQuery` provides a consistent DSL to lookup and interact with UI components, as well as mechanisms to retry queries until they are satisfied, and report failures to test frameworks. The primary goal of `FRYQuery` is to simplify test writing as much as possible.

## Query

The primary function of the FRYQuery object is to traverse the application hierarchies, and return matching objects. `FRY` is a macro for setting up the default query object. This returns a new FRYQuery object that sets it's target to `[UIApplication sharedApplication]`. A query can be focused with `lookup(predicate)`, which will filter the results from the current target.

*Query Examples*
```obj-c
```

## Sub Query
Sub-Queries are a way of starting a new query starting with the results from the previous query. For Example:

```obj-c
// Tap the button view of row 5
FRY.lookup(FRY_atSectionAndRow(0, 5)).lookup(FRY_accessibilityLabel(@"Button")).tap();

// Return all the image views that are inside a UITableViewCell
FRY.lookup(FRY_ofKind([UITableViewCell class])).lookup(FRY_ofKind([UIImageView class]));

// Tap the OK button inside the alert view
FRY.lookup(FRY_ofKind([UIAlertView class])).lookup(FRY_accessibilityLabel(@"OK")).tap();
```

## Query Actions
Query Actions provide an easy way of interacting with the application, allowing the user to touch, scroll, or select. The query actions are smart, and will perform their own sub-query if needed to ensure that the object they are working with is accurate. For instance, the scrolling actions will look for the first UIScrollView inside the target before attempting to perform a scroll.

```obj-c
// Scroll down to row 9 in section 0, and tap that cell
FRY.searchFor(FRYDirectionDown, FRY_atSectionAndRow(0, 9)).tap();

// Find all views with non-nil accessibilityLabels
views = FRY.lookup(FRY_PREDICATE_KEYPATH(UIView, accessibilityLabel, !=, nil)).views;

// Select the text in the first UITextField
FRY.selectText();

```

More details are included inline with the Query Action method declarations.

## Check Actions
The other use of a query is to perform checks on the view hierarchy. There are a few simple checks provided, to see if an element is present, absent, or in certain quantity. The method `check` is available for more advanced view interrogation. The use of `present` and `absent` are the best way to control the flow of your test.


## Lookup Helpers
There is one lookup helper, `lookupByAccessibilityLabel`, which will perform a search that matches the accessibilityLabel, is on the screen, and is not hidden. This is provided as a convienence, and is the most common lookup to use in the majority of cases.
