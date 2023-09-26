% just trying gassian pyramid
clear;
levels =3;

happy = imread("sad.jpg", "jpg");

happy_double = im2double(happy);
%out_image= gaussian_pyramid(happy_double, 2);
figure;
subplot(1,3,1);
imshow(happy_double);
title("original");
image_after_gassian = gaussian_pyramid(happy_double, levels);
subplot(1,3,2);
imshow(image_after_gassian);
title("my gaussian");
subplot(1,3,3);
gauss =genPyr( happy_double, 'gauss', levels );
imshow(gauss{levels});
title("external library");
%figure;
%disp(["size image after laplacian: ", size(L_total)]);
size(happy_double)
size(image_after_gassian)
size(gauss{levels})