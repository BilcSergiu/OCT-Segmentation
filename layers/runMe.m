close all;
clear
clc

addpath allCodes

% 
% 
% 
% [FileName, PathName] = uigetfile({'*.xml; *.tif; *.img;'},  'Select xml file');
% 
% [fPath, fName, fExt] = fileparts([PathName FileName]);
% 
% disp([fPath, fName, fExt]);
% 
% if fExt ==  '.xml'
%     docNode = xmlread(strcat(PathName, FileName));
%     data = docNode.getElementsByTagName('ExamURL');
%     im_slo = char(data.item(0).getFirstChild.getData);
%     disp(data.length);
%     disp('----------');
%     loc = strfind(im_slo,  '/');
%     im_slo(1:loc(end)) = [];
% 
%     %     disp(im_slo);
%     slo = imread([PathName im_slo]);
%     i = 1;
%     no_of_files = data.getLength - 1;
% 
%     subFolderName =  '';
%     WorkDir = [PathName subFolderName];
% 
% %     if exist(WorkDir,  'dir')
% %         A = dir(WorkDir);
% % 
% %         for k = 1:length(A)
% %             delete([WorkDir '/' A(k).name])
% %         end
% % 
% %         rmdir(WorkDir);
% %     end
% 
%     mkdir(WorkDir);
% 
%     % date = datestr(now, 'dd/mm/yy-HH:MM');
%     % mkdir([WorkDir '-' date]);
% 
%     matrix = ones(no_of_files, 5);
% 
%     for k = 1:no_of_files
%         docNode = xmlread(strcat(PathName, FileName));
%         data = docNode.getElementsByTagName('ExamURL');
%         im_oct = char(data.item(k).getFirstChild.getData);
%         loc = strfind(im_oct,  '/');
%         im_oct(1:loc(end)) = [];
%         imgName = [PathName im_oct];
%         [fPath1, fName1, fExt1] = fileparts(im_oct);
% 
%         disp(fName1);
%         disp(fExt1);
%         segmentMultipleOCT(PathName, fName1, fExt1, subFolderName);
%     end
% 
% elseif fExt ==  '.tif'

    PathName = 'D:\Licenta\Interface\OCTSegExamples\date_31_ian\Pacient_5\OD\Visit_8\';
%     PathName = 'D:\Licenta\Interface\OCTSegExamples\farsiu_subject_1001\';
    subFolderName =  'individual';
    WorkDir = [PathName subFolderName];

    if ~exist(WorkDir,  'dir') 
        mkdir(WorkDir);
    end

    fName = '2758EF50';
% fName = '41';
    fExt = '.tif';
    segmentOCT(PathName, fName, fExt, subFolderName);

% end
