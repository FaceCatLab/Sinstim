function b = checkeyelink(test)
% CHECKEYELINK  Check EyeLink status (and update CosyGraphics status is necessary). <FIXME: iscalibrated>
%    CHECKEYELINK('isopen')  true (1) if TCP/IP connection is correctly open on both sides 
%    (Matlab and EyeLink), false (0) otherwise.  It is the same than  ISOPEN('eyelink')
%
%    CHECKEYELINK('ispresent')  true if an EyeLink tracker is physically connected.
%
%    CHECKEYELINK('isconfigured')  returns 1 if network is connected and is properly configured 
%    for the EyeLink, returns 0 if network connected and improperly configured, returns
%    -1 if network cable has been unplugged (because IPCONFIG does not return the IP address in 
%    this case).
%
%    CHECKEYELINK('isdummy')  true if the EyelinkToolbox is initialized in dummy mode. (No
%    tracker physically present; a tracker is emulated for developpement purpose.)
%
%    CHECKEYELINK('iscalibrated')  true if calibration has been done.
%
%    CHECKEYELINK('isrecording')  true if EyeLink is present and recording.
%
%    Programmer note: This function is mainly a wrapper for the Eyelink() function, but it behaves
%    in a more robust fashion. (Eyelink() crashes in some cases.)
%
% See also: ISOPEN.


%% PROGRAMMER'S INFOS:
% 1) No EL
% Eyelink('IsConnected')          0
% Eyelink('initialize')           10065 
% Eyelink('CheckRecording')       crash!
% 
% 2) EL connected, Link Closed (never initialized)
% Eyelink('IsConnected')          0
% Eyelink('initialize')           0  (--> "TCP/IP Link Open")
% Eyelink('CheckRecording')       crash!
% Eyelink('StopRecording')        crash!
% 
% 3) EL connected, Link Open
% Eyelink('IsConnected')          1
% Eyelink('initialize')           0  + print 'EyeLink already initialized'  (do nothink)
% Eyelink('CheckRecording')       -1
% 
% 4a) EL connected, Link has been open, then EL has been restarted
% Eyelink('IsConnected')          0
% Eyelink('initialize')           0  + print 'EyeLink already initialized'  (do nothink !!!)
%     fix:  Eyelink('shutdown'); Eyelink('initialize');
% Eyelink('CheckRecording')       crash!
% 
% 4b) EL connected, Link has been open, then MATLAB has been restarted
% Eyelink('IsConnected')          0
% Eyelink('initialize')           0   no problem
% 
% 
% NB:
% Eyelink('Shutdown')  never crashes
% Eyelink('StartRecording')  if already started: restart recording (no crash)
% Eyelink('StopRecording')   if already stoped: no crash

%% Global var
global COSY_EYELINK % This var gives us Matlab's status, while Eyelink('*') gives us EL's status

%% Init COSY_EYELINK var
if isempty(COSY_EYELINK)
    COSY_EYELINK.isOpen = 0;
    COSY_EYELINK.isDummy = 0;
    COSY_EYELINK.isCalibrated = 0;
    COSY_EYELINK.isRecording = 0;
end

%% TEST
switch test
    case 'ispresent'
        if     COSY_EYELINK.isOpen && ~COSY_EYELINK.isDummy
            b = Eyelink('IsConnected');
            if b == 0
                COSY_EYELINK.isOpen = b;
                b = checkeyelink('ispresent');
            end
        elseif COSY_EYELINK.isOpen && COSY_EYELINK.isDummy;
            b = 0;    
        elseif ~COSY_EYELINK.isOpen
            ini = Eyelink('initialize');
            if ini == 0
                b = 1;
                Eyelink('Shutdown')
            elseif checkeyelink('isconfigured') > 0
                b = 0;
                dispinfo(mfilename,'error','Network connection seems not configured to connect to EyeLink.')
                dispinfo(mfilename,'error','Network settings should be: IP address: 100.1.1.2, Subnet mask: 255.255.255.0')
            elseif checkeyelink('isconfigured') == -1
                b = 0;
                dispinfo(mfilename,'error','Network cable unplugged.')
            elseif ini == 10065
                b = 0;
                dispinfo(mfilename,'error','No EyeLink connected.')
            elseif ini == -201
                b = 0;
                dispinfo(mfilename,'error','EyeLink connection problem: CABLE FAULT.');
            else
                b = 0;
                dispinfo(mfilename,'error',...
                    ['EyeLink unknown connection problem. Error code = ' num2str(ini) '.']);
            end
        end

    case 'isconfigured'
        if ispc, [s,str] = dos('ipconfig');
        else     [s,str] = unix('ifconfig');
        end
        b = ~isempty(strfind(str,'100.1.1.2')) && ~isempty(strfind(str,'255.255.255.0'));
        % IPCONGIG does not return IP address when cable has been unplugged. Return -1 in this case.
        if ispc && ~b
            if ~isempty(strfind(str,'Média déconnecté')) || ~isempty(strfind(str,'Media disconnected'))
                b = -1;
            end
        end
        
    case 'isopen'
        b = COSY_EYELINK.isOpen && Eyelink('IsConnected');
        COSY_EYELINK.isOpen = b;
        
    case 'isdummy'
        b = COSY_EYELINK.isDummy;
        
    case 'iscalibrated'  %<v3-beta11: rewritten.>
        try     b = COSY_EYELINK.isCalibrated;
        catch   b = false;  % will be false negative in case matlab has been restarted <FIXME>
        end
        
    case 'isrecording'
        if checkeyelink('isopen')
            status = Eyelink('CheckRecording');
            if vcmp('3.10','<=','3.10') % Bug in EyeLink CL 3.10 (Marcus' lab): record flag is inverted !!!
                status = ~status; 
            end
            if status
                b = 1;
            elseif checkeyelink('isdummy') && COSY_EYELINK.isRecording
                b = 1;
            else
                b = 0;
            end
        else
            b = 0;
        end
        COSY_EYELINK.isRecording = b;
        
    otherwise
        error(['Unknown argument: ''' test '''.'])
        
end
