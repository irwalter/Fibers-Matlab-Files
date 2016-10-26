# Matlab

All Matlab functions used in fibers work

[Fiber Counter](/FiberCounter.m) 
Allows the user to specify a volume, and then counts which fibers are within the specified volume

[Fiber Segment Interpolation](/FiberSegmentInterpolation.m)
Allows the user to create more nodes in a fiber. It will only allow the user to divide existing segments. Great if you are trying to decrease precompression time, as it allows one to have far fewer nodes to keep track of, decreasing computation time

[Bundle Mover](/bundleMover.m)
Allows the user to move the bundle as a whole in space. Useful for moldex simulations if the precompression moves the bundle outside of the desired coordinaates.

[Genetic Algorithm](/Genetic-Algorithm)
Non-deterministic optimization good for optimizing functions with many local extrema.
