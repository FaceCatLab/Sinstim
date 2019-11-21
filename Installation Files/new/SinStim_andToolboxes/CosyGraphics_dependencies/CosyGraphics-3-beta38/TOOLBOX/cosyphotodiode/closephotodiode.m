function closephotodiode
% CLOSEPHOTODIODE  End display of photodiode squares.
%    CLOSEPHOTODIODE
%
% See also: OPENPHOTODIODE.

global COSY_PHOTODIODE

COSY_PHOTODIODE = [];
COSY_PHOTODIODE.isPhotodiode = 0;