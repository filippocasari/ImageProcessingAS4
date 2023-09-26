close all;
clear;
showImages=true;

imageSize = 1024;
originalImage = ones(imageSize, imageSize) * 0.75;
squareSize = imageSize / 2;

squareX = (imageSize - squareSize) / 2;
squareY = (imageSize - squareSize) / 2;
originalImage(squareX : squareX + squareSize, squareY : squareY + squareSize) = 0;
figure('Name', 'Original');
imshow(originalImage);

filteringSpaceAndFreq(originalImage,10,true)

sigmas = 1:20;
t_spaces = zeros(size(sigmas));
t_freqs1 = zeros(size(sigmas));
t_freqs2 = zeros(size(sigmas));
size(t_spaces)

for i = 1:length(sigmas)
    [t_space,t_freq1,t_freq2] = filteringSpaceAndFreq(originalImage,i,false);
    
    t_spaces(i)=t_space;
    t_freqs1(i)=t_freq1;
    t_freqs2(i)=t_freq2;
end

figure();
plot(sigmas, t_spaces, 'b-', 'LineWidth', 2);
hold on;
plot(sigmas, t_freqs1, 'r--', 'LineWidth', 2);
hold on;
plot(sigmas, t_freqs2, 'g--', 'LineWidth', 2);
xlabel('\sigma_s', 'FontSize', 12);
ylabel('Execution time (s)', 'FontSize', 12);
legend('Spatial Domain', 'Frequency Domain 1','Frequency Domain 2');
title('Execution Time vs. \sigma_s', 'FontSize', 14);


function [t_space,t_freq1,t_freq2] = filteringSpaceAndFreq(originalImage,sigmaS,showImages)
    
    tic
    %Gaussian Filtering in Space Domain
    %sigmaS = 3
    kernelSize = ceil(4 * sigmaS) + 1
    gaussianKernelS = fspecial('gaussian', kernelSize, sigmaS);
    filteredImageS = conv2(originalImage, gaussianKernelS, 'full');
    t_space=toc
    
    %pad image so that .* uses same image as conv2 'full'
    originalImage = padarray(originalImage, [floor(kernelSize/2), floor(kernelSize/2)], 0, 'both');
    imageSize = size(originalImage,1);
    
    tic
    %Gaussian Filtering in Frequency Domain
    gaussianKernelF = fspecial('gaussian', kernelSize, sigmaS);
    gaussianKernelFFT=fftshift(fft2(gaussianKernelF, imageSize, imageSize));
    magnitude_kernel = abs(gaussianKernelFFT);
    
    fftImage = fftshift(fft2(originalImage));
    filteredImageF = real(ifft2(ifftshift(fftImage .* magnitude_kernel)));
    t_freq1=toc
    
    tic
    %Prove equivalence
    sigmaF = imageSize / (2 * sigmaS * pi)
    gaussianKernelF_test = fspecial('gaussian',imageSize,sigmaF);
    gaussianKernelF_test=gaussianKernelF_test./max(max(gaussianKernelF_test)); %normalize
    %gaussianKernelF_test = mat2gray(gaussianKernelF_test);
    filteredImageF_test = real(ifft2(ifftshift(fftImage .* gaussianKernelF_test)));
    t_freq2=toc
    
    % Calculate differences
    differences = abs(filteredImageS - filteredImageF) + abs(filteredImageS - filteredImageF_test);
    
    if showImages==true
        figure('Name', 'kernelF');
        imshow(gaussianKernelF, []);
        figure('Name', 'kernelS');
        imshow(gaussianKernelS, []);
        figure('Name', 'kernelFFT');
        imshow(gaussianKernelFFT,[]);
        figure('Name', 'kernelF_test');
        imshow(gaussianKernelF_test,[]);
        figure('Name', 'magnitudekernelFFT');
        imshow(magnitude_kernel, []);
        figure('Name', 'kernelsdiff');
        imshow(magnitude_kernel-gaussianKernelF_test);
        
        figure('Name', 'OriginalPadded');
        imshow(originalImage);
        figure('Name', 'fft');
        imshow(fftImage);
        figure('Name', 'filteredS');
        imshow(filteredImageS);
        figure('Name', 'filteredF');
        imshow(filteredImageF);
        figure('Name', 'filteredF_test');
        imshow(filteredImageF_test);
        figure('Name', 'difference');
        imshow(differences);
    end
   
    mse = mean(differences(:).^2, 'all')
        
end
