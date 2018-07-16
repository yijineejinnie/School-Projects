
load ('calibrationSession.mat');
load ('stereoParams.mat');

thresh = 0.0001;
scandir = 'manny/';

camR.f = mean(stereoParams.CameraParameters1.FocalLength);
camL.f = mean(stereoParams.CameraParameters2.FocalLength);

camR.c = stereoParams.CameraParameters1.PrincipalPoint;
camL.c = stereoParams.CameraParameters2.PrincipalPoint;

camR.R = stereoParams.CameraParameters1.RotationMatrices(:,:,1);
camL.R = stereoParams.CameraParameters2.RotationMatrices(:,:,1);

camR.t = -camR.R * stereoParams.CameraParameters1.TranslationVectors(1,:)';
camL.t = -camL.R * stereoParams.CameraParameters2.TranslationVectors(1,:)';


for i = 0:4
    dir = strcat('manny/grab_', int2str(i));
    [R_h,R_h_good] = decode([dir '/frame_C0_'],0,19,thresh);
    [R_v,R_v_good] = decode([dir '/frame_C0_'],20,39,thresh);
    [L_h,L_h_good] = decode([dir '/frame_C1_'],0,19,thresh);
    [L_v,L_v_good] = decode([dir '/frame_C1_'],20,39,thresh);



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
