function output = myVersionOfSegmentation(PathName, imgName, imgExt, subFolderName)

    imgO = imread([PathName imgName imgExt]); %pick an image
    
%     img0 = image;
    imgO = imgO(:, :, 1);
    img0 = double(imgO);
    szimg = size(img0);
    % figure; imagesc(img0); colormap('gray'); axis off; axis equal; hold on

    imgPad = padarray(img0, [0, 1],  'symmetric');

    % figure; imagesc(imgPad);title('imgPad');   colormap('gray'); axis off; axis equal; hold on

    darkTobright = 1;
    brightTodark = 0;

    tic

    %% get 7th boundary (IS-OS border)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % presegment image to enhance IS-OS layer and guarantee this layer segmented
    bwImg = Seg2(img0, 100, 0.01, 0.02);

    img = double(bwImg .* img0);


    % get the vertical gradient
    gradImg = getGradientMap0(img, darkTobright, 0.02, 2);


    [B7, Y] = getSegBoundary(gradImg, imgPad, szimg, 1);
    % toc
    % fatten image and 7th boundary to make the next segmentation easier
    [fattenedImgPad, refpt] = fattenImg(imgPad, B7);

    fattenedB7 = ones(size(B7)) .* refpt;

    figure; imagesc(fattenedImgPad); colormap('gray'); axis off; axis equal; hold on

    plot(Y,fattenedB7,'g-.','linewidth',2);

    fattenedImgPad = fattenedImgPad(:, 2:end - 1);

    %% get the 9th boundary (RPE-CH border)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get the region of interst, refering to IS-OS layer
    p9thAboveBandWidth = 4;

    BW = removeRegionAboveSegLine(fattenedB7, Y, imgPad, p9thAboveBandWidth);

    gradImg2 = getGradientMap0(imgPad(:, 2:end - 1), brightTodark, 20, 30);
    gradImg = getGradientMap0(fattenedImgPad, brightTodark, 20, 30);

     % smooth = 0.00002
    [B9, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 1);

    plot(Y, B9, 'r-.', 'linewidth', 2);

    %% get the 8th boundary ((OS-RPE border)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get the region of interst, refering to IS-OS layer
    p8thAboveBandWidth = 8;
    p8thBelowBandWidth = 4;
    BW0 = removeRegionAboveSegLine(fattenedB7, Y, imgPad, p8thAboveBandWidth); %6th
    BW1 = removeRegionBelowSegLine(B9, Y, imgPad, p8thBelowBandWidth); %bottom
    BW = BW0 .* BW1;
    % BW = BW1;

    % figure; imagesc(fattenedImgPad.*BW); colormap('gray'); axis off; axis equal;
    gradImg = getGradientMap0(fattenedImgPad, brightTodark, 0.08, 0.1);

    [B8, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.00002);

    plot(Y, B8, 'b-.', 'linewidth', 2);

    %% get the 6th boundary (ONL_IS border)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get the region of interest i.e. narrow band above the IS_OS layer
    BW = zeros(szimg);
    BW(refpt - 15:refpt - 5, 1:end) = 1; % adjust parameters to get right ROI

    gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.1, 1);

    % [B6, Y] = getSegBoundary(gradImg.*BW, imgPad, szimg, 0.00002);
    [B6, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.00002);

    plot(Y, B6, 'y', 'linewidth', 2);

    %% get the 1st boundary (IML border)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p1stBelowBandWidth = 2;
    BW = removeRegionBelowSegLine(B6, Y, imgPad, p1stBelowBandWidth);

    gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.05, 50);

    % figure; imshow(gradImg,[]); colormap('gray'); axis off; axis equal; hold on

    [B1, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.01);

    % smooth IML layer to create better ROI for INL_OPL
    [soomthedB1, Y] = smoothSegLine(B1, Y, 0.0000001);

    plot(Y, B1, 'r', 'linewidth', 2);

    %% get the 4th boundary (INL_OPL border)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p4thAboveBandWidth = 10;
    p4thBelowBandWidth = 10;
    BW0 = removeRegionAboveSegLine(soomthedB1, Y, imgPad, p4thAboveBandWidth); %1st
    BW1 = removeRegionBelowSegLine(B6, Y, imgPad, p4thBelowBandWidth); %6th
    BW = BW0 .* BW1; %ROI between 1th and 6th layers

    gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.1, 1000);

    [B4, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.2);

    %% get the 5th boundary (OPLO border)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p5thAboveBandWidth = 2;
    p5thBelowBandWidth = 5;
    BW0 = removeRegionAboveSegLine(B4, Y, imgPad, p5thAboveBandWidth); %4th
    BW1 = removeRegionBelowSegLine(B6, Y, imgPad, p5thBelowBandWidth); %6th
    BW = BW1 .* BW0; %ROI between 4th and 6th layers

    gradImg = getGradientMap0(fattenedImgPad, brightTodark, 0.06, 1);

    [B5, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.01);

    plot(Y, B5, 'c', 'linewidth', 2);

    %% get the 4th boundary (INL_OPL border) again
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p4thAboveBandWidth2 = 10;
    p4thBelowBandWidth2 = 1;
    BW0 = removeRegionAboveSegLine(B1, Y, imgPad, p4thAboveBandWidth2); %1st
    BW1 = removeRegionBelowSegLine(B5, Y, imgPad, p4thBelowBandWidth2); %5th
    BW = BW0 .* BW1; %ROI between 1th and 6th layers

    gradImg = getGradientMap0(fattenedImgPad, darkTobright, 0.1, 1000);

    [B4, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = find(B4 > B5);
    B4(temp) = B5(temp) - 1;

    temp = find(B4 < B1 + 3);
    B4(temp) = B1(temp) + 3;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [B4, Y] = smoothSegLine(B4, Y, 0.01);

    plot(Y, B4, 'm', 'linewidth',2);

    %% get the 3th boundary (IPL-INL border)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    p3thAboveBandWidth = 10;
    p3thBelowBandWidth = 13;
    BW0 = removeRegionBelowSegLine(B4, Y, imgPad, p3thAboveBandWidth); %4th
    BW1 = removeRegionBelowSegLine(B4, Y, imgPad, p3thBelowBandWidth); %4th

    BW = BW0 - BW1; %ROI above 4th layer

    gradImg = getGradientMap0(fattenedImgPad, brightTodark, 0.08, 10);

    [B3, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = find(B3 < B1 + 1);
    B3(temp) = B1(temp) + 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [B3, Y] = smoothSegLine(B3, Y, 0.01);

    plot(Y, B3, 'y', 'linewidth', 2);

    %% get the 2th boundary (RNFL border)
    p2thAboveBandWidth = 0;
    p2thBelowBandWidth = 4;
    BW1 = removeRegionAboveSegLine(B1, Y, imgPad, p2thAboveBandWidth); % if above move seg line down to several pixels
    BW0 = removeRegionBelowSegLine(B3, Y, imgPad, p2thBelowBandWidth); % if below move seg line up to several pixels
    BW = BW0 .* BW1; %ROI between 1th and 3th layers

    gradImg = getGradientMap(fattenedImgPad, brightTodark, 0.08, 0.001);

    [B2, Y] = getSegBoundary(gradImg .* BW, imgPad, szimg, 0.01);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = find(B2 < B1);
    B2(temp) = B1(temp);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    toc

    plot(Y, B2, 'g', 'linewidth', 2);
    plot(Y, B1, 'r', 'linewidth', 2);



    close all
    % %% show the original image with the back-fattened boundaries

    % figure('visible','on');
    figure; imshow(uint8(imgPad)); hold on

    temp = refpt - B7;

    B9 = B9 - temp;
    B8 = B8 - temp;
    B6 = B6 - temp;
    B5 = B5 - temp;
    B4 = B4 - temp;
    B3 = B3 - temp;
    B2 = B2 - temp;
    B1 = B1 - temp;

    RPECH = plot(Y, B9,  'r',  'linewidth', 2);
    OSRPE = plot(Y, B8,  'b',  'linewidth', 2);
    ISOS = plot(Y, B7,  'g',  'linewidth', 2);
    ONLIS = plot(Y, B6,  'y',  'linewidth', 2);
    OPLO = plot(Y, B5,  'c',  'linewidth', 2);
    INLOPL = plot(Y, B4,  'm',  'linewidth', 2);
    IPLINL = plot(Y, B3,  'y',  'linewidth', 2);
    RNFL = plot(Y, B2,  'g',  'linewidth', 2);
    IML = plot(Y, B1,  'r',  'linewidth', 2);

    % text([0],[IML(1).y],IML, 'IML');
    % text([0],RNFL, 'RNFL');
    % text([0],IPLINL, 'IPLINL');
    % text([0],INLOPL, 'INLOPL');
    % text([0],OPLO, 'OPLO');
    % text([0],ONLIS, 'ONLIS');
    % text([0],ISOS, 'ISOS');
    % text([0],OSRPE, 'OSRPE');
    % text([0],RPECH, 'RPECH');

    title(imgName);

    hold off;

    RPECH_OSRPE = B9 - B8;
    OSRPE_ISOS = B8 - B7;
    ISOS_ONLIS = B7 - B6;
    ONLIS_OPLO = B6 - B5;
    OPLO_INLOPL = B5 - B4;
    INLOPL_IPLINL = B4 - B3;
    IPLINL_RNFL = B3 - B2;
    RNFL_IML = B2 - B1;

    Layers = [
        RPECH_OSRPE;
        OSRPE_ISOS;
        ISOS_ONLIS;
        ONLIS_OPLO;
        OPLO_INLOPL;
        INLOPL_IPLINL;
        IPLINL_RNFL;
        RNFL_IML;
        ];

    % Params = [
    %     '1stBelowBandWidth', p1stBelowBandWidth;
    %     '2thAboveBandWidth', p2thAboveBandWidth;
    %     '2thBelowBandWidth', p2thBelowBandWidth;
    %     '3thAboveBandWidth', p3thAboveBandWidth;
    %     '3thBelowBandWidth', p3thBelowBandWidth;
    %     '4thAboveBandWidth', p4thAboveBandWidth;
    %     '4thBelowBandWidth', p4thBelowBandWidth;
    %     '4thAboveBandWidth', p4thAboveBandWidth2;
    %     '4thBelowBandWidth', p4thBelowBandWidth2;
    %     '5thAboveBandWidth', p5thAboveBandWidth;
    %     '5thBelowBandWidth', p5thBelowBandWidth;
    %     % '6thAboveBandWidth', p6thAboveBandWidth;
    %     % '6thBelowBandWidth', p6thBelowBandWidth;
    %     % '7thAboveBandWidth', p7thAboveBandWidth;
    %     % '7thBelowBandWidth', p7thBelowBandWidth;
    %     '8thAboveBandWidth', p8thAboveBandWidth;
    %     '8thBelowBandWidth', p8thBelowBandWidth;
    %     '9thAboveBandWidth', p9thAboveBandWidth;
    % ];

    % Params = [
    %     1, p1stBelowBandWidth;
    %     2, p2thAboveBandWidth;
    %     2, p2thBelowBandWidth;
    %     3, p3thAboveBandWidth;
    %     3, p3thBelowBandWidth;
    %     4, p4thAboveBandWidth;
    %     4, p4thBelowBandWidth;
    %     4, p4thAboveBandWidth2;
    %     4, p4thBelowBandWidth2;
    %     5, p5thAboveBandWidth;
    %     5, p5thBelowBandWidth;
    %     8, p8thAboveBandWidth;
    %     8, p8thBelowBandWidth;
    %     9, p9thAboveBandWidth;
    %     ];


    
    previousFolder = pwd;
    cd([PathName subFolderName '/']);
    
   

    F = getframe;
    % save the image:
    % save_file_name = strcat(working_directory_name, 'Eye_res_00001.jpg');
    imwrite(F.cdata, [imgName '_segmentation' imgExt]);
    close(figure);

    mkdir(imgName);
    cd(imgName);
    save('B9.mat', 'Y', 'B9');
    save('B8.mat', 'Y', 'B8');
    save('B7.mat', 'Y', 'B7');
    save('B6.mat', 'Y', 'B6');
    save('B5.mat', 'Y', 'B5');
    save('B4.mat', 'Y', 'B4');
    save('B3.mat', 'Y', 'B3');
    save('B2.mat', 'Y', 'B2');
    save('B1.mat',  'Y',  'B1');
    
    cd([PathName subFolderName '/']);
    writematrix(Layers, [imgName '_thickness.csv']);
    % writematrix(Params, [imgName '_params.csv']);

    cd(previousFolder);


    % save([imgName '_B9.mat'], 'Y', 'B3');
    % save([imgName '_B8.mat'], 'Y', 'B2');
    % save([imgName '_B7.mat'], 'Y', 'B1');
    % save([imgName '_B6.mat'], 'Y', 'B3');
    % save([imgName '_B5.mat'], 'Y', 'B2');
    % save([imgName '_B4.mat'], 'Y', 'B1');
    % save([imgName '_B3.mat'], 'Y', 'B3');
    % save([imgName '_B2.mat'], 'Y', 'B2');
    % save([imgName '_B1.mat'],  'Y',  'B1');