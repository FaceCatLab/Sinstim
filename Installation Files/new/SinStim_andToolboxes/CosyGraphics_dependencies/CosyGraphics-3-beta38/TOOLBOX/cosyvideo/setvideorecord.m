function setvideorecord(Mode)
% SETVIDEORECORD  Activate video recording mode. <Obsolete: Use SETVIDEORECORD ON>
%    SETVIDEORECORD ON  turns video recording mode on : all images diplayed by DISPLAYBUFFER from
%    STARTTRIAL to STOPTRIAL will now be capured.  After trial, images can be saved as a video file 
%    by SAVEVIDEORECORD.  Sounds are not recorded.
%
%    SETVIDEORECORD OFF  turns video recording mode off.
%
% Example:
%    for tr = 1 : NbOfTrials
%       setvideorecord on
%       starttrial
%       ...
%       stoptrial
%       setvideorecord off
%       savevideorecord([video)
%
% See also SAVEVIDEORECORD.
%
% Ben, Nov 2012.

global COSY_VIDEO

switch upper(Mode)
    case 'ON'
        if iscog
            stopcogent;
            error('Video recording mode only supported over PsychToolBox. Start CosyGraphics with STARTPSYCH in place of STARCOGENT.')
        end
        
        if ~isfield(COSY_VIDEO,'RecordedImages') % If called for the first time..
            if ~exist('mmwrite','file')
                if isopen('display'), stopcosy; end
                msg = ['Missing dependency:  Cannot find mmwrite in Matlab''s path.' 10 ...
                    'mmwrite is a third party tool that CosyGraphics needs to write video files ; you can find it there:' 10 10 ...
                    '    http://www.mathworks.com/matlabcentral/fileexchange/15881-mmwrite' ];
                error(msg);
            end
        end

        COSY_VIDEO.isRecording = true;
        COSY_VIDEO.iDisplay = 0;
        COSY_VIDEO.RecordedImages = {};
        COSY_VIDEO.DisplayDuration = [];  %<TODO: preallocate?>
        
    case 'OFF'
        COSY_VIDEO.isRecording = false;
        
end