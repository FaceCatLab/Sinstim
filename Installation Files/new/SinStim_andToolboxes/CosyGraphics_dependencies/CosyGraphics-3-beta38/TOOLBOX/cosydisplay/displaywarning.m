function err = displaywarning(str)
% DISPLAYWARNING  Display warning message in CosyGraphics screen.
%    DISPLAYWARNING(String)

%%%%%%%%%%%%%%%%%%%%%%%%%
TimeOut = 20000; % 20s
%%%%%%%%%%%%%%%%%%%%%%%%%

beep;

if ~iscell(str), str = {str}; end
str = [{'=== WARNING ==='; ''}; str];

k = displaymessage(str,[.9 .4 0],[1 1 1],...
	'continue','Enter','quit CosyGraphics','Escape',TimeOut);

if k == getkeynumber('Escape'), err = 1;
else                            err = 0;
end