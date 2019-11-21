function closesound
% CLOSESOUND  Close Sound.
%
% See also OPENSOUND, STOPCOSY.

global COSY_SOUND cogent 

%% PTB
if isfield(COSY_SOUND,'PTB') && isfield(COSY_SOUND.PTB,'pahandle')
    try       PsychPortAudio Close;  % close all sound devices if any.
    catch     %(do nothing)
    end
    if isfield(COSY_SOUND,'PTB') && isfield(COSY_SOUND.PTB,'pahandle') && ~isempty(COSY_SOUND.PTB.pahandle)
        pahandle = COSY_SOUND.PTB.pahandle;
        COSY_SOUND.PTB.pahandle = []; % remove first: if PsychPortAudio('Close') craches because of invalid handle, function will re-run smoothly
        dispinfo(mfilename,'info','PTB sound closed.');
    end
end

%% Cog
if isfield(cogent,'sound')                        % 
    cogsound('shutdown');
%     cogcapture('shutdown'); %<v2-beta33: no more used in opensound.>
    cogent = rmfield(cogent,'sound'); %<v1.6.2: needed by SETPRIORITY('OPTIMAL')>
    dispinfo(mfilename,'info','Cogent sound closed.')
end

%% Update global var  %<v3beta13: rewritten>
if isfield(COSY_SOUND,'isOpen') && COSY_SOUND.isOpen  
    COSY_SOUND.isOpen = false;
    COSY_SOUND.OpenBuffers = [];
else
    COSY_SOUND.isOpen = false;
end