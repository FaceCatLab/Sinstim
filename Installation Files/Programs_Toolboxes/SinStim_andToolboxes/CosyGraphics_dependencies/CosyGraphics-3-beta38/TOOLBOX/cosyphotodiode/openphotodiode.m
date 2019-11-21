function openphotodiode(Locations,SquareSize,isAutoSwitchOff);
% OPENPHOTODIODE  Initialize CosyGraphics for use of photodiodes in the screen's corners.
%    OPENPHOTODIODE(Locations,SquareSize)  sets CosyGraphics to display 1 to 4 photodiode squares in corners 
%    defined by the 'Location' matrix. 'Location' is a 2-by-2 square matrix of 0s and 1s. Each
%    element define the presence (1) or the absence (0) of a photodiode square in the corresponding
%    screen corner. 'SquareSize' is the size of the squares in pixels.
%
%    OPENPHOTODIODE(Locations,SquareSize,isAutoSwitchOff)  <TODO>
%
% Example:
%    openphotodiode([1 0; 0 0], 16)  initializes CosyGraphics to display one photodiode square of 16 pixels 
%    width in the upper-left corner on the screen.
%
% See also: SETPHOTODIODEVALUE, CLOSEPHOTODIODE.

global COSY_PHOTODIODE

COSY_PHOTODIODE.isPhotodiode = 1;


COSY_PHOTODIODE.Locations = logical(Locations); % [UL UR; BL BR]
COSY_PHOTODIODE.Values = [NaN NaN; NaN NaN]; % [UL UR; BL BR]
COSY_PHOTODIODE.Values(find(Locations)) = 0;

COSY_PHOTODIODE.SquareSize = SquareSize;
%COSY_PHOTODIODE.isAutoSwitchOff = isAutoSwitchOff;