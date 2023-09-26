%I used this formula https://openclipart.org/detail/332119/reverse-srgb-transformation
close all;
clear;

%seed
rng(420);

image = imread("Van_Gogh_Starry_Night_wikipedia.jpeg");
%image = imread("queen.jpg")
image = im2double(image);

figure("Name", "Queeeen")
imshow(image)

image_linear = applyInversesRGB(image);

figure("Name", "LinearQueeeen")
imshow(image_linear)

image_lab = rgb2lab(image_linear);
figure("Name", "LabQueeeen")
imshow(image_lab)

%decomposeImage(image,'sRGB',false)

%decomposeImage(image_linear,'linear_RGB',false)

%decomposeImage(image_linear,'linear_RGB',false)

decomposeImage(image,'lab',true)


function decomposeImage(im,nameString,labflag)
    if labflag==true
        im=rgb2lab(im);
    end
    
    numClusters=7;
    imageData = reshape(im, [], 3);
    [clusterIndices, clusterCenters] = kmeans(imageData, numClusters);
    %clusterIndices
    clusterCenters
    colorPalletette = reshape(clusterCenters,[1,numClusters,3]);
    
    figure("Name", "Palletette")
    imshow(colorPalletette);
    
    % Assign each pixel to its corresponding centroid
    clusteredPixels = clusterCenters(clusterIndices, :);
    
    figure("Name", 'God Decompose the queeen');
    set(gcf, 'Units', 'Normalized', 'Position', [0, 0, 1, 1]);
    
    sum = zeros(size(im));
    
    for i=1:size(clusterCenters)
       
        mask = clusterIndices == i;
    
    
        decomposition_cluster = clusteredPixels .* mask;
        decomposition_cluster = reshape(decomposition_cluster, size(im));
    
        mask2D = reshape(mask, size(im,1),size(im,2));
        decomposition = im .* mask2D;
        
        %MODIFY LAYERS
        if labflag==true
            
            %luminosity
            %decomposition(:,:,1)=decomposition(:,:,1).*(0.7+i/10);
            
            %QUEEN LIPSTICK
            %if i==3
            %    decomposition(:,:,1)=decomposition(:,:,1).*2;
            %end

            
            %STARRY DAWN
            if i==1|| i==3
                decomposition(:,:,1)=decomposition(:,:,1).*1.5;
                %chromatic a* = green (-a*) to red (+a*)
                decomposition(:,:,2)=decomposition(:,:,1)+5;
                %chromatic b* = blue (-b*) to yellow (+b*)
                decomposition(:,:,3)=decomposition(:,:,1)+10;
            end

        end
        

        sum=sum+decomposition;
        
        
        palletette = ones(size(im));
        palletette(:,:,1) = palletette(:,:,1).*clusterCenters(i,1);
        palletette(:,:,2) = palletette(:,:,2).*clusterCenters(i,2);
        palletette(:,:,3) = palletette(:,:,3).*clusterCenters(i,3);
        
        if labflag==true
            %modify first layer
            

            palletette = lab2rgb(palletette);
            decomposition_cluster = lab2rgb(decomposition_cluster);
            decomposition = lab2rgb(decomposition);
        end

        
        
        %figure("Name", ['Palletette',' ',num2str(i)]);
        subplot(3,numClusters,i)
        %palletette = rgb2hsv(palletette);
        imshow(palletette);
        %title(['Palletette',' ',num2str(i)])
        %figure("Name", ['Decompose',' ',num2str(i)]);
        subplot(3, numClusters, i+numClusters);
        %decomposition_cluster=rgb2hsv(decomposition_cluster);
        imshow(decomposition_cluster);
        %title(['Decomposition',' ',num2str(i)])
        subplot(3, numClusters, i+2*numClusters);
        %decomposition = rgb2hsv(decomposition);
        imshow(decomposition);
    end
    
    
    
    % Reshape the clustered pixels back into original image shape
    clusteredImage = reshape(clusteredPixels, size(im));

    if labflag==true
        clusteredImage=lab2rgb(clusteredImage);
        sum=lab2rgb(sum);
    end
    
    % cluster assigned image
    figure("Name", ['ClusterQueeeen',' ',nameString])
    imshow(clusteredImage);
    
    % sum of layers
    figure("Name", ['SumOfDecomp',' ',nameString])
    imshow(sum,[]);
end


function linearRGB = applyInversesRGB(sRGB)
    %linearRGB = zeros(size(sRGB));
    mask_dark = sRGB <= 0.04045;
    mask_light = sRGB > 0.04045;
    
    % Linear transformation for dark values
    linearRGB_dark = sRGB.* mask_dark ./ 12.92;
    
    % Inverse gamma correction for bright values
    linearRGB_light = ((sRGB.*mask_light + 0.055) / 1.055).^2.4;

    linearRGB = linearRGB_light + linearRGB_dark;
end



