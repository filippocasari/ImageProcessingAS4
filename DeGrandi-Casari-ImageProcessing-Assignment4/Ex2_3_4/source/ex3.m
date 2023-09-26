
clear;
levels =4;
%happy = imread("happy.jpg", "jpg");
happy = imread("sad.jpg", "jpg");
happy_double = im2double(happy);
%out_image= gaussian_pyramid(happy_double, 2);
figure;
subplot(1,3, 1);
imshow(happy_double);
title("original image");
[image_after_laplacian, resized_image, high_frequencies] = laplacian_pyramid(happy_double, levels, 0.3);
subplot(1,3, 2);

imshow(image_after_laplacian);
title("reconstracted image");
subplot(1,3, 3);

imshow(resized_image);
title(strcat("resized image factor: ", num2str(levels)));
%figure;
%disp(["size image after laplacian: ", size(L_total)]);
size(happy_double)
size(image_after_laplacian)
size(resized_image)
figure;
num_subplot=1;
if(levels>1)
    for i=1:levels-1
      if(levels==2)
          subplot(1,2,1)
          num_subplot=2;
      end
      if(levels==3)
          subplot(1,3,i);
          num_subplot=3;
      end
      if(levels==4)
          subplot(1,4,i);
          num_subplot=4;
      end
      high_frequency=high_frequencies{i};
      imshow(rescale(high_frequency));
      title(strcat("level", num2str(i)));
     end
end
subplot(1, num_subplot, num_subplot);
imshow(resized_image);
title(strcat("level", num2str(num_subplot)));

%saveas(fig_laplacian, "laplacian_sad", "jpg");