function I = changebackground(I,BG,color)
% CHANGEBACKGROUND  Change background color of an image matrix.
%    I = CHANGEBACKGROUND(I,BG,color)  Change background of image matrix I,
%    as defined by background mask BG (see BACKGROUNDMASK) to given color.
%    I and BG can also be cell arrays containing image matrices and 
%    corresponding background masks.

if ~iscell(I)
    I = {I};
    BG = {BG};
    isCell = 0;
else
    isCell = 1;
end

for i = 1 : length(I)
    for k = 1 : size(I{i},3)
        M = I{i}(:,:,k);
        M(BG{i}) = color(k);
        I{i}(:,:,k) = M;
    end
end

if ~isCell
    I = I{1};
    BG = BG{1};
end