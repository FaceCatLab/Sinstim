function varargout = getscreenres(dim);
% GETSCREENRES  Get resolution of G-Lab display.
%	 res = GETSCREENRES  returns a vector 'res' of the form [width height].
%    [w,h] = GETSCREENRES returns width and height in two separate variables.
%	 w = GETSCREENRES(1)  returns width.
%	 h = GETSCREENRES(2)  returns height.
%    [X0,Y0,X1,Y1] = GETSCREENRES  returns limits of the X and Y axes.
%		e.g: @800x600, X0 = -400, Y0 = -299, X1 = 399, Y1 = 300.
%
% See also GETSCREENXLIM, GETSCREENYLIM, GETFRAMEDUR.
%
% Ben, Oct 2007


global GLAB_DISPLAY


if isempty(GLAB_DISPLAY) % <2-beta23>
    error('Display has not been open.')
end


%% Get values 
% <2-beta21: Suppr. because doesn't work after GLab stop.>
% if iscog % CG
%     S = cggetdata('GSD');
%     d(1) = S.ScreenWidth;
%     d(2) = S.ScreenHeight;
% else % PTB
%     rect = Screen('rect',gcw);
%     d = rect(3:4);
% end

d = GLAB_DISPLAY.Resolution;  % <2-beta21>
 
 
%% Output Args
if nargout < 4
	if nargin
		varargout{1} = d(dim);
	elseif nargout == 2
		varargout{1} = d(1);
		varargout{2} = d(2);
	else
		varargout{1} = d;
	end
elseif nargout == 4
	% TODO: Generalize this.
	x0 = -S.ScreenWidth  / 2; 
	y0 = -S.ScreenHeight / 2 + 1;
	x1 =  S.ScreenWidth  / 2 - 1;
	y1 =  S.ScreenHeight / 2;
	varargout = {x0,y0,x1,y1};
end