%NOTCH FILTERING

image = imread("san_domenico.png");


[m, n] = size(image);


center_x = floor(m / 2) + 1;
center_y = floor(n / 2) + 1;

side_length = 35; 
circle_radius = 15; 

%corners of square to draw circles around
top_left_corner = [center_x-side_length,center_y-side_length];
top_right_corner = [center_x+side_length,center_y+side_length];
bottom_left_corner = [center_x-side_length,center_y+side_length];
bottom_right_corner = [center_x+side_length,center_y-side_length];

%create mask with circles
mask = ones(m, n);

for i = 1:m
    for j = 1:n
        
            top_left_d=sqrt(sum((top_left_corner-[i,j]).^2));
            top_right_d=sqrt(sum((top_right_corner-[i,j]).^2));
            bottom_left_d=sqrt(sum((bottom_right_corner-[i,j]).^2));
            bottom_right_d=sqrt(sum((bottom_left_corner-[i,j]).^2));

            if top_left_d < circle_radius || top_right_d < circle_radius  || bottom_left_d < circle_radius || bottom_right_d < circle_radius 
                mask(i, j)=0;
            end
    end
end

% Perform Fourier Transform and center
fft_image = fftshift(fft2(image));
magnitude_spectrum = abs(fft_image);

% Apply the notch filter mask to the Fourier spectrum
filtered_fft_image = fft_image .* mask;
filtered_magnitude_spectrum = abs(filtered_fft_image);

%return to spatial domain
filtered_image = real(ifft2(ifftshift(filtered_fft_image)));

set(figure, 'Name', 'Original');
imshow(image);
set(figure, 'Name', 'Filtered');
imshow(filtered_image, []);
set(figure, 'Name', 'Fourier Spectrum');
imshow(log1p(magnitude_spectrum), []);
set(figure, 'Name', 'Filtered Fourier Spectrum');
imshow(log1p(filtered_magnitude_spectrum), []);
