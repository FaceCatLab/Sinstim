function startvideorecord
% STARTVIDEORECORD  Activate video recording mode. <Obsolete: Use SETVIDEORECORD ON>
%    STARTVIDEORECORD  turns on video recording mode : all images diplayed by DISPLAYBUFFER will
%    now be capured, untill video recording mode is turned off by STOPVIDEORECORD.  Images can
%    then be saved as a video file by SAVEVIDEORECORD.  Sounds are not recorded.
%
%    See also STOPVIDEORECORD, SAVEVIDEORECORD.
%
%    Ben J., Oct 2012.

global COSY_VIDEO

if iscog
    stopcogent;
    error('Video recording mode only supported over PsychToolBox. Start CosyGraphics with STARTPSYCH in place of STARCOGENT.')
end

COSY_VIDEO.isRecording = true;
COSY_VIDEO.iDisplay = 0;
COSY_VIDEO.RecordedImages = {};
COSY_VIDEO.DisplayDuration = [];  %<TODO: preallocate?>