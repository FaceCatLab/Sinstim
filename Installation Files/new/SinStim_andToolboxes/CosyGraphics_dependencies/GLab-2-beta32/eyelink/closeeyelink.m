function closeeyelink
% CLOSEEYELINK  Close Eyelink connection.
%    CLOSEEYELINK  stops record (if recording) and close connection (if open). If no Eyelink
%    connection is open, does nothing. 

global GLAB_EYELINK

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
    if GLAB_EYELINK.isFileRecorded
        geteyelinkfile;
    end
    Eyelink('ShutDown');
end

%% Update global var
if ~isempty(GLAB_EYELINK)
    GLAB_EYELINK.isOpen = 0;
    GLAB_EYELINK.isDummy = 0;
    GLAB_EYELINK.isRecording = 0;
end
