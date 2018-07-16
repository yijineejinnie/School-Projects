%
% load results of reconstruction
%
scandir = 'manny/';
%load ('manny/grab_0scandata.mat');
%load ('manny/grab_1scandata.mat');
%load ('manny/grab_2scandata.mat');
%load ('manny/grab_3scandata.mat');
load ('manny/grab_4scandata.mat');

%
%cleaning step 1: remove points whose neighbors are far away
%
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