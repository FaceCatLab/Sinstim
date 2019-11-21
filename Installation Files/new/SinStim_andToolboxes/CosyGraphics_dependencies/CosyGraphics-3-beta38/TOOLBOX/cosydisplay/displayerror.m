function err = displayerror(str)
% DISPLAYERROR  Display error message in CosyGraphics screen.
%    DISPLAYERROR(String)

%%%%%%%%%%%%%%%%%%%%%%%%%%
TimeOut = 120000; % 120s
%%%%%%%%%%%%%%%%%%%%%%%%%%

beep;


if ~iscell(str), str = {str}; end
str = [{'!!! === ERROR === !!!'; ''}; str];

k = displaymessage(str,[.9 0 0],[1 1 0],...
	'abort','Escape','continue anyway','Enter');

if k == getkeynumber('Escape'), err = 1;
else                            err = 0;
end