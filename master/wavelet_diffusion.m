function denoised_img = wavelet_diffusion(img, wavelet, level, K)
      % img - input OCT image
    % wavelet - type of wavelet (e.g., 'sym8')
    % level - level of decomposition (e.g., 1, 2, 3, ...)
    % K - parameter to control thresholding in the HLj subbands

    % Convert image to double precision and apply logarithm
    img = double(img);
    log_img = log1p(img); % log1p(x) = log(1 + x) to avoid log(0)

    % Pad the image to the required size
    % [rows, cols] = size(log_img);
    rows = size(log_img, 1);
    cols = size(log_img, 2);
    padded_rows = ceil(rows / 2^level) * 2^level;
    padded_cols = ceil(cols / 2^level) * 2^level;
    disp([size(log_img,1), size(log_img, 2), size(img,1), size(img, 2)])
    disp([rows,padded_rows , cols,  padded_cols, padded_rows - rows, padded_cols - cols]);
    padded_img = padarray(log_img, [padded_rows - rows, padded_cols - cols], 'symmetric', 'post');

    % Perform undecimated wavelet transform using MATLAB's Wavelet Toolbox
    [A, H, V, D] = swt2(padded_img, level, wavelet);

    % Initialize arrays for thresholded coefficients
    A_thresh = A;
    H_thresh = H;
    V_thresh = V;
    D_thresh = D;

    % Process each level
    for j = 1:level
        % Extract subbands for the current level
        LL = A(:,:,j);
        LH = H(:,:,j);
        HL = V(:,:,j);
        HH = D(:,:,j);

        % Estimate noise variance from HH subband of the first level
        if j == 1
            noise_var = median(abs(HH(:))) / 0.6745;
        end

        % Apply spatially adaptive thresholding
        T_LH = K * noise_var; % Threshold for LH subband
        T_HL = noise_var;     % Threshold for HL subband
        T_HH = noise_var;     % Threshold for HH subband

        H_thresh(:,:,j) = soft_threshold(LH, T_LH);
        V_thresh(:,:,j) = soft_threshold(HL, T_HL);
        D_thresh(:,:,j) = soft_threshold(HH, T_HH);

        % Update thresholded coefficients
        A_thresh(:,:,j) = LL;
    end

    % Perform inverse undecimated wavelet transform
    denoised_log_img = iswt2(A_thresh, H_thresh, V_thresh, D_thresh, wavelet);

    % Remove the padding
    % denoised_log_img = denoised_log_img(1:rows, 1:cols);

    % Convert back from logarithm scale
    denoised_img = expm1(denoised_log_img); % expm1(y) = exp(y) - 1
end

function y = soft_threshold(x, T)
    % Apply soft thresholding
    y = sign(x) .* max(abs(x) - T, 0);
end