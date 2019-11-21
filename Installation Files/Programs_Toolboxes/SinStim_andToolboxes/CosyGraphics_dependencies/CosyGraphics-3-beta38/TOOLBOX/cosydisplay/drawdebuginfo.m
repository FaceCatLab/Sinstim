function drawdebuginfo(varargin)
% DRAWDEBUGINFO  Draw variables state for debugging purpose.
%    DRAWDEBUGINFO(VAR1,VAR2,...,VARN)  draws variables names and values in the backbuffer.


%% Params: Defaults values:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FontColor = [0 0 1];
FontSize = 12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Parse varargin

str = '';

for i = 1 : nargin
    name = inputname(i);
    if ischar(varargin{i})
        value = varargin{i};
    elseif isnumeric(varargin{i}) || islogical(varargin{i})
        value = num2str(varargin{i},3);
    end
        
    str = [str name ': ' value ',  '];
end
str(end-2:end) = [];


%% Draw
[w,h] = getscreenres;
xy = [0 -h/2+FontSize];

drawtext(str, 0, xy, 'Courier', FontSize, FontColor);
