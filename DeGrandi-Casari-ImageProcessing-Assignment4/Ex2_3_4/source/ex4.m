clear;
close all;

levels_laplace2 = 2;
levels_laplace1 = levels_laplace2;
sad = imread("sad.jpg", "jpg");

sad_double = im2gray(im2double(sad));

happy = imread("happy.jpg", "jpg");

happy_double = (im2double(happy));

[~,laplace1,~] = laplacian_pyramid( sad_double, 2, 1.5);
[reconstracted,~,h_freq] = laplacian_pyramid( happy_double, 4, 0.01);
laplace2 = imresize(h_freq{end},1);
laplace2 = imresize(rescale(laplace2),2);

if(size(laplace1, 1)>=size(laplace2, 1))
    difference_size_1 = size(laplace1, 1)-size(laplace2, 1)
    laplace2 = padarray(laplace2, [difference_size_1 0], 'post');
else
    difference_size_1 = -size(laplace1, 1)+size(laplace2, 1)
    laplace1 = padarray(laplace1, [difference_size_1 0], 'post');
end
if(size(laplace1, 2)>=size(laplace2, 2))
    difference_size_2 = size(laplace1, 2)-size(laplace2, 2)
    laplace2 = padarray(laplace2, [0 difference_size_2], 'post');

else
    difference_size_2 = -size(laplace1, 2)+size(laplace2, 2)
    laplace1 = padarray(laplace1, [0 difference_size_2], 'post');
end


size(laplace2)
size(laplace1)

figure;
subplot(1,3,1);
imshow(laplace1);
title("laplace 1 pyramid");
subplot(1,3,2);
imshow(laplace2);
title("laplace 2 pyramid");
subplot(1,3,3);

hybrid_image = rescale(laplace1+laplace2);
imshow(hybrid_image);
title("hybrid")


imshow(hybrid_image)



% sigma = 0.8;
% alpha = 0.5;
% low_pass_img = imgaussfilt(sad_double, sigma);
% high_pass_img = locallapfilt(happy,sigma,alpha);
% size(high_pass_img)
% size(low_pass_img)
% high_pass_img = im2double(high_pass_img);
% difference_size = size(low_pass_img, 1)-size(high_pass_img, 1);
% high_pass_img=padarray(high_pass_img, [difference_size 0], 'pre');
% hybrid_image = rescale(low_pass_img+high_pass_img);
% hybrid_image = (hybrid_image - min(hybrid_image(:))) / (mareconstracted(hybrid_image(:)) - min(hybrid_image(:)));
% hybrid_image = histeq(hybrid_image);
%figure;
%imshow(hybrid_image);

