function QI = calculateQI(img)
    % Apply the Split Bregman ROF denoising method
    relevant_img = SplitBregmanROF(double(img), .15, 0.001);
    relevant_img = uint8(relevant_img);

    % Calculate the histogram of the relevant pixels
    relevant_pixels = relevant_img(relevant_img > min(relevant_img(:)) & relevant_img < max(relevant_img(:)));
    [counts, binLocations] = imhist(relevant_pixels);
    total_pixels = numel(relevant_pixels);

    % Calculate the cumulative distribution function (CDF)
    cdf = cumsum(counts) / total_pixels;

    % Determine the percentile values
    Low = binLocations(find(cdf >= 0.01, 1)); % 1st percentile
    Noise = binLocations(find(cdf >= 0.75, 1)); % 75th percentile
    Saturation = binLocations(find(cdf >= 0.99, 1)); % 99th percentile
    Middle = (Noise + Saturation) / 2; % Mean of Noise and Saturation

    % Calculate Intensity Ratio (IR)
    IR = (Saturation - Low) / Low * 100;

    % Calculate Tissue Signal Ratio (TSR)
    high_reflective_pixels = sum(relevant_pixels >= Middle & relevant_pixels <= Saturation);
    low_reflective_pixels = sum(relevant_pixels >= Noise & relevant_pixels < Middle);
    TSR = high_reflective_pixels / low_reflective_pixels;

    % Compute the Quality Index (QI)
    QI = IR * TSR;
end
