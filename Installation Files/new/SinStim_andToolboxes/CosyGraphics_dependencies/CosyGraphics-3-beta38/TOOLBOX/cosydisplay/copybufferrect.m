function copybufferrect(b0,b1,rect0,rect1)
% COPYBUFFERRECT  Copy a rectangular area from an offscrren buffer to another <BROKEN!> <FIXME: coord bug!>
% Copy a rectangle of pixel values from an offscreen buffer to another.
%	COPYBUFFERRECT(b0,b1,rect)  copies the rectangle 'rect'  
%	in the source buffer b0 to the same position in the target buffer b1.
%	'rect' is a vector of the form [x0 y0 x1 y1] or of the form [x0 y1 x1 y0].
%   See HELP DRAWRECT for more info.
%<TODO: 'pos' -> 'rect'>
%
%	COPYBUFFERRECT(b0,b1,rect,xy)  copies the rectangle 'rect' at the 'xy' position
%   in target buffer.
%
%   COPYBUFFERRECT(b0,b1,rect0,rect1)  copies the rectangle rect0 in buffer b0
%   to rect1 in buffer b1. 'rect0' and 'rect1' are vector of the form 
%   [x0 y0 x1 y1] or [x0 y1 x1 y0].  See " help drawrect " for more info.

%	w and h can be omitted in 'pos_in_target'.
%
%   See also COPYBUFFER, DRAWRECT.
%
% Ben, 	Sep 2007
% 		Oct 2008: 'Pos' -> 'rect' argument. <unfinished>
%       Nov 2010: Finish Oct2008 job! ;-)

%	COPYBUFFERRECT(sourcebuffer,targetbuffer,pos)  Copy the rectangle at the position 'pos'
%	in the source buffer to the same position in the target buffer. 'pos' is a vector
%	of the form [x y w h], where x, y are coord. of the lower/left corner of the                   ???
%   rectangle and w, h are it's width and heigth.
%
%   COPYBUFFERRECT(sourcebuffer,targetbuffer,pos_in_source,pos_in_target)  Copy the rectangle   
%   from the position 'pos_in_source' to the position 'pos_in_target' in target buffer.
%	w and h can be omitted in 'pos_in_target'.

%% Input args
if nargin < 4               %	COPYBUFFERRECT(b0,b1,rect)
	rect1 = rect0;
elseif length(rect1) == 2   %	COPYBUFFERRECT(b0,b1,rect,xy)
	rect1(3:4) = rect0(3:4);
end

%% Copy rect
% cgblitsprite(b0,x0,y0,w0,h0,x1,y1,<w1>,<h1>));
cgsetsprite(b1);
if rect0(3) == rect0(4) & rect1(3) == rect1(4)
	cgblitsprite(b0,rect0(1),rect0(2),rect0(3),rect0(4),rect1(1),rect1(2));
else
	cgblitsprite(b0,rect0(1),rect0(2),rect0(3),rect0(4),rect1(1),rect1(2),rect1(3),rect1(4));
end
