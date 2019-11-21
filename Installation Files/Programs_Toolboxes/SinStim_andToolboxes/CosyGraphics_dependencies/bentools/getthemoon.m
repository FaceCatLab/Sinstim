function [Exy,Mxy] = getthemoon(Sxy,Er,Ealpha,Mr,Malpha)
% GETTHEMOON  Cartesian position of an object on an epitrochoidal trajectory (like the moon around the sun).
%    EarthPos = GETTHEMOON(SunPos,EarthOrbitRadius,EarthAngularPos)
%    MoonPos = GETTHEMOON(SunPos,EarthOrbitRadius,EarthAngularPos,MoonOrbitRadius,MoonAngularPos)
%    [EarthPos,MoonPos] = ORBIT(SunPos,EarthOrbitRadius,EarthAngularPos,MoonOrbitRadius,MoonAngularPos)
%   
% Ben, Jan. 2008


% Input Arg.

Sxy = repmat(Sxy,length(Ealpha),1);

Ealpha = Ealpha(:);
Malpha = Malpha(:);

Ealpha = Ealpha * pi / 180;
Malpha = Malpha * pi / 180;


% Get the Moon !

Exy = Sxy + Er * [cos(Ealpha) sin(Ealpha)];
Mxy = Exy + Mr * [cos(Malpha) sin(Malpha)];


% Output Arg.

if nargin >= 5 && nargout < 2, Exy = Mxy; end