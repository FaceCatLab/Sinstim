function [beampos,TimeFromOnset,isVBL,VBLStartline,VBLEndline] = getbeamposition
% GETBEAMPOSITION  <alpha stage>

% Get pos
info = Screen('GetWindowInfo', gcw);

beampos = info.Beamposition;

VBLStartline = info.VBLStartline;
VBLEndline = info.VBLEndline;

% lines -> ms
oneframe = getframedur;
nLines = VBLEndline + 1; % count from 0

if beampos < VBLStartline
    isVBL = false;
    TimeFromOnset = beampos * oneframe / nLines;
else
    isVBL = true;
    TimeFromOnset = (beampos-nLines) * oneframe / nLines;
end