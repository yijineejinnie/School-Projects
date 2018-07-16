%
% load results of reconstruction
%
load reconstruction


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% cleaning step 1: remove points outside known bounding box
%




%
% drop bad points from both 2D and 3D list
%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% cleaning step 2: remove triangles which have long edges
%

TRITHRESH = 10;   %10mm

tri = delaunay(xL(1,:), xL(2,:)).';

p1 = X(:, tri(1,:));
p2 = X(:, tri(2,:));
p3 = X(:, tri(3,:));

d1 = TRITHRESH > sum((p1-p2).^2, 1).^0.5;
d2 = TRITHRESH > sum((p1-p3).^2, 1).^0.5;
d3 = TRITHRESH > sum((p2-p3).^2, 1).^0.5;

tri = tri(:,d1 & d2 & d3).';



%
% remove unreferenced points which don't appear in any triangle
%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% display results
%
figure(1); clf;
h = trisurf(tri,X(1,:),X(2,:),X(3,:));
set(h,'edgecolor','none')
set(gca,'projection','perspective')
axis image; axis vis3d;

% rotate the view around so we see from
% the front  (can also do this with the mouse in the gui)
camorbit(45,0);
camorbit(0,-120);
camroll(-8);




%
% MATLAB has other interesting options to control the
% rendering of the mesh... see e.g.
%
lighting flat;
shading interp;
%material shiny;
%camlight headlight;
%
%
