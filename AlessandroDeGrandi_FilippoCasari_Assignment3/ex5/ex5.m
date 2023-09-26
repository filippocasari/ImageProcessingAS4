close all;
clear;

x = -5:0.1:5;

mu = 0;
sigma = 0.5;
gaussian = exp(-(x - mu).^2 / (2*sigma^2));
rectangular = (x >= -1) & (x <= 1)
result = gaussian .* rectangular;

gaussianfft= abs(fftshift(fft(gaussian)));
rectangularfft= abs(fftshift(fft(rectangular)));
resultfft= abs(fftshift(fft(result)));

figure('Name', 'Gaussian');
plot(x, gaussian);
figure('Name', 'Box');
plot(x, rectangular);
figure('Name', 'GaussianBox');
plot(x, result);
figure('Name', 'fftGaussian');
plot(x, gaussianfft);
figure('Name', 'fftBox');
plot(x, rectangularfft);
figure('Name', 'fftGaussianBox');
plot(x, resultfft);

grid on;

image = imread("meme.jpeg");
image = rgb2gray(image);
image = imresize(image,[1024,1024])

size(image)
sz=size(image,1)
sigma=25
kernelSizeCorrect=4*sigma+1
kernelSizeSmall=ceil(sigma/2)

gaussianCorrect = fspecial('gaussian',kernelSizeCorrect,sigma);
gaussianSmall = fspecial('gaussian',kernelSizeSmall,sigma);
%gaussianCorrect=gaussianCorrect.*max(max(gaussianCorrect))
%gaussianSmall=gaussianSmall.*max(max(gaussianSmall))

gaussianCorrectFFT=abs((fftshift(fft2(gaussianCorrect,sz,sz))));
gaussianSmallFFT=abs((fftshift(fft2(gaussianSmall,sz,sz))));

filteredImageCorrect = conv2(image, gaussianCorrect, 'same');
filteredImageSmall = conv2(image, gaussianSmall, 'same');

filteredImageCorrectFFT = real(ifft2(ifftshift(fftshift(fft2(image)) .* gaussianCorrectFFT)));
filteredImageSmallFFT = real(ifft2(ifftshift(fftshift(fft2(image)) .* gaussianSmallFFT)));

filteredBox = imboxfilt(image,kernelSizeSmall);

figure('Name', 'CorrectKernel');
imshow(gaussianCorrect,[]);
figure('Name', 'WrongKernel');
imshow(gaussianSmall,[]);

figure('Name', 'CorrectKernelFFT');
imshow(gaussianCorrectFFT);
figure('Name', 'WrongKernelFFT');
imshow(gaussianSmallFFT);
figure('Name', 'original');
imshow(image);
figure('Name', 'Correct');
imshow(filteredImageCorrect,[]);
figure('Name', 'Wrong');
imshow(filteredImageSmall,[]);
figure('Name', 'CorrectFFT');
imshow(filteredImageCorrectFFT,[]);
figure('Name', 'WrongFFT');
imshow(filteredImageSmallFFT,[]);
figure('Name', 'box');
imshow(filteredBox,[]);



