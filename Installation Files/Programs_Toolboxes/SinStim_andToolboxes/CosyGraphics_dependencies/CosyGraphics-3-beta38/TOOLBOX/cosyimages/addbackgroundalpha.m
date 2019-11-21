function [I,BG] = addbackgroundalpha(I,varargin)
% ADDBACKGROUNDALPHA  Add alpha layer with background transparent to RGB image(s). (PTB-only)
%    I = ADDBACKGROUNDALPHA(I, <bgcolor,> <err,> <Erode,> <FillHoles>)  adds to image(s) I an alpha
%    layer with value 0 for background pixels and 1 for foreground pixels.  I is an image matrix or 
%    a cell array containing image matrices.  Other arguments are the same than for BACKGROUNDMASK.
%    See " help backgroundmask " for more infos.
%
%    [I,ALPHA] = ADDBACKGROUNDALPHA(I,...)  returns also the alpha matrix(-ces) in a separate 
%    argument. If I is a matrix, ALPHA is also a matrix, if I is a cell array, ALPHA is also a cell
%    array.
%
% See also CHANGEBACKGROUNDCOLOR, BACKGROUNDMASK.
%
% Ben, Jun 2011.


%% MAIN
BG = backgroundmask(I, varargin{:});

if isnumeric(I) || islogical(I)
    I = addalpha(I, BG);
elseif iscell(I)
    for i = 1 : numel(I)
        I{i} = addalpha(I{i}, BG{i});
    end
else
    error(['Invalid class for argument I: ' c '.'])
end


%% SUB-FUNCTION: ADDALPHA
% ADDALPHA(I,BG)  Add alpha layer ~BG to matrix I.
function I = addalpha(I,BG)
% BG -> A
A = ~BG;

% What's range? 0-1 or 0-255?
c = class(I);
if strcmp(c(1:3),'int')
    range = 255;
elseif strcmp(c,'double') || strcmp(c,'single')
    if any(I > 1.00001) % greater than one + eventual rounding error
        range = 255;
    else
        range = 1;
    end
elseif strcmp(c,'logical')
    range = 1;
else
    error(['Unsuported data class: ' c '.'])
end

% Multiply A by range:
v = version;
if v(1) <= '6'
    A = double(A) .* range;
else
    A = A .* range;
end
% A = class(A,c);

% Add layer:
I(:,:,end+1) = A;