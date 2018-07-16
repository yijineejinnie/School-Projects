image = im2double(rgb2gray(imread('crooked_horizon.jpg')));
result = rotate_image(image, 45);

figure(1);
imagesc(image); 

newMap = contrast(image);
colormap(newMap);

figure(2);
imagesc(result); 

newMap = contrast(image);
colormap(newMap);

