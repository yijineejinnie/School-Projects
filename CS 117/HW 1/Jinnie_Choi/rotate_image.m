function Irot = rotate_image(I,angle)
 % 
 %   This function takes an image I and creates a new version of the image
 %   which is rotated by amount angle
 %
 % arguments:
 %
 %   I - the original grayscale image, stored as a matrix
 %   angle - the amount by which to rotate the image counter-clockwise, in degrees
 %
 % return value:
 %   
 %   Irot - an image which containing the rotated original
 %
 
 [h, w] = size(I);
 
 if mod(w, 2) == 0
     rangeX = -w/2:(w/2 - 1);
 else
     rangeX = ceil(-w/2):floor(w/2);
 end
 
 if mod(h, 2) == 0
     rangeY = -h/2:(h/2 - 1);
 else
     rangeY = ceil(-h/2):floor(h/2);
 end
 
 [x, y] = meshgrid(rangeX, rangeY);
 
 rowI = I(:)';
 rotationX = rotate([x(:) y(:)]', -angle);

 minX = round(min(rotationX'));
 minY = round(min(rotationX'));
 maxX = round(max(rotationX'));
 maxY = round(max(rotationX'));
 
 [newX, newY] = meshgrid(minX:maxX, minY:maxY);
 
 Irot = griddata(rotationX(1, :), rotationX(2, :), rowI, newX(:), newY(:));
 Irot = reshape(Irot, size(newX)); 
 
end