function starteyelinkrecord()
% STARTEYELINKRECORD  Start data recording.
%    STARTEYELINKRECORD  starts recording. Record will be available later trough GETEYELINKFILE.

global GLAB_EYELINK

%% Start recording
if ~checkeyelink('isopen')
    error('No open link with eyelink tracker. Use openeyelink to open the connection.')
else
    if checkeyelink('isrecording')
        dispinfo(mfilename,'warning','EyeLink is already recording. Recording will be restarted')
    end
    dispinfo(mfilename,'info','Starting EyeLink recording...')
    Eyelink('StartRecording');
    wait(50); % Eyelink('StartRecording') has a delay of about 15 ms.
    if ~checkeyelink('isdummy') && ~checkeyelink('isrecording')
        GLAB_EYELINK.isRecording = 0;
        error('Failure to start recording.')
    else
        GLAB_EYELINK.isRecording = 1;
        GLAB_EYELINK.isFileRecorded = 1;
        GLAB_EYELINK.isFileTransfered = 0;
    end
end

%% Eye used
EyeUsed = Eyelink('EyeAvailable'); % get eye that's tracked
if EyeUsed == GLAB_EYELINK.EL.BINOCULAR; % if both eyes are tracked
    EyeUsed = GLAB_EYELINK.EL.LEFT_EYE; % use left eye
end
GLAB_EYELINK.EyeUsed = EyeUsed;