function settransparency(varargin)
% SETTRANSPARENCY  Set color dedicated to transparency. <unfinished> <obsolete>
%    A color can be "sacrified" to represent transparency in offscreen buffers
%    of the graphics memory (or VRAM). In Matlab's image matrices (which are in
%    central memory, or RAM), transparency can be represented by the same color
%    or by NaNs. We recommand the use of NaNs.
%
%    SETTRANSPARENCY(color)  defines 'color' as the color used for all offscreen
%    buffers to represent transparency (unless another color is specified for a
%    particular buffer, see below).
%
%    'color' value can be:
%    
% 			'k'  or  [0 0 0]	selects black
% 			'r'  or  [1 0 0]	selects maximum red
% 			'g'  or  [0 1 0]	selects maximum green
% 			'y'  or  [1 1 0]	selects maximum yellow
% 			'b'  or  [0 0 1]	selects maximum blue
% 			'm'  or  [1 0 1]	selects maximum magenta
% 			'c'  or  [0 1 1]	selects maximum cyan
% 			'w'  or  [1 1 1]	selects maximum white
%			'none' or '' or []	disables transparency.
%
%    SETTRANSPARENCY(buff,color)  defines transparency for buffer number 'buff' only.