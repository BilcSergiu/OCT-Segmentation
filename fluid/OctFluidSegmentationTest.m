classdef OctFluidSegmentationTest < matlab.uitest.TestCase
    properties
        TestFile = '/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/22D1C0E0.xml';
        FirstImage = '/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/232EADF0.tif';
        SecondImage = '/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/23311EF0.tif';
        ThirdImage = '/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/2335D9E0.tif';
        SeventhImage = '/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/2341C0C0.tif';
    end
    methods(TestClassSetup)
        function checkTestFiles(tc)
            import matlab.unittest.constraints.IsFile
            tc.assumeThat(tc.TestFile,IsFile);
            tc.assumeThat(tc.FirstImage,IsFile);
            tc.assumeThat(tc.SecondImage,IsFile);
            tc.assumeThat(tc.ThirdImage,IsFile);
        end
    end
    methods (Test)
        function testInputButton(tc)
            app = OctSegmentationGUI_autoreflow;
            tc.addTeardown(@close,app.UIFigure);
            
            tc.press(app.LoadButton_2);
            
            firstImg = imread(tc.FirstImage);
            firstImg = firstImg(:,:,1);
            realImage = getimage(app.ImageAxes);
            realImage = realImage(:,:,1);
            
            tc.verifyEqual(realImage,firstImg);
            
            tc.press(app.NextSaveButton);
            secondImg = imread(tc.SecondImage);
            secondImg = secondImg(:,:,1);
            realImage = getimage(app.ImageAxes);
            realImage = realImage(:,:,1);
            
            
            tc.verifyEqual(realImage,secondImg);
            
            tc.press(app.NextSaveButton);
            thirdImg = imread(tc.ThirdImage);
            thirdImg = thirdImg(:,:,1);
            realImage = getimage(app.ImageAxes);
            realImage = realImage(:,:,1);
            
            tc.verifyEqual(realImage,thirdImg);
            
            tc.press(app.PreviousSaveButton);
            realImage = getimage(app.ImageAxes);
            realImage = realImage(:,:,1);
            
            tc.verifyEqual(realImage,secondImg);
            
            tc.press(app.NextSaveButton);
            tc.press(app.NextSaveButton);
            tc.press(app.NextSaveButton);
            tc.press(app.NextSaveButton);
            tc.press(app.NextSaveButton);
            
            seventhImg = imread(tc.SeventhImage);
            seventhImg = seventhImg(:,:,1);
            realImage = getimage(app.ImageAxes);
            realImage = realImage(:,:,1);
            
            tc.verifyEqual(realImage,seventhImg);
            
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
            
            manualMask = imread('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/fluid/manual_2341C0C0.tif');
            
            [mask,~] = extractRetinaMask('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/', '2341C0C0','.tif',params);
            [fluid,~] = fluidSegmentation('/media/sergiu/Shared/Licenta/Interface/OCTSegExamples/date_31_ian/Pacient_4/OD/Visit_1/', '2341C0C0','.tif',params);
            
            difff1 = zeros(size(manualMask));
            difff2 = zeros(size(fluid));
            
            difff1(manualMask==1 & fluid==0) = 1;
            difff2(manualMask==0 & fluid==255) = 1;
            diff = or(difff1,difff2);
            
            numberOfWhitePixels = sum(diff(:));
            
            mask(mask==255 ) = 1;
            
            totalNumberOfPixels = sum(mask(:));
            differencePercentage = numberOfWhitePixels / totalNumberOfPixels;
            
            disp(differencePercentage);
            
            assert(differencePercentage < 0.03);
        end
    end
end