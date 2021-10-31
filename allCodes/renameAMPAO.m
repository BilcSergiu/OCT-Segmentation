function output = renameAMPAO(FileName,PathName,handles)
if FileName(end-2:end) == 'xml'
    docNode = xmlread(strcat(PathName,FileName));
    data = docNode.getElementsByTagName('ExamURL');
    im_slo = char(data.item(0).getFirstChild.getData);
    disp(data.length);
    disp('----------');
    loc = strfind(im_slo,'/') ;
    %im_slo(1:loc(end)) =[];
   
%     disp(im_slo);
    slo = imread(im_slo);
    i = 1;
    no_of_files = data.getLength - 1;
    
    matrix = ones(no_of_files,5);
    for k = 1 : no_of_files
        docNode = xmlread(strcat(PathName,FileName));
        data = docNode.getElementsByTagName('ExamURL');
        im_oct = char(data.item(k).getFirstChild.getData);
        loc = strfind(im_oct,'/') ;
        %im_oct(1:loc(end)) =[];
        disp(im_oct);
     
        l = docNode.getElementsByTagName('ID');
        ID = char(l.item(k+3).getFirstChild.getData);
        matrix(k,1)=str2num(ID);
        x = docNode.getElementsByTagName('X');
        X1 = char(x.item(i).getFirstChild.getData);
        matrix(k,2)=str2num(X1);
        x1_1 = str2num(X1);
        y = docNode.getElementsByTagName('Y');
        y1 = char(y.item(i).getFirstChild.getData);
        matrix(k,3)=str2num(y1);
        y1_1 = str2num(y1);
        x = docNode.getElementsByTagName('X');
        X2 = char(x.item(i+1).getFirstChild.getData);
        matrix(k,4)=str2num(X2);
        x2_2 = str2num(X2);
        y = docNode.getElementsByTagName('Y');
        y2 = char(y.item(i+1).getFirstChild.getData);
        matrix(k,5)=str2num(y2);
        y2_2 = str2num(y2);
        dot(1,:,k)=[x1_1,x2_2,y1_1,y2_2];
        %  axes(handles.axes1);
        %  plot([x2_2/sclae_x,x1_1/sclae_x],[y2_2/sclae_x,y1_1/sclae_x],'color','y');
        % hold on;
        oct = imread(im_oct);
        %         [M,N,Q]=size(oct);
        %         OCT3D(:,k)=oct(:);
        % axes(handles.axes2);
        % imshow(oct)
        %         [M,N,Q]=size(oct);
        %         save oct oct
        OCT3D(:,:,k)=oct(:,:,1);
        % title(sprintf('ID = %i \n',k));
        %
        % pause(0.17);
        i = i+2;
        % hold off;
    end
    
    output.BScan = OCT3D;
    output.slo = slo;
    output.ScaleX= 0.0117;
    output.ScaleZ= 0.0117;
    output.NumBScans=no_of_files;
    output.StartX = dot(1,2,:);
    output.EndX = dot(1,1,:);
    output.StartY = dot(1,4,:);
    output.EndY = dot(1,3,:);
    output.format = 'xml';
elseif FileName(end-2:end) == 'img'
    [img_vol,vol_info] = octCirrusReader(filename);
    output.BScan = img_vol;
    %output.slo = slo;
    output.ScaleX= vol_info.vol_res(2);
    output.ScaleZ= vol_info.vol_res(1);
    output.NumBScans=size(img_vol,3);
    %     output.StartX = dot(1,2,:);
    %     output.EndX = dot(1,1,:);
    %     output.StartY = dot(1,4,:);
    %     output.EndY = dot(1,3,:);
    output.format = 'img';
    
    output.PID = vol_info.pid;
    output.SizeX = size(img_vol,2);
    output.SizeZ = size(img_vol,1);
    output.Distance = vol_info.vol_res(3);
    output.ExamTime = vol_info.scan_date;
    output.ScanPosition = vol_info.eye_side;
    output.ScanType = vol_info.scan_type;
    
    
    %             header.PID = vol_info.pid;
    %             header.SizeX = size(img_vol,2);
    %             header.NumBScans = ;
    %             header.SizeZ = size(img_vol,1);
    %             header.ScaleX = ;
    %             header.Distance = vol_info.vol_res(3);
    %             header.ScaleZ = ;
    %             header.ExamTime = vol_info.scan_date;
    %             header.ScanPosition = vol_info.eye_side;
    %             header.ScanType = vol_info.scan_type;
    

    

end
