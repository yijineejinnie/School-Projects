% You must first calibrate the cameras using the Stereo Camera Calibrator
% app in Matlab. You will have to load the Camera 1 images and Camera 2
% images, and then set the square size as 27.75 mm and click on calibrate
% button in order to do so. Then save the calibration session as
% "calibrationSession.mat" and export the parameters as "stereoParam.mat"
% and save it.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start of reconstruct.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% load the camera calibration session and parameters.
%
load ('calibrationSession.mat');
load ('stereoParams.mat');

thresh = 0.0001;
scandir = 'manny/';

% define camR and camL parameters using the parameters obtains from
% calibration.
camR.f = mean(stereoParams.CameraParameters1.FocalLength);
camL.f = mean(stereoParams.CameraParameters2.FocalLength);

camR.c = stereoParams.CameraParameters1.PrincipalPoint;
camL.c = stereoParams.CameraParameters2.PrincipalPoint;

camR.R = stereoParams.CameraParameters1.RotationMatrices(:,:,1);
camL.R = stereoParams.CameraParameters2.RotationMatrices(:,:,1);

camR.t = -camR.R * stereoParams.CameraParameters1.TranslationVectors(1,:)';
camL.t = -camL.R * stereoParams.CameraParameters2.TranslationVectors(1,:)';

% iterate through all grab directories in order to obtain
% reconstruction results of all scans.
for i = 0:4
    dir = strcat('manny/grab_', int2str(i));
    
    % using decode.m, decode the images of left and right cameras.
    [R_h,R_h_good] = decode([dir '/frame_C0_'],0,19,thresh);
    [R_v,R_v_good] = decode([dir '/frame_C0_'],20,39,thresh);
    [L_h,L_h_good] = decode([dir '/frame_C1_'],0,19,thresh);
    [L_v,L_v_good] = decode([dir '/frame_C1_'],20,39,thresh);

    % read the color images and turn it into grayscale images
    % in order to create color_mask to mask out background.
    rgbR_bg = rgb2gray(imread([dir '/color_C0_00.png']));
    rgbR = rgb2gray(imread([dir '/color_C0_01.png']));

    color_maskR = abs(rgbR - rgbR_bg).^2 > thresh;

    rgbL_bg = rgb2gray(imread([dir '/color_C1_00.png']));
    rgbL = rgb2gray(imread([dir '/color_C1_01.png']));

    color_maskL = abs(rgbL - rgbL_bg).^2 > thresh;


    %
    % combine horizontal and vertical codes
    % into a single code and a single mask.
    %

    Rmask = color_maskR & R_h_good & R_v_good;
    R_code = R_h + 1024*R_v;
    Lmask = color_maskL & L_h_good & L_v_good;
    L_code = L_h + 1024*L_v;

    %
    % now find those pixels which had matching codes
    % and were visible in both the left and right images
    %
    % only consider good pixels
    Rsub = find(Rmask(:));
    Lsub = find(Lmask(:));

    % find matching pixels 
    [matched,iR,iL] = intersect(R_code(Rsub),L_code(Lsub));
    indR = Rsub(iR);
    indL = Lsub(iL);

    % indR,indL now contain the indices of the pixels whose 
    % code value matched

    % pull out the pixel coordinates of the matched pixels
    [h,w] = size(Rmask);
    [xx,yy] = meshgrid(1:w,1:h);
    xL = []; xR = [];
    xR(1,:) = xx(indR);
    xR(2,:) = yy(indR);
    xL(1,:) = xx(indL);
    xL(2,:) = yy(indL);
    
    % imread color images once again to save the RGB values into xColor
    rgbR = imread([dir '/color_C0_01.png']);
    rgbL = imread([dir '/color_C1_01.png']);

    rgbLR = rgbL(:,:,1);
    rgbLG = rgbL(:,:,2);
    rgbLB = rgbL(:,:,3);

    rgbRR = rgbR(:,:,1);
    rgbRG = rgbR(:,:,2);
    rgbRB = rgbR(:,:,3);

    xColorRR = rgbRR(indR);
    xColorLR = rgbLR(indL);
    xColorRG = rgbRG(indR);
    xColorLG = rgbLG(indL);
    xColorRB = rgbRB(indR);
    xColorLB = rgbLB(indL);

    xColor = zeros(3,size(xR,2));
    xColor(1,:) = (xColorRR + xColorLR) / 2;
    xColor(2,:) = (xColorRG + xColorLG) / 2;
    xColor(3,:) = (xColorRB + xColorLB) / 2;

    %
    % now triangulate the matching pixels using the calibrated cameras
    %
    X = triangulate(xL,xR,camL,camR);

    %{
    figure(2); clf;
    hold on;
    plot3(X(1,:),X(2,:),X(3,:),'.');
    %}

    %
    % save the results of all our hard work
    %
    save([dir 'scandata.mat'],'X','xColor','xL','xR','camL','camR','dir');


end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of reconstruct.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start of mesh.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% load results of reconstruction
%

%load ('manny/grab_0scandata.mat');
%load ('manny/grab_1scandata.mat');
%load ('manny/grab_2scandata.mat');
%load ('manny/grab_3scandata.mat');
load ('manny/grab_4scandata.mat');

%
%cleaning step 1: remove points whose neighbors are far away
%

scandir = 'manny/';
trithresh = 1;
nbrthresh = 0.25;

[tri,errR] = nbr_error(xR,X);
[tri,errL] = nbr_error(xL,X);

goodpoints = find((errR < nbrthresh) & (errL < nbrthresh));
fprintf('dropping %2.2f %% of points from scan\n',100*(1-(length(goodpoints)/size(X,2))));
X = X(:,goodpoints);
xR = xR(:,goodpoints);
xL = xL(:,goodpoints);
xColor = xColor(:,goodpoints);

%
% cleaning step 2: remove triangles which have long edges
%

[tri,err] = tri_error(xL,X);
subt = find(err < trithresh);
tri = tri(subt,:);

%
% cleaning step 3: simple smoothing
%
smooth = nbr_smooth(tri,X,3);

%
% save the result
%
%save([scandir 'mesh1.mat'],'X','xColor','xL','xR','camL','camR','scandir');
%save([scandir 'mesh2.mat'],'X','xColor','xL','xR','camL','camR','scandir');
%save([scandir 'mesh3.mat'],'X','xColor','xL','xR','camL','camR','scandir');
%save([scandir 'mesh4.mat'],'X','xColor','xL','xR','camL','camR','scandir');
save([scandir 'mesh5.mat'],'X','xColor','xL','xR','camL','camR','scandir');

%
% convert to .ply file
%
%mesh_2_ply(X, xColor, tri, 'manny/mesh1.ply');
%mesh_2_ply(X, xColor, tri, 'manny/mesh2.ply');
%mesh_2_ply(X, xColor, tri, 'manny/mesh3.ply');
%mesh_2_ply(X, xColor, tri, 'manny/mesh4.ply');
mesh_2_ply(X, xColor, tri, 'manny/mesh5.ply');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of mesh.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fprintf('please open Meshlab and load all 5 .ply files to complete Mesh Alignment');