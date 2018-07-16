function X = triangulate(xL,xR,camL,camR)

%
%  function X = triangulate(xL,xR,camL,camR)
%
%  INPUT:
%   
%   xL,xR : points in left and right images  (2xN arrays)
%   camL,camR : left and right camera parameters
%
%
%  OUTPUT:
%
%    X : 3D coordinate of points in world coordinates (3xN array)
%
%


% 1. convert xL and xR from pixel coordinates back into meters with unit focal 
% length by subtracting off principal point and dividing through by 
% focal length...  call the results qR and qL.

PPR = [ camR.c(1); camR.c(2) ];
qR = xR(1:2,:) - PPR;
qR = qR(1:2,:) ./ camR.f;

PPL = [ camL.c(1); camL.c(2) ];
qL = xL(1:2,:) - PPL;
qL = qL(1:2,:) ./ camL.f;

% 2. make the right camera the origin of the world coordinate system by 
% transforming both cameras appropriately in order to find the rotation
% and translation (R,t) relating the two cameras

rotR = camR.R;
transR = camR.t;

relRot = inv(camR.R) * camL.R;
relTrans = inv(camR.R) * (camL.t - camR.t)


% 3. Loop over each pair of corresponding points qL,qR and 
% solve the equation:  
%
%   Z_R * qR = Z_L * R * qL + t
%
% for the depth values Z_R and Z_L using least squares.
%
qR(end+1:3,:) = 1;
qL(end+1:3,:) = 1;

Z = [];

for i = 1:1000
    a = qR(1:3,i);
    b = -relRot * qL(1:3,i);
    A = [ a b ];
    z = A\relTrans;
    Z = [ Z z ];
end

% 4. use Z_R to compute the 3D coordinates XR = (X_R,Y_R,Z_R) in right camera
% reference frame

XR = [];
for i = 1:1000
    p = Z(1,i) * qR(1:3,i);
    XR = [ XR p ];
end


% 5. since the right camera wasn't at the origin, map XR back to world coordinates 
% X using the right camera transformation parameters.

X = rotR * XR(1:3,:) + transR;