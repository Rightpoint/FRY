# Touch
Touch synthesis is a key portion of interacting with UIKit. Ideally, no private API's would need to be used, and everything would be driven with touches. However due to performance (Keyboard) and implementation time (Scrolling), this is not the case.

## Touch Modeling
FRY performs some modeling of touches that specify touches as a point in time, or multiple points in time. Then `FRYTouchDispatch`, transforms the `FRYTouch` objects into `FRYActiveTouch` objects, which ensure that the touch is properly sent through the `UITouch` lifecycle, with `UITouchPhaseBegan`, `UITouchPhaseMoved`, and `UITouchPhaseEnded` events occurring for all touch objects, at the right time. This separation of modeling from dispatch, allows for simple touch declarations, and for easy touch recording.

Touch Examples:

* Pinch *
```obj-c
[FRYTouch pinchInToCenterOfPoint:p3 point:p4 duration:1];
```

* Complex, recorded interaction *
```obj-c
[FRYTouch touchStarting:0.000 points:33 xyoffsets:0.941f,0.597f,0.000, 0.934f,0.597f,0.094, 0.919f,0.597f,0.121, 0.853f,0.597f,0.147, 0.801f,0.597f,0.164, 0.750f,0.597f,0.182, 0.686f,0.597f,0.215, 0.667f,0.597f,0.232, 0.625f,0.548f,0.264, 0.610f,0.548f,0.282, 0.571f,0.548f,0.322, 0.547f,0.548f,0.350, 0.542f,0.548f,0.367, 0.534f,0.548f,0.386, 0.532f,0.548f,0.416, 0.527f,0.548f,0.448, 0.522f,0.548f,0.472, 0.517f,0.548f,0.504, 0.517f,0.581f,0.604, 0.512f,0.581f,0.692, 0.510f,0.581f,0.720, 0.505f,0.581f,0.737, 0.500f,0.581f,0.765, 0.505f,0.581f,1.170, 0.510f,0.581f,1.216, 0.515f,0.581f,1.263, 0.517f,0.581f,1.350, 0.522f,0.581f,1.382, 0.525f,0.581f,1.452, 0.520f,0.581f,1.624, 0.515f,0.581f,1.641, 0.510f,0.581f,1.670, 0.500f,0.581f,1.698];
```

For More touch declarations, see [FRYTouch.h](FRYTouch.h)

