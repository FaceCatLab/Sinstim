function i = getframecount
% GETFRAMECOUNT  Index of current physical screen frames since trial start.
%    GETFRAMECOUNT  returns frame number, counting from first frame of trial. (I.e.: first frame
%    displayed after the STARTTRIAL call = frame #1). What we count here is physical screen's  
%    frames (but missed frames are not counted), if you want the count of display flips,
%    see GETDISPLAYCOUNT. E.g.: if you displayed two images for 500ms each at 100Hz, we count
%    100 "frames" and 2 "displays". Note that missed frames are not counted. If you want an 
%    estimate of the number of one-frame intervals physically elapsed, use GETCYCLECOUNT.
%
% See also: STARTTRIAL, GETDISPLAYCOUNT, GETCYCLECOUNT.

global COSY_TRIALLOG

if COSY_TRIALLOG.isStarted
    i = COSY_TRIALLOG.iFrame;
else
    i = 0;
end