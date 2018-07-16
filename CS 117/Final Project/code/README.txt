1. decode.m
    reads in a set of images captured with the camera showing the projected
    gray code and returns an array which is the same size as the camera
    image where each element contains the decode value (0..1023) as well as
    a binary image (mask) indicating which pixels could be reliably decoded.

2. reconstruct.m
    takes a set of images from the pair of cameras and produces the 3D
    coordinates.

3. triangulate.m
    takes points and left and right images, and left and right camera
    parameters, and then produces 3D coordinate of points in world
    coordinates

4. mesh.m
    cleanups mesh by removing bad triangle and vertices and creates mesh
    and converts to .ply file.

5. nbr_error.m
    triangulate the set of points based on their 2D locations x
    and then for each point, compute an error based on the 
    distance between the point in 3D and the median location 
    of its neighbors 

6. tri_error.m
    triangulate the 2D pointset x and compute an "error" 
    for each triangle which is the maximum of the 3 edge
    lengths for that triangle based on the 3D point locations
    X.

7. nbr_smooth.m
    smooth the 3D locations of points in a given mesh by moving
    each point to the mean location of its neighbors