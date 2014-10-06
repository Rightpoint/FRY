FRY is an iOS Testing Library inspired by KIF.  The main goals

- Provide powerful touch synthesis.
- Provide view lookup via UIAccessibility or NSPredicate.
- Allow tests to operate on or off main thread.
- Minimize in-authentic test interactions.

KIF, while it implements view lookup and touch synthesis, is designed with too many workarounds spread through out the code.  This has caused a general distrust of the tools authenticity, specifically with the following issues:

- Modifying the view hierarchy durring lookup.
- Driving data sources durring view hierarchy lookup
- Modifying view memory lifecycle events by holding onto views for longer than normal device usage would.
- Spinning the runloop at any time, in any function, for any reason.


