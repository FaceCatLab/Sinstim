function squareaxes(hFig,hAx)
% SQUAREAXES  Make X width and Y eight equal.
%    SQUAREAXES(hFig,hAxes)  sets properties of axes of handle hAxes, in figure of
%    handle hFig, to get X width equal to Y eight, both on screen and in exported
%    image files.
%
% Example:  
%    squareaxes(gcf,gca);
%
% Ben, March 2011.

if nargin < 1, hFig = gcf; end
if nargin < 2, hAx  = gca; end

AxesUnitsOld = get(hAx,'Units');
set(hAx,'Units','norm')

PosFigInPaper = get(hFig,'PaperPosition');
PosAxInFig = get(hAx,'Position');

% Ax in Fig -> Ax in Paper
w = PosFigInPaper(3);
h = PosFigInPaper(4);
PosAxInPaper = [ ...
    PosFigInPaper(1) + w*PosAxInFig(1) ...
    PosFigInPaper(2) + h*PosAxInFig(2) ...
    w*PosAxInFig(3) ...
    h*PosAxInFig(4) ];

% rect -> square
if PosAxInPaper(3) > PosAxInPaper(4)
    PosAxInPaper(1) = PosAxInPaper(1) + (PosAxInPaper(3) - PosAxInPaper(4)) / 2;
    PosAxInPaper(3) = PosAxInPaper(4);
elseif PosAxInPaper(3) < PosAxInPaper(4)
    PosAxInPaper(2) = PosAxInPaper(2) + (PosAxInPaper(4) - PosAxInPaper(3)) / 2;
    PosAxInPaper(4) = PosAxInPaper(3);
end

% Ax in Paper -> Ax in Fig
x0 = (PosAxInPaper(1) - PosFigInPaper(1)) / PosFigInPaper(3);
y0 = (PosAxInPaper(2) - PosFigInPaper(2)) / PosFigInPaper(4);
w = PosAxInPaper(3) / PosFigInPaper(3);
h = PosAxInPaper(4) / PosFigInPaper(4);
PosAxInFig = [x0 y0 w h];

set(hAx,'Position',PosAxInFig);

set(hAx,'Units',AxesUnitsOld)