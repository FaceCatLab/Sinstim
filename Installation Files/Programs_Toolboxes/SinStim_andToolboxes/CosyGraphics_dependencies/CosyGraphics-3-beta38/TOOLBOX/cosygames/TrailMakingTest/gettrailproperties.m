function Prop = gettrailproperties
% GETTRAILPROPERTIES  Get current properties for TRAILMAKINGTEST.
%    Prop = GETTRAILPROPERTIES  returns current properties in structure Default.

global TRAINMAKING

%% Default Properties for TRAILMAKINGTEST 
%  Can be overwritten by TRAILMAKINGTEST's input args (!)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Default.ColormapFunction = @jet;
Default.ColorUnselected = .3 * [1 1 1];
Default.ColorInterior = .65 * [1 1 1];
Default.CircleDiameter = 45;
Default.FontSize = 16;
Default.LineWidth = 3;
Default.FontOffset = -4; % <TODO: calib font>
Default.WinningSoundFile = 'Tchoutchou3.mp3';
Default.LoosingSoundFile = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Init
if isempty(TRAINMAKING)
    TRAINMAKING = Default;
end

%% Output
Prop = TRAINMAKING;