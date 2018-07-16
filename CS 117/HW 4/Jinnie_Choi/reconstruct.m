%
% load in calibration data
%

load scan0/scan0_calibration.mat 

thresh = 0.02;
scandir = 'scan0/';

[L_h,L_h_good] = decode([scandir 'frame_C1_'],0,19,thresh);
[L_v,L_v_good] = decode([scandir 'frame_C1_'],20,39,thresh);
[R_h,R_h_good] = decode([scandir 'frame_C0_'],0,19,thresh);
[R_v,R_v_good] = decode([scandir 'frame_C0_'],20,39,thresh);

%
% visualize the masked out horizontal and vertical
% codes for left and right camera
%
figure(1); clf;
subplot(2,2,1); imagesc(R_h.*R_h_good); axis image; axis off;title('right camera,h coord');
subplot(2,2,2); imagesc(R_v.*R_v_good); axis image; axis off;title('right camera,v coord');
subplot(2,2,3); imagesc(L_h.*L_h_good); axis image; axis off;title('left camera,h coord');  
subplot(2,2,4); imagesc(L_v.*L_v_good); axis image; axis off;title('left camera,v coord');  
colormap jet

%
% combine horizontal and vertical codes
% into a single code and a single mask.
%

R_C = R_h + R_v * 1024;
L_C = L_h + L_v * 1024;
R_good = R_h_good & R_v_good;
L_good = L_h_good & R_v_good;

R_sub = find(R_good);
L_sub = find(L_good);
R_C_good = R_C(R_sub);
L_C_good = L_C(L_sub);


%intersect the codes of good pixels in the left and right image to find matches
[matched,iR,iL] = intersect(R_C_good,L_C_good); 

R_sub_matched = R_sub(iR);
L_sub_matched = L_sub(iL);

[xx,yy] = meshgrid(1:1920,1:1200);
xR(1,:) = xx(R_sub_matched);
xR(2,:) = yy(R_sub_matched); 
xL(1,:) = xx(L_sub_matched); 
xL(2,:) = yy(L_sub_matched);

%
% now triangulate the matching pixels using the calibrated cameras
%
X = triangulate(xL,xR,camL,camR);




%
% visualize results
%


% plot 2D overhead view
clf; plot(X(1,:),X(3,:),'.');
axis image; axis vis3d; grid on;
hold on;
plot(camL.t(1),camL.t(3),'ro')
plot(camR.t(1),camR.t(3),'ro')
xlabel('X-axis');
ylabel('Z-axis');


% plot 3D view
clf; plot3(X(1,:),X(2,:),X(3,:),'.');
axis image; axis vis3d; grid on;
hold on;
plot3(camL.t(1),camL.t(2),camL.t(3),'ro')
plot3(camR.t(1),camR.t(2),camR.t(3),'ro')
axis([-200 400 -200 300 -200 200])
set(gca,'projection','perspective')
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');


%
% save the results of all our hard work
%
save('reconstruction.mat','X','xL','xR','camL','camR','Lmask','Rmask');


