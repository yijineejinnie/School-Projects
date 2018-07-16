function [x] = project(X,cam);

% function [x] = project(X,cam)
%
% Carry out projection of 3D points into 2D given the camera parameters
% We assume that the camera with the given intrinsic parameters produces
% images by projecting onto a focal plane at distance cam.f along the 
% z-axis of the camera coordinate system.
%
% Our convention is that the camera starts out the origin (in world
% coordinates), pointing along the z-axis.  It is first rotated by 
% some matrix cam.R and then translated by the vector cam.t.
%
%
% Input:
%
%  X : a 3xN matrix containing the point coordinates in 3D world coordinates (meters)
%
%  intrinsic parameters:
%
%  cam.f : focal length (scalar)
%  cam.c : image center (principal point) [in pixels]  (2x1 vector)
%
%  extrinsic parameters:
%
%  cam.R : camera rotation matrix (3x3 matrix)
%  cam.t : camera translation matrix (3x1 vector)
%
%
% Output:
%
%  x : a 2xN matrix containing the point coordinates in the 2D image (pixels)
%



% 1. transform the points in the world to the camera coordinate frame
WP = X;
WP(end+1:4,:) = 1;
P = horzcat(inv(cam.R), (-inv(cam.R) * cam.t)) * WP;

% 2. check to see which points are in front of the camera and print
% a message to the console indicating how many points are in front 
% vs behind the camera... this can be useful for debugging later on.
front = find(P(3,:) >= 0);
behind = find(P(3,:) < 0);
fprintf('Points in front: %i\n', length(front))
fprintf('Points behind: %i\n', length(behind))


% 3. project the points down onto the image plane and scale by focal length
% 4. add in camera principal point offset to get pixel coordinates

projection = [ cam.f 0 cam.c(1);
      0 cam.f cam.c(2);
      0 0 1; ];
     
x = projection * P;
x = x(1:2,:) ./ x(3,:);


