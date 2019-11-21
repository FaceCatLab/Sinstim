function [x,y] = epitrochoid(N,Sxy,Er,Ealpha0,Edir,En,Mr,Malpha0,Mdir,Mn)
% EPITROCHOID  Compute an epitrochoidal trajectory (= like the moon around the sun).
%    [x,y] = EPITROCHOID(N,SunPos,...
%               EarthOrbitRadius,EarthAngle0,EarthDir,EarthPeriod,...
%               MoonOrbitRadius,MoonAngle0,MoonDir,MoonPeriod)
%       returns the x and y 1-by-N vectors of cartesian coordinates. 'N' is the number
%       of samples. '*Angle0' is the initial position in degrees. '*Dir' is the direction   
%       of movement and can be 1 or -1. '*Period' is the number of samples per rotation.
%
%    Example. Evaluate this to have a demo :
%       [x,y] = epitrochoid(365,[0 0],100,0,1,365,20,0,1,27); figure; plot(x,y);
%   
% Ben, Jan. 2008

Ealpha = Ealpha0 : Edir*360/En : Edir*360*(N-1)/En;
Malpha = Malpha0 : Mdir*360/Mn : Mdir*360*(N-1)/Mn;

Ealpha = fitrange(Ealpha,[0 360],'cyclic');
Malpha = fitrange(Malpha,[0 360],'cyclic');

Mxy = getthemoon(Sxy,Er,Ealpha,Mr,Malpha);

x = Mxy(:,1);
y = Mxy(:,2);