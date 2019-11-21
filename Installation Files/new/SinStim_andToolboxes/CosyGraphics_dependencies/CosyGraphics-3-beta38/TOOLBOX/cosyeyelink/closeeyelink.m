function closeeyelink
% CLOSEEYELINK  Close Eyelink connection.
%    CLOSEEYELINK  stops record (if recording) and close connection (if open). If no Eyelink
%    connection is open, does nothing. 

global COSY_EYELINK

%% Get current tracker status
isOpen = checkeyelink('isopen');
isDummy = checkeyelink('isdummy');
if isOpen && ~isDummy
    isRecording = checkeyelink('isrecording');
else
    isRecording = 0;
end

%% Stop recording and close connection
if isRecording % Do not use Eyelink('CheckRecording') because it crashes if eye
    stopeyelinkrecord;
end
if isOpen
    if COSY_EYELINK.isFileRecorded
        geteyelinkfile;
    end
    Eyelink('ShutDown');
    dispinfo(mfilename,'info','EyeLink connection closed.')  %<!v2-beta55>"
    disp(' ')
end

%% Update global var
if ~isempty(COSY_EYELINK)
    COSY_EYELINK.isOpen = 0;
    COSY_EYELINK.isDummy = 0;
    COSY_EYELINK.isRecording = 0;
end