%% Test whole functionality

params = struct();
params.C = 0.001;
params.smoothParam = 0.02;
params.gradientSmoothParam = 0.02;
params.gradientEnhaParam = 0.0001;
params.p9thAboveBandWidth = 10;
params.p9thSmoothParam = 0.0002;
params.p8thAboveBandWidth = 0;
params.p8thBelowBandWidth = 8;
params.p6thAboveBandWidth = 15;
params.p6thBelowBandWidth = 2;
params.p1stBelowBandWidth = 25;
params.p4thAboveBandWidth2 = 20;
params.p4thBelowBandWidth2 = 1;
params.p3thAboveBandWidth = 4;
params.p3thBelowBandWidth = 14;
params.p2thAboveBandWidth = 4;
params.p2thBelowBandWidth = 8;

originalImage = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/2341C0C0.tif');
originalImage = originalImage(:,:,1);

manualMask = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/fluid/manual_2341C0C0.tif');

[mask,~] = extractRetinaMask('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/', '2341C0C0','.tif',params);
[fluid,labeledFluid] = fluidSegmentation('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/', '2341C0C0','.tif',params);

difff1 = zeros(size(manualMask));
difff2 = zeros(size(fluid));

difff1(manualMask==1 & fluid==0) = 1;
difff2(manualMask==0 & fluid==255) = 1;
diff = or(difff1,difff2);

numberOfWhitePixels = sum(diff(:));

mask(mask==255 ) = 1;
