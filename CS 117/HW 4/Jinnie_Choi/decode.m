
function [C,goodpixels] = decode(imageprefix,start,stop,threshold)

% function [C,goodpixels] = decode(imageprefix,start,stop,threshold)
%
%
% Input:
%
% imageprefix : a string which is the prefix common to all the images.
%
%                  for example, pass in the prefix '/home/fowlkes/left/left_'  
%
%                  to load the image sequence   '/home/fowlkes/left/left_01.png' 
%                                               '/home/fowlkes/left/left_02.png'
%                                               '/home/fowlkes/left/left_03.png'
%                                                          etc.
%
%  start : the first image # to load
%  stop  : the last image # to load
% 
%  threshold : the pixel brightness should vary more than this threshold between the positive
%             and negative images.  if the absolute difference doesn't exceed this value, the 
%             pixel is marked as undecodeable.
%
% Output:
%
%  C : an array containing the decoded values (0..1023)  for 10bit values
%
%  goodpixels : a binary image in which pixels that were decodedable across all images are marked with a 1.

% some error checking
if (stop<=start)
  error('stop frame number should be greater than start frame number');
end

goodpixels = [];
bit = 1;

for i = start:2:stop
  img1 = im2double(imread(strcat(imageprefix, sprintf('%02d',i), '.png')));
  img2 = im2double(imread(strcat(imageprefix, sprintf('%02d',i+1), '.png')));
  
  if (size(img1, 3) == 3)
    img1 = rgb2gray(img1);
    img2 = rgb2gray(img2);
  end

  goodimg(:, :, bit) = img1 > img2;
  
  if (isempty(goodpixels))
    goodpixels = ones(size(img1));
  end
  
  decodeimg = abs(img1 - img2) > threshold;
  goodpixels = goodpixels & decodeimg;

  % visualize as we walk through the images
  figure(1); clf;
  subplot(1,2,1); imagesc(goodimg(:,:,bit)); axis image; title(sprintf('bit %d',bit));
  subplot(1,2,2); imagesc(goodpixels); axis image; title('goodpixels');
  drawnow;

  bit = bit + 1;
end

% Convert from gray to bcd
% Remember that MSB is bit #1
goodimg2(:, :, 1) = goodimg(:, :, 1);

for i = 1:9
    goodimg2(:, :, i+1) = xor(goodimg2(:, :, i), goodimg(:, :, i+1)); 
end

% Convert from BCD to standard decimal
C = zeros(size(goodimg2(:, :, 1)));

temp = 9;

for j = 1:10
    goodimg3(:, :, j) = goodimg2(:, :, j) .* (2.^temp);
    C = C + goodimg3(:, :, j);
    temp = temp - 1;
end

% visualize final result
figure(1); clf;
subplot(1,2,1); imagesc(C.*goodpixels); axis image; title('decoded');
subplot(1,2,2); imagesc(goodpixels); axis image; title('goodpixels');
drawnow;

