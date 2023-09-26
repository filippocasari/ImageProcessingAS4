%close all;
%clear;



%vangogh = imread("Van_Gogh_Starry_Night_wikipedia.jpeg");
%vangoghDAWN = imread("StarryDawnSUM.png");
%inputstyle = imread("mosaic1.jpg");
%mosaic = imread("mosaic2.png");

%inputImage = imread("lugano2.jpg");

%inputImage = imread("lugano3.jpg");
%figure
%imshow(inputImage)
%for nclusters=10:20
%nclusters=32
%filter(inputImage,vangogh,nclusters,true,true);
%filter(inputImage,vangogh,nclusters,false,true);
%end
%filter(inputImage,vangogh,false,false);
%filter(inputImage,vangogh,true,false);
%filter(inputImage,vangogh,false,true);
%filter(inputImage,vangoghDAWN,true,true);
%filter(inputImage,vangoghDAWN,false,true);


%filter(vangogh,inputImage,false,true);
%filter(vangogh,inputImage,false,true);
%filter(inputImage,mosaic,true,true);
%filter(inputImage,mosaic,false,true);
%filter(inputImage,mosaic,false,false);
%newstyle=filter(vangogh,mosaic,false,false);
%filter(inputImage,newstyle,true,true);



function ex6Bonus(inputImage)
    rng(1234)
    nclusters=32
    vangogh = imread("Van_Gogh_Starry_Night_wikipedia.jpeg");
    filter(inputImage,vangogh,nclusters,true,true);
end


function result = filter(inputImage,inputstyle,numClusters,filter,crop)
    inputstyle = double(inputstyle)./255;
    style = rgb2gray(inputstyle);
   
    
    %filter=true
    if filter==true
        %get style high freqs
        sigma =0.5;
        stylefiltered = imgaussfilt(style, sigma);
        style = style -  stylefiltered;
        %style = imgaussfilt(style, sigma);
        style = imbinarize(style,0.01);
        %size(style)
        figure
        imshow(style)
    end
    
    %crop=true;
    if crop==true
        imageSize = size(inputstyle);
        %center crop
        cropSize=800;
        startX = floor((imageSize(2) - cropSize) / 2) + 1;
        startY = floor((imageSize(1) - cropSize) / 2) + 1;
        
        % Perform the center crop using imcrop
        
        style = imcrop(style, [startX, startY, cropSize-1, cropSize-1]);
        %figure
        %imshow(style)
    end
    
    %fixedSize = [1024, 1024];
    fixedSize = size(inputImage,1:2);
    style = imresize(style, fixedSize);
    
    
    newImage=double(inputImage)./255;
    newImage = imresize(newImage, fixedSize);
    
    newImage(:,:,1) = newImage(:,:,1)+double(style).*0.2;
    newImage(:,:,2) = newImage(:,:,2)+double(style).*0.2;
    newImage(:,:,3) = newImage(:,:,3)+double(style).*0.2;
    
    %fixedSize = [1024, 1024];
    newImage = imresize(newImage, fixedSize);
    newImage=rescale(newImage);
    %figure
    %imshow(newImage,[])
    
    
    image_lab = rgb2lab(newImage);
    image_lab(:,:,1)=image_lab(:,:,1).*1.3;
    result = rescale(lab2rgb(image_lab));
    
    figure
    imshow(result)

    colorTransfer(result,inputstyle,numClusters)
    
end


function colorTransfer(image,style,numClusters)
    
    image = rgb2lab(image);
    style = rgb2lab(style);
    
    %numClusters=50;

    %cluster Image
    %imageData = reshape(image, [], 3);
    %[clusterIndices, clusterCenters] = kmeans(imageData, numClusters);
    
    
    %clusterStyle
    styleData = reshape(style, [], 3);
    [clusterIndicesStyle, clusterCentersStyle] = kmeans(styleData, numClusters);
    
    
       
    %FIRST METHOD
    %clusteredPixels = clusterCentersStyle(clusterIndices, :);
    %clusteredImage = reshape(clusteredPixels, size(image));
    %clusteredImage=lab2rgb(clusteredImage);
    % cluster assigned image
    %figure("Name", 'colortransfer1')
    %imshow(clusteredImage);

    %color transfer2
    for i=1:size(image, 1)
        for j=1:size(image, 2)
            distance = 100;
            closest_index = 1;
            r = image(i, j, 1);
            g = image(i, j, 2);
            b = image(i, j, 3);
            for row=1:size(clusterCentersStyle, 1)
                d = (r-clusterCentersStyle(row, 1))^2 + (g-clusterCentersStyle(row, 2))^2 + (b-clusterCentersStyle(row, 3))^2;
                d = sqrt(d);
                if(d<=distance)
                    distance = d;
                    closest_index = row;
                end
            end
            image(i, j, :)= clusterCentersStyle(closest_index, :);
               
        end
    end
     image = lab2rgb(image);
     % cluster assigned image
    figure("Name", 'colortransfer')
    imshow(image);
 
end











