function denoised_img = wavelet_diffusion(img, wavelet, level, K)
    % img - input OCT image
    % wavelet - type of wavelet (e.g., 'sym8')
    % level - level of decomposition
    % K - parameter to control thresholding in the HLj subbands

    % Convert image to double precision and apply logarithm
    img = double(img);
    log_img = log1p(img); % log1p(x) = log(1+x) to avoid log(0)

   % Pad the image to the required size
    [rows, cols] = size(log_img);
    new_rows = ceil(rows / 2^level) * 2^level;
    new_cols = ceil(cols / 2^level) * 2^level;
    padded_img = padarray(log_img, [new_rows - rows, new_cols - cols], 'symmetric', 'post');



    % Perform undecimated wavelet transform
    [C, S] = swt2(padded_img, level, wavelet);

    % Initialize arrays for thresholded coefficients
    C_thresh = C;

    % Process each level
    for j = 1:level
        % Extract subbands
        [LL, LH, HL, HH] = detcoef2('all', C, S, j);

        % Estimate noise variance from HH subband of the first level
        if j == 1
            noise_var = median(abs(HH(:))) / 0.6745;
        end

        % Apply spatially adaptive thresholding
        T_LH = K * noise_var; % Threshold for LH subband
        T_HL = noise_var;     % Threshold for HL subband
        T_HH = noise_var;     % Threshold for HH subband

        LH_thresh = soft_threshold(LH, T_LH);
        HL_thresh = soft_threshold(HL, T_HL);
        HH_thresh = soft_threshold(HH, T_HH);

        % Update thresholded coefficients
        C_thresh = replace_coeff(C_thresh, S, j, LL, LH_thresh, HL_thresh, HH_thresh);
    end

    % Perform inverse undecimated wavelet transform
    denoised_log_img = iswt2(C_thresh, S, wavelet);

    % Convert back from logarithm scale
    denoised_img = expm1(denoised_log_img); % expm1(y) = exp(y) - 1
end

function C_thresh = replace_coeff(C, S, level, LL, LH, HL, HH)
    % Replace coefficients in the swt2 structure
    C_thresh = C;
    [r, c] = ind2sub(size(S), find(S(:, 1) == level));
    index_start = sum(prod(S(1:r-1, :), 2)) + 1;
    index_end = index_start + prod(S(r, :)) - 1;
    C_thresh(index_start:index_end) = LL(:);
    index_start = index_end + 1;
    index_end = index_start + prod(S(r, :)) - 1;
    C_thresh(index_start:index_end) = LH(:);
    index_start = index_end + 1;
    index_end = index_start + prod(S(r, :)) - 1;
    C_thresh(index_start:index_end) = HL(:);
    index_start = index_end + 1;
    index_end = index_start + prod(S(r, :)) - 1;
    C_thresh(index_start:index_end) = HH(:);
end

function y = soft_threshold(x, T)
    % Apply soft thresholding
    y = sign(x) .* max(abs(x) - T, 0);
end


