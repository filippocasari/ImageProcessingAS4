% ex2 second version
% now applying nearest neighbor approach



clear;
close all;
% read the image
queen = imread("queen.jpg", "jpg");
% convert it to Linearize gamma-corrected RGB values
queen = rgb2lin(queen);
% convert it to double
queen_double = im2double(queen);
% create a list of possible values
space_colors_list = linspace(0, 255, 4)/255;
index =1;
% 32 values (rgb)
space_colors = zeros(32, 3 );
% fill it up
for i=1:4
    for j=1:4
        for k=1:2:4
            space_colors(index, :)=[space_colors_list(i) space_colors_list(j) space_colors_list(k)];
            index = index +1;
        end
    end
end
size(space_colors)
disp(space_colors)
% quantization
queen_quantized =zeros(size(queen_double));

for i=1:size(queen_double, 1)
    for j=1:size(queen_double, 2)
        % for each pixel
        distance = 100; % distance arbitrarly set
        closest_index = 1; % index of the closest value to original pixel 
        % get color values
        r = queen_double(i, j, 1); 
        g = queen_double(i, j, 2);
        b = queen_double(i, j, 3);
        % now, for each combination
        for row=1:size(space_colors, 1)
            % compute distance
            d = (r-space_colors(row, 1))^2 + (g-space_colors(row, 2))^2 + (b-space_colors(row, 3))^2;
            d = sqrt(d);
            % compare with the shortest known one
            if(d<distance)
                distance = d;
                closest_index = row;
            end
        end
        % update the pixel value with the new one
        queen_quantized(i, j, :)= space_colors(closest_index, :);
            
        
    end
end
% displaying the queen and the quantized one
figure;
subplot(1,3,1);
imshow(lin2rgb(queen));
title("original");

queen_quantized_quantized = lin2rgb(queen_quantized);
size(queen_quantized)
subplot(1,3,2);
imshow(queen_quantized_quantized);
title("color quantization");
%saveas(fig_queen_quantised, "queen_quantized.jpg");


%saveas(fig_queen_grey, "fig_queen_grey.jpg");

% just check how many colors are present in the new one
RGBmat = reshape(queen_quantized,[],3); 

[RGBunq, ~, RGBgroup] = unique(RGBmat,'rows'); 
disp(["Unique colors in the new queen image: ", size(RGBunq,1)])
 %% create LUtables
LUT = java.util.Hashtable;
 for row=1:size(space_colors, 1)
    
    grey_value = (max(space_colors(row, :))+min(space_colors(row, :)))/2;

    key = space_colors(row, :);
    LUT.put(num2str(key), grey_value);
 end
disp("LUT: (columns: R, G, B, grey value)");
 
LUT
queen_grey = zeros(size(queen_quantized,1), size(queen_quantized, 2),1);
% get the new gray queen from the LUT
for i=1:size(queen_quantized, 1)
    for j=1:size(queen_quantized, 2)
        
        queen_grey(i, j, 1)= LUT.get(num2str(queen_quantized(i,j, :)));
    
    end
end
% plot it
subplot(1,3,3);
imshow(queen_grey);
title("grey scale");