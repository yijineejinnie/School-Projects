%
% the projector has a resolution of 1280x800 so
% there are black bars of 128 pixels on either 
% side of our 1024 wide pixel region
%
Htrue = [zeros(800,128) repmat(0:1023,800,1) zeros(800,128)];
Vtrue = [zeros(800,128) repmat((0:799)',1,1024) zeros(800,128)];
masktrue = [zeros(800,128) ones(800,1024) zeros(800,128)];

%
% run decode on the images
%
% this data is perfect so we can use a very small threshold
thresh = 0.00000001;  
[H,Hmask] = decode('gray/',0,19,thresh);
[V,Vmask] = decode('gray/',20,39,thresh);

%
% compare results
%
assert(all(H(:)==Htrue(:)));
assert(all(V(:)==Vtrue(:)));
assert(all(Hmask(:)==masktrue(:)));
assert(all(Vmask(:)==masktrue(:)));