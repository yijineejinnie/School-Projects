
function err = project_error(params,X,x,cx,cy)


% function [x] = project_error(params,X,x,cx,cy)
%
%
% Input:
%
% params : an 7x1 vector containing the camera parameters which we 
%   will optimize over.  this should include:
% 
%    f - the focal length 
%    thx,thy,thz - camera rotation around the x,y and z axis
%    tx,ty,tz - camera translation vector entries
%   
%    cx,cy - the camera center.  we will just assume this is the 
%      center of the image so we won't optimize over it  (it is not part of params)
%
% X: a 3xN matrix containing the point coordinates in 3D world coordinates (in physical units, e.g. cm)
%
% x: a 2xN matrix containing the point coordinates in the camera image (pixels)
%
% Output:
%
%  err : a 2xN matrix containing the difference between x and project(X,cam)
%
%

% unpack parameters and build up cam data structure needed by the project function
cam.f = params(1);

two = params(2);
three = params(3);
four = params(4);
five = params(5);
six = params(6);
seven = params(7);

Ry = [cos(three) 0 -sin(three);
      0 1 0;
      sin(three) 0 cos(three)];

Rz = [cos(four) -sin(four) 0;
      sin(four) cos(four) 0;
      0 0 1];
           
Rx = [1 0 0;
      0 cos(two) -sin(two);
      0 sin(two) cos(two)];
   
cam.R = Rx * Rz * Ry;
cam.t = [five; six; seven];
cam.c = [cy; cx];

% compute projection
xproject = project(X,cam);


% compute the vector of reprojection errors
err = x - xproject;

%lsqnonlin( @(params) project_error(params,Pworld,Pcam,cx,cy),paramsinit,[],[],opts);


