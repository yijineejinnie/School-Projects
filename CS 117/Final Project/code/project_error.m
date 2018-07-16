
function err = project_error(params,X,xL,cam)

%
% wrap our project function for the purposes of optimization
%  params contains the parameters of the camera we want to 
%  estimate.
%

cam.R = buildrotation(params(1),params(2),params(3));
cam.t = params(4:6)';


x = project(X,cam);
err = x-xL;