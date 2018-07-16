image = im2double(rgb2gray(imread('crooked_horizon.jpg')));
figure(1);
imagesc(image); title('original');

[x, y] = ginput(2);
hold on;
plot(x, y, 'r*');

rotationAngle = atan(tan((y(2) - y(1))/(x(2) - x(1)))) * (180/pi);

if x(1) == x(2)
    if y(1) == y(2)
        rotationAngle = 0;
    else
        rotationAngle = 90;
    end
end

rotatedImage = rotate_image(image, rotationAngle);
figure(2); imagesc(rotatedImage); title('Result');