% ex2 second version
% now applying nearest neighbor approach



clear;
queen = imread("queen.jpg", "jpg");

queen_double = im2double(queen);
queen_feature_vector = reshape(queen_double, [], 3);
size(queen_feature_vector)
[idx,C] = kmeans(queen_feature_vector,32);
disp("centroids :");
C
queen_quantized =zeros(size(queen_double));
for i=1:size(queen_double, 1)
    for j=1:size(queen_double, 2)
        distance = 10;
        closest_index = 1;
        r = queen_double(i, j, 1);
        g = queen_double(i, j, 2);
        b = queen_double(i, j, 3);
        for row=1:size(C, 1)
            d = (r-C(row, 1))^2 + (g-C(row, 2))^2 + (b-C(row, 3))^2;
            d = sqrt(d);
            if(d<=distance)
                distance = d;
                closest_index = row;
            end
        end
        queen_quantized(i, j, :)= C(closest_index, :);
            
        
    end
end
figure;
subplot(1,3,1);
imshow(queen);
title("original");
subplot(1,3,2);
imshow(queen_quantized);
title("color quantization");
%saveas(fig_queen_quantised, "queen_quantized_KMEANS.jpg");

 %% create tables
 LUT = java.util.Hashtable;
 for row=1:size(C, 1)
    %r = C(row, 1);
    %g = C(row, 2);
    %b= C(row, 3);
    grey_value = (max(C(row, :))+min(C(row, :)))/2;

    key = C(row, :);
    LUT.put(num2str(key), grey_value);
 end
disp("LUT: (columns: R, G, B, grey value)");
 
C(1:3, :)
values =LUT.get(num2str(C(1, :)))
values =LUT.get(num2str(C(2, :)))
values =LUT.get(num2str(C(3, :)))




queen_grey = zeros(size(queen_quantized,1), size(queen_quantized, 2),1);
for i=1:size(queen_quantized, 1)
    for j=1:size(queen_quantized, 2)
        
        queen_grey(i, j, 1)= LUT.get(num2str(queen_quantized(i,j, :)));
    
    end
end
subplot(1,3,3);
imshow(queen_grey);
title("grey scale");
%saveas(fig_queen_grey, "fig_queen_grey_Kmeans.jpg");
RGBmat = reshape(queen_quantized,[],3); 

[RGBunq, ~, RGBgroup] = unique(RGBmat,'rows'); 
disp("unique colors: ");
nRGB = size(RGBunq,1)


