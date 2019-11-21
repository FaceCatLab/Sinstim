function starteyelinkrecord()
% STARTEYELINKRECORD  Start data recording on EyeLink PC.
%    STARTEYELINKRECORD  starts recording ; record will be available later trough GETEYELINKFILE.
%
% See also: OPENEYELINK, STOPTEYELINKRECORD, GETEYELINKFILE.

global COSY_EYELINK

%% Start recording
if ~checkeyelink('isopen')
    error('No open link with eyelink tracker. Use openeyelink to open the connection.')
else
    if checkeyelink('isrecording')
        dispinfo(mfilename,'warning','EyeLink is already recording. Recording will be restarted')
    end
    dispinfo(mfilename,'info','Starting EyeLink recording...')
    
    Eyelink('StartRecording',1,1,1,1); % Start EL recording with all samples/events flags enabled.
    % ...about those flags, see: <psychtoolboxroot>\PsychHardware\EyelinkToolbox\EyelinkDemos\SR-ResearchDemo\change\change.m
    
    % Send info to EyeLink:
    str1 = ['[COSY] INFO: IS_EYELINK_CALIBRATED ' num2str(checkeyelink('iscalibrated'))];
    [w,h] = getscreensizecm;
    str2 = ['[COSY] INFO: ScreenSize(cm) ' num2str(w) ' ' num2str(h)];
    str3 = ['[COSY] INFO: ViewingDistance(cm) ' num2str(getviewingdistancecm)];
    sendeyelinkmessage(str1);
    sendeyelinkmessage(str2);
    sendeyelinkmessage(str3);
    
    wait(50); % Eyelink('StartRecording') has a delay of about 15 ms.    
    
    if ~checkeyelink('isdummy') && ~checkeyelink('isrecording')
        COSY_EYELINK.isRecording = 0;
        error('Failure to start recording.')
    else
        COSY_EYELINK.isRecording = 1;
        COSY_EYELINK.isFileRecorded = 1;
        COSY_EYELINK.isFileTransfered = 0;
    end
end

%% Eye used
EyeUsed = Eyelink('EyeAvailable'); % get eye that's tracked
if EyeUsed == COSY_EYELINK.EL.BINOCULAR; % if both eyes are tracked
    EyeUsed = COSY_EYELINK.EL.LEFT_EYE; % use left eye
end
COSY_EYELINK.EyeUsed = EyeUsed;