function [new_image] = gaussian_pyramid(input_image, layers)
    new_image = input_image;
    
    for i=2:layers
        
        new_image = imgaussfilt(new_image, 2);
        disp(["size after gaussian filter: ", size(new_image)]);
        new_image = new_image(1:2:end,1:2:end,:);
        
    end
end