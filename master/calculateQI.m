function QI = calculateQI(imgPath)
    img = imread(imgPath);

    % Convert to grayscale if necessary
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % Apply the Split Bregman ROF denoising method
    % relevant_img = SplitBregmanROF(double(img), .15, 0.001);
    % relevant_img = uint8(relevant_img);
    relevant_img = img;

    % Calculate the histogram of the relevant pixels
    % relevant_pixels = relevant_img(relevant_img > min(relevant_img(:)) & relevant_img < max(relevant_img(:)));
    relevant_pixels = relevant_img(relevant_img > prctile(relevant_img(:), 1) & relevant_img < prctile(relevant_img(:), 99));
    % relevant_pixels = relevant_img(relevant_img > 50 & relevant_img < max(relevant_img(:)));
    
    % figure;
    % imhist(relevant_pixels);
    % title('Histogram of the Grayscale Image');
    % xlabel('Pixel Intensity');
    % ylabel('Frequency');



    [counts, binLocations] = imhist(relevant_pixels);
    total_pixels = numel(relevant_pixels);

    % Calculate the cumulative distribution function (CDF)
    cdf = cumsum(counts) / total_pixels;

    % Determine the percentile values
    Low = binLocations(find(cdf >= 0.30, 1)); % 1st percentile
    Noise = binLocations(find(cdf >= 0.75, 1)); % 75th percentile
    Saturation = binLocations(find(cdf >= 0.90, 1)); % 99th percentile
    Middle = (Noise + Saturation) / 2; % Mean of Noise and Saturation
    % disp([Low, Noise, Saturation, Middle])

    % Calculate Intensity Ratio (IR)
    IR = (Saturation - Low) / Low * 100;
    % IR = log10((Saturation - Low) / Low + 1);

    % Calculate Tissue Signal Ratio (TSR)
    high_reflective_pixels = sum(relevant_pixels >= Middle & relevant_pixels <= Saturation);
    low_reflective_pixels = sum(relevant_pixels >= Noise & relevant_pixels < Middle);
    TSR = high_reflective_pixels / low_reflective_pixels;

    % Compute the Quality Index (QI)
    QI = IR * TSR;
end
