function [nx, ny]=GetContourNormals2D(P)
a=1;

% From array to separate x,y
xt=P(:,1); 
yt=P(:,2);

% Derivatives of contour
n=length(xt);

f=(1:n)+a; 
f(n)=f(n-1);

b=(1:n)-a; 
b(1)=b(2);

dx=xt(f)-xt(b);
dy=yt(f)-yt(b);

% Normals of contourpoints
l=sqrt(dx.^2+dy.^2);
nx = -dy./l;
ny = dx./l;
