function XY = loadtrail(filename,i)
% LOADTRAIL  Load coordinates of a trail from file. <unfinished>
%    XY = LOADTRAIL(FILENAME,i)  

M = dlmread(filename);
XY = zeros(size(M,1),2);
XY = M(:,2*i-1:2*i) - 300;