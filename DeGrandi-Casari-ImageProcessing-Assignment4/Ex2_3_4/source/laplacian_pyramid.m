function [image_recontracted, resized_image, high_frequencies] = laplacian_pyramid(input_image, layers, sigma)
    high_frequencies={};
    if(layers==1)
        image_recontracted=input_image;
        resized_image=input_image;
        
        return
    end
    new_image = input_image;
    old_image = input_image;
    difference_1 =0;
    difference_2 =0;
    laplacians ={};
        for i=1:layers
            disp(["iteration number (layer)", i]);
            disp("before padding");
            disp(size(old_image));
            log_of_2_image = log2(size(old_image, 1));
            if(isinteger(log_of_2_image)==0 && i==1)
                disp("padding first dim");
                

                exponent = ceil(log_of_2_image)
                power_of_2 = pow2(exponent)
                difference_1 = power_of_2-size(old_image, 1)
                old_image = padarray(old_image, [difference_1 0], 'pre');
            end
            log_of_2_image = log2(size(old_image, 2));
            if(isinteger(log_of_2_image) ==0 && i==1)
                disp("padding second dim");
                
                exponent = ceil(log_of_2_image)
                power_of_2 = pow2(exponent)
                difference_2 = power_of_2-size(old_image, 2)
                old_image = padarray(old_image, [0 difference_2], 'pre');
            end
            if(i==layers)
                new_image = imgaussfilt(old_image, sigma);
                L = new_image;
                laplacians{i}=L;
                start_r = size(input_image, 1)/pow2(layers-1);
                start_c = size(input_image, 2)/pow2(layers-1);
                resized_image = L(size(L, 1)-start_r+1:end, size(L, 2)-start_c+1:end, :);
                %high_frequency = high_frequency(size(high_frequency, 1)-start_r+1:end, size(high_frequency, 2)-start_c+1:end, :);
                break;
            end
            
            disp("after padding");
            size(old_image)
            new_image = imgaussfilt(old_image, sigma);
            disp("after gaussian filtering");
            size(new_image)
            new_image = imresize(new_image, 0.5);
            disp("downsample");
            size(new_image)
            expanded_new_image = imresize(new_image, 2);
            disp("expansion");
            size(expanded_new_image)
            L = old_image - expanded_new_image;
            high_frequency = L(difference_1/(2^(i-1))+1:end, difference_2/(2^(i-1))+1:end, :);
            old_image = new_image;
            high_frequencies{i}=high_frequency;
            laplacians{i} =L;
            %figure;
            %imshow(L);
            
        end
        image_recontracted = laplacians{layers};
        disp("iter recostruction: ");
        disp(layers)
        for i=layers-1:-1:1
            disp("iter recostruction: ");
            i
            disp("size laplacian");
            disp(size(image_recontracted));
            image_recontracted = imresize(image_recontracted, 2);
            disp("size laplacian expanded");
            disp(size(image_recontracted));
            disp("size previous layer");
            disp(size(laplacians{i}));
            image_recontracted = image_recontracted+laplacians{i};

        end
        h = size(input_image, 1);
        l = size(input_image, 2);
        h_l = size(image_recontracted, 1);
        l_l = size(image_recontracted, 2);
        image_recontracted =image_recontracted(h_l-h+1:end, l_l-l+1:end, :);
end