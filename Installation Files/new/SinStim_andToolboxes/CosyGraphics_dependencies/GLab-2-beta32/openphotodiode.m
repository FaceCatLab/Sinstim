function openphotodiode(Locations,SquareSize,isAutoSwitchOff);
% OPENPHOTODIODE  Initialize GLab for photodiode use.
%    OPENPHOTODIODE(Locations,SquareSize)  sets GLab to display 1 to 4 photodiode squares in corners 
%    defined by the 'Location' matrix. 'Location' is a 2-by-2 square matrix of 0s and 1s. Each
%    element define the presence (1) or the absence (0) of a photodiode square in the corresponding
%    screen corner. 'SquareSize' is the size of the squares in pixels.
%
%    OPENPHOTODIODE(Locations,SquareSize,isAutoSwitchOff)  <TODO>
%
% Example:
%    openphotodiode([1 0; 0 0], 16)  initializes GLab to display one photodiode square of 16 pixels 
%    width in the upper-left corner on the screen.
%
% See also: SETPHOTODIODEVALUE, CLOSEPHOTODIODE.

global GLAB_PHOTODIODE

GLAB_PHOTODIODE.isPhotodiode = 1;


GLAB_PHOTODIODE.Locations = logical(Locations); % [UL UR; BL BR]
GLAB_PHOTODIODE.Values = [NaN NaN; NaN NaN]; % [UL UR; BL BR]
GLAB_PHOTODIODE.Values(find(Locations)) = 0;

GLAB_PHOTODIODE.SquareSize = SquareSize;
%GLAB_PHOTODIODE.isAutoSwitchOff = isAutoSwitchOff;