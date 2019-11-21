function C = samesize(C,varargin)
% SAMESIZE  Equalize size of images.
%    C = SAMESIZE(C)  equalizes size of image matrices stored in cell array C 
%    by adding rows/columns of background color to the smallest. The function
%    uses BACKGROUNDMASK to extract the background color.
%
%    C = SAMESIZE(C,rgb)  adds rows/cols of given color, instead of using 
%    BACKGROUNDMASK to define the color automatically. "rgb" is a RGB triplet
%    or a RGBA quadruplet, in the range 0.0 to 1.0.
%
%    C = SAMESIZE(C,<rgb>,'VH')  precises where to add the rows and columns:
%    "V" stands for 'T' (Top), 'B' (Bottom) or 'C' (both: image on the Center);
%    "H" stands for 'L' (Left), 'R' (Right) or 'C' (both: image on the Center).
%    Default is 'CC'. "rgb" argument is optional.
%
%    C = SAMESIZE(C,<rgb>,VH,mn)  equalize row number to maximum width + m 
%    and column number to max heigth + n. "mn" is a 2 elements vector containing
%    the number of rows and columns to add. This option is usefull to avoid
%    border effects in further processing, especially to use BACGROUNDMASK with
%    the "Dilate" argument.
%
%    C = SAMESIZE(C,<rgb>,VH,mn,RoundTo)  rounds max width and heigth to even or 
%    odd number. "RoundTo" value can be 'even', 'odd' or ''.
%
% See also: SAMELUMINANCE, SAMEHUE.  <todo>
%
% Ben,  Nov. 2007   1.0
%       Nov. 2008   2.0

% Input Arg.
% C
if islogical(C{1}), error('Logical arrays not supported.'), end %<?>

% GivenBGColor
if ~isempty(varargin) && isnumeric(varargin{1})  %    C = SAMESIZE(C,rgb,...)
    GivenBGColor = varargin{1};
    varargin(1) = [];
end

% VH,mn,RoundTo
VH = 'CC';
mn = [0 0];
RoundTo = '';
try VH      = varargin{1}; end      %    C = SAMESIZE(C,VH)
try mn      = varargin{2}; end      %    C = SAMESIZE(C,VH,mn)
try RoundTo = varargin{3}; end      %    C = SAMESIZE(C,VH,mn,RoundTo)
if VH(1) == 'C', VH(1) = 'b'; end  % <todo: Check 1pix bug.>
if VH(2) == 'C', VH(2) = 'r'; end  % <todo: Check 1pix bug.>

% M,N: Maximum Heigth and Width
M = 0; % max heigth
N = 0; % max width
for j = 1 : size(C,2)
    for i = 1 : size(C,1)
        [m,n] = size(C{i,j}(:,:,1));
        M = max([M m]);
        N = max([N n]);
    end
end
% Add rows/cols
M = M + mn(1);
N = N + mn(2);
% Round to even/odd #
if strcmpi(RoundTo,'even')
    M = M + rem(M,2);
    N = N + rem(N,2);
elseif strcmpi(RoundTo,'odd')
    M = M + ~rem(M,2);
    N = N + ~rem(N,2);
end

% Resize Images
for i = 1 : numel(C)
    % <-
    I = C{i};
    
    % BG Color:
    if exist('GivenBGColor','var')
        bgcolor = GivenBGColor;
    else
        [BG,bgcolor] = backgroundmask(I);
    end
    bgcolor = reshape(bgcolor,[1 1 3]); % 2D -> 3D
    
    % V: Add rows:
    m = size(I,1);
    n = size(I,2);
    d = M - m; % difference with max.
    switch VH(1)
        case 'T'
            t = d;
            b = 0;
        case 'B'
            t = 0;
            b = d;
        case 't'
            t = ceil(d/2);
            b = floor(d/2);
        case 'b'
            t = floor(d/2);
            b = ceil(d/2);
    end
    I = [repmat(bgcolor,t,n); I; repmat(bgcolor,b,n)];
    
    % H: Add columns:
    m = size(I,1); % m has changed; n is the same.
    d = N - n;
    switch VH(2)
        case 'L'
            l = d;
            r = 0;
        case 'R'
            l = 0;
            r = d;
        case 'l'
            l = ceil(d/2);
            r = floor(d/2);
        case 'r'
            l = floor(d/2);
            r = ceil(d/2);
    end
    I = [repmat(bgcolor,m,l), I, repmat(bgcolor,m,r)];
    
    % ->
    C{i} = I;
end