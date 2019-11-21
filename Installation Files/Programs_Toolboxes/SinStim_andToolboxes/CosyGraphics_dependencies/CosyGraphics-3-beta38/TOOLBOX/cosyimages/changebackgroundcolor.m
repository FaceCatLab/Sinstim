function I = changebackgroundcolor(I,BG,color)
% CHANGEBACKGROUNDCOLOR  Change background color of image(s).
%    I = CHANGEBACKGROUNDCOLOR(I,BG,color)  Change background of image matrix I,
%    as defined by background mask BG (see BACKGROUNDMASK) to given color.
%    I and BG can also be cell arrays containing image matrices and 
%    corresponding background masks.
%
% See also BACKGROUNDMASK, ADDBACKGROUNDALPHA.

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