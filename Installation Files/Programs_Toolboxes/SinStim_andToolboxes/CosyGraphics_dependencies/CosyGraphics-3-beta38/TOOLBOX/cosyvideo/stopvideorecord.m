function stopvideorecord
% STOPVIDEORECORD  Stop video recording mode. <Obsolete: Use SETVIDEORECORD ON>
%
%    Ben J., Oct 2012.

global COSY_VIDEO

COSY_VIDEO.isRecording = false;