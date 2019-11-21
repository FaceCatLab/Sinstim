function varargout = buffersize(B,dim)
% BUFFERSIZE   Size of an offscreen buffer. {fast}
%    wh = BUFFERSIZE(b)  returns vector 'wh' containing the width and heigth, 
%    in pixels, of buffer b.
%
%    [w,h] = BUFFERSIZE(b)  returns width and height as separate output
%    variables. 'b' can be a buffer handle or an array of buffer handles.
%
%    w = BUFFERSIZE(B,1)  returns the width.
%
%    h = BUFFERSIZE(B,2)  returns the height.
%
%    !!! ---  Note that we don't use standard Matlab convention: Matlab's  
%    SIZE function returns height (number of rows) first and width (number
%    of columns) in second. We do the reverse!  --- !!!
%
% See also IMAGESIZE, NEWBUFFER.

% Ben, 
%   v1      Sept 2007.
%   v2      June 2009.      B can be an array.

if (nargin == 1 && nargout <= 1) && numel(B) > 1
    error(['If input argument B is an array, use any of these syntaxes:' 10 ...
        '[W,H] = buffersize(B)' 10 'W = BUFFERSIZE(B,1)' 10 'H = BUFFERSIZE(B,2)'])
end

%% B -> bb
bb = unique(B);
bb = bb(~isnan(bb)); % <Fix 28/07/2009: Remove NaNs, because all NaNs are "uniques"!>
ww = zeros(size(bb));
hh = zeros(size(bb));

%% Get heigths and widths
for i = 1 : length(bb)
    b = bb(i);
    
    if isnan(b)
        w = NaN;
        h = NaN;

    elseif iscog % CG
        if b
            S = cggetdata('SPR',b);
            w = S.Width;
            h = S.Height;
        else % buffer 0 : "cggetdata('SPR',0)" crashes.
            w = getscreenres(1);
            h = getscreenres(2);
        end

    else     % PTB
        if ~b, b = gcw; end
        [w,h] = Screen('WindowSize',b);
        
    end
    
    ww(i) = w;
    hh(i) = h;
    
end

%% bb -> B
W = zeros(size(B));
H = zeros(size(B));
for i = 1 : length(bb)
    W(B==bb(i)) = ww(i);
    H(B==bb(i)) = hh(i);
end

%% Output Args
if nargout == 2
	varargout{1} = W;
	varargout{2} = H;
else
    switch nargin
        case 1
            varargout{1} = [w h];
            
        case 2
            if dim == 1
                varargout{1} = W;
            elseif dim == 2
                varargout{1} = H;
            else
                error('Bad value for the ''dim'' argument.')
            end
    end
end