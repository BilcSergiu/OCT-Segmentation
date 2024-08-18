function denoised_img = contourlet_denoising_oct(img, num_levels, threshold)
    % img: Input image
    % num_levels: Number of levels in the pyramid
    % threshold: Threshold for denoising
    
    % Step 1: Contourlet Transform
    contourlet_coeffs = contourlet_transform(img, num_levels);
    
    % Step 2: Thresholding (apply to directional coefficients only)
    for i = 1:num_levels
        for j = 1:length(contourlet_coeffs{i})
            contourlet_coeffs{i}{j} = soft_threshold(contourlet_coeffs{i}{j}, threshold);
        end
    end
    
    % Step 3: Inverse Contourlet Transform
    denoised_img = inverse_laplacian_pyramid(contourlet_coeffs(1:num_levels), contourlet_coeffs{num_levels + 1});
end

function y = soft_threshold(x, T)
    % Apply soft thresholding
    y = sign(x) .* max(abs(x) - T, 0);
end

function [lpyr, lres] = laplacian_pyramid_decomposition(img, num_levels)
    % img: Input image
    % num_levels: Number of levels in the pyramid
    % lpyr: Laplacian pyramid output
    % lres: Lowpass residual

    % Gaussian filter
    h = fspecial('gaussian', [5, 5], 1);
    
    lpyr = cell(1, num_levels);
    current_img = img;
    
    for i = 1:num_levels
        % Apply Gaussian filter
        blurred_img = imfilter(current_img, h, 'replicate');
        
        % Downsample
        downsampled_img = blurred_img(1:2:end, 1:2:end);
        
        % Upsample and interpolate
        upsampled_img = imresize(downsampled_img, 2, 'bilinear');
        
        % Calculate the Laplacian image
        lpyr{i} = current_img - upsampled_img;
        
        % Update the current image
        current_img = downsampled_img;
    end
    
    % Lowpass residual
    lres = current_img;
end


function dir_coeff = directional_filtering(img)
    % img: Bandpass image from Laplacian Pyramid
    % dir_coeff: Directional subbands
    
    % Define simple directional filters (e.g., Sobel operators)
    sobel_h = fspecial('sobel');
    sobel_v = sobel_h';
    
    % Apply filters
    dir_coeff{1} = imfilter(img, sobel_h, 'replicate'); % Horizontal edges
    dir_coeff{2} = imfilter(img, sobel_v, 'replicate'); % Vertical edges
end

function contourlet_coeffs = contourlet_transform(img, num_levels)
    % img: Input image
    % num_levels: Number of levels in the pyramid
    % contourlet_coeffs: Output Contourlet coefficients

    % Laplacian Pyramid Decomposition
    [lpyr, lres] = laplacian_pyramid_decomposition(img, num_levels);
    
    contourlet_coeffs = cell(1, num_levels);
    
    % Apply Directional Filtering to each level of the pyramid
    for i = 1:num_levels
        contourlet_coeffs{i} = directional_filtering(lpyr{i});
    end
    
    % Add the lowpass residual to the output
    contourlet_coeffs{num_levels + 1} = lres;
end


function img_recon = inverse_laplacian_pyramid(lpyr, lres)
    % lpyr: Laplacian pyramid coefficients
    % lres: Lowpass residual
    % img_recon: Reconstructed image
    
    num_levels = length(lpyr);
    current_img = lres;
    
    for i = num_levels:-1:1
        % Upsample and interpolate
        upsampled_img = imresize(current_img, 2, 'bilinear');
        
        % Reconstruct the image
        current_img = upsampled_img + lpyr{i};
    end
    
    img_recon = current_img;
end

