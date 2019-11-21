function ms = geteyelinktime
% GETEYELINKTIME  Time difference between the tracker time and display PC time.
%    t = GETEYELINKTIME  returns a timestamp (in msec) from the EyeLink PC's clock. 
%
% Example:
%    t = geteyelinktimeoffset + geteyelinktime; % should return the same value than t = time;
%
% See also: GETEYELINKTIMEOFFSET.

ms = Eyelink('TrackerTime') * 1000;