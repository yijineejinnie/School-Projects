function Xrot = rotate(X,angle)
 % function Xrot = rotate(X,angle)
 % 
 %   This function takes a set of points stored in X and
 %   applies a rotation specified by angle.
 %   
 % arguments: 
 %
 %   X :  a 2xN matrix of points where the first row gives the x coordinate
 %        of each point and the second row gives the y coordinate of each point
 %
 %   angle : the amount to rotate counter-clockwise, in degrees
 %
 %
 % return value:
 %  
 %  Xrot : a 2xN matrix containing the rotated points.
 %   
 
 degToRad = (angle/180) * pi;
 
 rotationMatrix = [cos(degToRad)  -sin(degToRad);
                   sin(degToRad)   cos(degToRad)];
 
 Xrot = rotationMatrix * X;
 
end