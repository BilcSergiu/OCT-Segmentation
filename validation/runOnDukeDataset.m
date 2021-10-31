close all;

params = struct();
% 0.001
params.C = 0.0001;
params.smoothParam = 0.8;
params.gradientSmoothParam = 0.8;
params.gradientEnhaParam = 0.0001;
params.p9thAboveBandWidth = 10;
params.p9thSmoothParam = 0.0002;
params.p4thAboveBandWidth = 25;
params.p4thBelowBandWidth = 10;
params.p8thAboveBandWidth = 0;
params.p8thBelowBandWidth = 4;
params.p6thAboveBandWidth = 22;
params.p6thBelowBandWidth = 2;
params.p1stBelowBandWidth = 30;
params.p5thAboveBandWidth = 0;
params.p5thBelowBandWidth = 5;
params.p4thAboveBandWidth2 = 10;
params.p4thBelowBandWidth2 = 1;
params.p3thAboveBandWidth = 2;
params.p3thBelowBandWidth = 20;
params.p2thAboveBandWidth = 2;
params.p2thBelowBandWidth = 4;

params = struct();
% 0.001
params.C = 0.0001;
params.smoothParam = 0.8;
params.gradientSmoothParam = 0.8;
params.gradientEnhaParam = 0.0001;
params.p9thAboveBandWidth = 10;
params.p9thSmoothParam = 0.0002;
params.p4thAboveBandWidth = 15;
params.p4thBelowBandWidth = 10;
params.p8thAboveBandWidth = 0;
params.p8thBelowBandWidth = 4;
params.p6thAboveBandWidth = 25;
params.p6thBelowBandWidth = 2;
params.p1stBelowBandWidth = 40;
params.p5thAboveBandWidth = 0;
params.p5thBelowBandWidth = 5;
params.p4thAboveBandWidth2 = 75;
params.p4thBelowBandWidth2 = 1;
params.p3thAboveBandWidth = 2;
params.p3thBelowBandWidth = 20;
params.p2thAboveBandWidth = 2;
params.p2thBelowBandWidth = 4;

M_SD_SE =[ ];
M_SD_AE =[ ];
M_MD_SE =[ ];
M_MD_AE =[ ];
MATRIX_SE = [];
MATRIX_AE = [];

url = 'D:\Licenta\Tools\relaynet_pytorch\datasets\Subject_05.mat';
data = load(url);

indexes = extractLayersIndexes(url);
indexes = indexes(4:4);
% disp(indexes);
% disp(size(indexes));
for i = 1 : (size(indexes,2) )
    index = indexes(i);
    disp(index);
    
    img = data.images(:,:,index);
    img = double(img);
    img(img == 255) = 0;
    
%     f = figure;
%     ax3 = axes(f);
%     imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
%     title(ax3,['Imaginea: ', num2str(index)]);
%     hold off;
    
    layers = data.manualLayers1(:,:,index);
    
    X1 = find(~isnan(layers(1,:,:)), 1);
    tempLayer = fliplr(layers(1,:,:));
    X2 = find(~isnan(tempLayer),1);
    
    X1 = X1 + 10;
    X2 = X2 + 10;
    
    X2 = size(img,2) - X2;
   
    img = img(:,X1:X2);
    
    [output, ~] = segmentMultipleOCTB(img, params, false);
    
    f = figure;
    ax3 = axes(f);
    imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    title(ax3,['Imaginea: ', num2str(index)]);
    plot(output.B9,'-r', 'LineWidth',1);
    plot(output.B8,'-b', 'LineWidth',1);
    plot(output.B7,'-y', 'LineWidth',1);
    % plot(output.B6,'-y', 'LineWidth',1);
    plot(output.B5,'-c', 'LineWidth',1);
    plot(output.B4,'-m', 'LineWidth',1);
    plot(output.B3,'-y', 'LineWidth',1);
    plot(output.B2,'-g', 'LineWidth',1);
    plot(output.B1,'-r', 'LineWidth',1);
    hold off;
    %
    % disp(layers);
    
%     img = data.images(:,:,index);
%     img = double(img);
    output.B9 = [zeros(1,X1), output.B9];
    output.B8 = [zeros(1,X1), output.B8];
    output.B7 = [zeros(1,X1), output.B7];
    output.B5 = [zeros(1,X1), output.B5];
    output.B4 = [zeros(1,X1), output.B4];
    output.B3 = [zeros(1,X1), output.B3];
    output.B2 = [zeros(1,X1), output.B2];
    output.B1 = [zeros(1,X1), output.B1];
    
    layers(1,X1:X2);
    layers(2,X1:X2);
    layers(3,X1:X2);
    layers(4,X1:X2);
    layers(5,X1:X2);
    layers(6,X1:X2);
    layers(7,X1:X2);
    layers(8,X1:X2);
    
    
    f = figure;
    ax3 = axes(f);
    imagesc(ax3,img); colormap('gray'); axis off; axis equal; hold on;
    title(ax3,['Imaginea: ', num2str(index)]);
%     plot(layers(8,:,:),'-r', 'LineWidth',1);
%     plot(layers(7,:,:),'-r', 'LineWidth',1);
%     plot(layers(6,:,:),'-r', 'LineWidth',1);
%     plot(layers(5,:,:),'-r', 'LineWidth',1);
%     plot(layers(4,:,:),'-r', 'LineWidth',1);
%     plot(layers(3,:,:),'-r', 'LineWidth',1);
%     plot(layers(2,:,:),'-r', 'LineWidth',1);
%     plot(layers(1,:,:),'-r', 'LineWidth',1);
%     plot(output.B9,'-g', 'LineWidth',1);
%     plot(output.B8,'-g', 'LineWidth',1);
%     plot(output.B7,'-g', 'LineWidth',1);
%     plot(output.B5,'-g', 'LineWidth',1);
%     plot(output.B4,'-g', 'LineWidth',1);
%     plot(output.B3,'-g', 'LineWidth',1);
%     plot(output.B2,'-g', 'LineWidth',1);
%     plot(output.B1,'-g', 'LineWidth',1);
    plot(layers(8,X1:X2),'-r', 'LineWidth',1);
    plot(layers(7,X1:X2),'-b', 'LineWidth',1);
    plot(layers(6,X1:X2),'-y', 'LineWidth',1);
    plot(layers(5,X1:X2),'-c', 'LineWidth',1);
    plot(layers(4,X1:X2),'-m', 'LineWidth',1);
    plot(layers(3,X1:X2),'-y', 'LineWidth',1);
    plot(layers(2,X1:X2),'-g', 'LineWidth',1);
    plot(layers(1,X1:X2),'-r', 'LineWidth',1);
    hold off;
    
    
    B1 = layers(1,:,:);
    B2 = layers(2,:,:);
    B3 = layers(3,:,:);
    B4 = layers(4,:,:);
    B5 = layers(5,:,:);
    B6 = layers(6,:,:);
    B7 = layers(7,:,:);
    B8 = layers(8,:,:);   
    
    B1 = B1(X1:X2);
    B2 = B2(X1:X2);
    B3 = B3(X1:X2);
    B4 = B4(X1:X2);
    B5 = B5(X1:X2);
    B6 = B6(X1:X2);
    B7 = B7(X1:X2);
    B8 = B8(X1:X2);
    
%     output.B1 = output.B1(X1:X2);
%     output.B2 = output.B2(X1:X2);
%     output.B3 = output.B3(X1:X2);
%     output.B4 = output.B4(X1:X2);
%     output.B5 = output.B5(X1:X2);
%     output.B7 = output.B7(X1:X2);
%     output.B8 = output.B8(X1:X2);
%     output.B9 = output.B9(X1:X2);
    
    output.B9 = output.B9(:,X1:end-1);
    output.B8 = output.B8(:,X1:end-1);
    output.B7 = output.B7(:,X1:end-1);
    output.B5 = output.B5(:,X1:end-1);
    output.B4 = output.B4(:,X1:end-1);
    output.B3 = output.B3(:,X1:end-1);
    output.B2 = output.B2(:,X1:end-1);
    output.B1 = output.B1(:,X1:end-1);

    DiffB1 = output.B1 - B1;
    DiffB2 = output.B2 - B2;
    DiffB3 = output.B3 - B3;
    DiffB4 = output.B4 - B4;
    DiffB5 = output.B5 - B5;
    DiffB6 = output.B7 - B6;
    DiffB7 = output.B8 - B7;
    DiffB8 = output.B9 - B8;
    %     DiffB9 = layers(9,:,:) - output.B9;
    
    if  ~ismember(index, [14, 31])
%     SE = [nanmedian(DiffB1) nanmedian(DiffB2) nanmedian(DiffB3) nanmedian(DiffB4) nanmedian(DiffB5) nanmedian(DiffB6) nanmedian(DiffB7) nanmedian(DiffB8)];
%     AE = [nanmedian(abs(DiffB1)) nanmedian(abs(DiffB2)) nanmedian(abs(DiffB3)) nanmedian(abs(DiffB4)) nanmedian(abs(DiffB5)) nanmedian(abs(DiffB6)) nanmedian(abs(DiffB7)) nanmedian(abs(DiffB8))];
%     
    SE = [nansum(DiffB1)/length(DiffB1(~isnan(DiffB1)))  nansum(DiffB2)/length(DiffB2(~isnan(DiffB2))) ,nansum(DiffB3)/length(DiffB3(~isnan(DiffB3))) nansum(DiffB4)/length(DiffB4(~isnan(DiffB4))) nansum(DiffB5)/length(DiffB5(~isnan(DiffB5))) nansum(DiffB6)/length(DiffB6(~isnan(DiffB6))) nansum(DiffB7)/length(DiffB7(~isnan(DiffB7))) ,nansum(DiffB8)/length(DiffB8(~isnan(DiffB8)))];
    
    AE = [nansum(abs(DiffB1))/length(DiffB1(~isnan(DiffB1))) nansum(abs(DiffB2))/length(DiffB2(~isnan(DiffB2))) nansum(abs(DiffB3))/length(DiffB3(~isnan(DiffB3))) nansum(abs(DiffB4))/length(DiffB4(~isnan(DiffB4))) nansum(abs(DiffB5))/length(DiffB5(~isnan(DiffB5))) nansum(abs(DiffB6))/length(DiffB6(~isnan(DiffB6))) nansum(abs(DiffB7))/length(DiffB7(~isnan(DiffB7))) nansum(abs(DiffB8))/length(DiffB8(~isnan(DiffB8)))];
    
 MATRIX_SE = [MATRIX_SE; SE];
    MATRIX_AE = [MATRIX_AE; AE];
   
        end
    
end

disp('======== SE ========');
disp(MATRIX_SE);
disp('======== MEAN SE ========');
disp(median(MATRIX_SE));
disp('======== STANDARD DEVIATION SE ========');
disp(std(MATRIX_SE));
disp('======== AE ========');
disp(MATRIX_AE);
disp('======== MEAN AE ========');
disp(median(MATRIX_AE));
disp('======== STANDARD DEVIATION AE ========');
disp(std(MATRIX_AE));
disp('================');

