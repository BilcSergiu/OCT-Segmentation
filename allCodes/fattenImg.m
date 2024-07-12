function [imgPad,refpt]=fattenImg(imgPad,pathX)

%select the reference point excludeing the two points at the 1st and last columns.
refpt = max(pathX(2:end-1)); 

% drag each column down to the x position of reference point excludeing the 1st and last columns
for j = 1 : size(imgPad,2)
   imgPad(:,j) = circshift(imgPad(:,j), refpt-pathX(j));
%    imgPad(1:refpot-row(j),j)=0;
end