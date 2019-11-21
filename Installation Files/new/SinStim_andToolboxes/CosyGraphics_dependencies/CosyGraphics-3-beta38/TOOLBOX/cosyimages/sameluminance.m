function C = sameluminance(C,BG)
% SAMELUMINANCE  Equalize luminance of images, or of a set of colors.
%    C = SAMELUMINANCE(C)  equalizes luminance of images matrices stored
%    in cell array C. Image matrices are M-by-N-by-P matrices, where P = 
%    1, 3 or 4, in the range 0 to 1. 
%
%    C = SAMELUMINANCE(C,BG)  ignores pixels defined by baground masks
%    (see BACKGROUNDMASK) contained in cell array BG.
%
%    RGB = SAMELUMINANCE(RGB)  equalizes luminances of colors contained
%    in the M-by-3 matrix of red-green-blue values, in the range 0 to 1,
%    "RGB".
%
%    Scientifical note: To be precise, what we actually equalize is the
%    "luma" (weigthed RGB values), which is only an approximate of the 
%    actual "luminance". This is fine for grayscale images if you've
%    corrected the gamma of your screen (otherwise it's meaningless.) 
%    On color images, even with gamma correction, the operation is only
%    an approximation.
%
%    Note 2: Errors can occur because of 
%
% See also: SAMEHUE, SAMESIZE.

% <TODO(?): Rewrite: Use NaNs to represent bg & use nanmean>


% Rec. 601 luma weigths. 
% Most standards and Image Processing Toolbox use this.
w = [0.299  0.587  0.114];

%    RGB = SAMELUMINANCE(RGB)
if nargin == 1 && isnumeric(C)
    RGBA = C; % <- in
    RGB = RGBA(:,1:3);
    m = size(RGB,1);
    wRGB = repmat(w,m,1) .* RGB;
    allLums = sum(wRGB')';
    meanLum = mean(allLums);
    RGB = RGB .* repmat(meanLum,m,3) ./ repmat(allLums,1,3);
    RGB = fitrange(RGB,[0 1],'rescale');
    RGBA(:,1:3) = RGB;
    C = RGBA; % -> out
    return %                    <===!!!
end

% Input Arg: BG
FG = cell(size(C));
if nargin >= 2
    for i = 1 : numel(BG);
        % Check matrices consistency
        if any(size(C{i}(:,:,1)) ~= size(BG{i}))
            error('Image matrix and background-mask matrix have inconsistent sizes.')
        end
        % BG -> FG
        FG{i} = ~BG{i};
    end
else % NaNs can represent backgrounds.
    for i = 1 : numel(C);
        FG{i} = ~isnan(C{i}(:,:,1));
    end
end

% Compute Mean Luminance
EveryMeanLuma = zeros(numel(C),1);
for i = 1 : numel(C)
    I = C{i};
    if ndims(I) < 3 % G (Grayscale 2D matrix)
        EveryMeanLuma(i) = mean(I(FG{i}));
    else           % RGB|RGBA
        R = I(:,:,1);
        G = I(:,:,2);
        B = I(:,:,3);
        m = [mean(R(FG{i})), mean(G(FG{i})), mean(B(FG{i}))];
        EveryMeanLuma(i) = w(1)*m(1) + w(2)*m(2) + w(3)*m(3);
    end
end
GeneralMeanLuma = mean(EveryMeanLuma);

% Equalize Luminances.
% We can exceed ceiling of 1, here. This will be corrected below.
EveryMax = zeros(numel(C),1);
for i = 1 : numel(C)
    I = C{i};
    fg = rep3(FG{i},size(I,3));
    I(fg) = I(fg) .* GeneralMeanLuma./EveryMeanLuma(i);
    EveryMax(i) = max(I(fg));
    C{i} = I;
end
GeneralMax = max(EveryMax);

% If we've exceeded range ceiling of 1.0: Loop again to correct this.
if GeneralMax > 1
    for i = 1 : numel(C)
        I = C{i};
        fg = rep3(FG{i},size(I,3));
        I(fg) = I(fg) ./ GeneralMax;
        I = fitrange(I,[0 1]); % just in case of rounding error.
        C{i} = I;
    end
end