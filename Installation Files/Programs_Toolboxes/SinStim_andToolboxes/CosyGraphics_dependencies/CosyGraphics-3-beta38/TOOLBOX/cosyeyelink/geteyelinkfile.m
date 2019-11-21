function status = geteyelinkfile(DestDir,EdfFile)
% GETEYELINKFILE  Get last EDF file from EyeLink computer.
%    This function must be called before that connection to EyeLink is closed, i.e;: before call
%    to STOPCOSY or CLOSEEYELINK.
%
%    STATUS = GETEYELINKFILE(DIRNAME,FILENAME)  gets a custom EDF file.  File extension must be '.edf'.
%    Returns file size if OK, 0 if file transfer was cancelled, negative if error.
%
%    STATUS = GETEYELINKFILE  gets last 'ACTIVE.EDF' file from the EyeLink computer and write it
%    in '<cosygraphicstmp>\active.edf'.  NB: On the EyeLink PC side, the system is supposed 
%    to have been configured to use 'ACTIVE.EDF' as file name. (This is our COSY convention,
%    it's not a factory default.)

%% Deprecated syntax: <v3-beta6: Ask AlexZ if used.>
%    GETEYELINKFILE(DIRNAME)  writes 'ACTIVE.EDF' file in DESTDIR directory.


global COSY_EYELINK


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constant
FILE_NAME_ON_EL_PC = 'ACTIVE.EDF';

%%  Input Arg Defaults
if nargin < 1, DestDir = cosydir('tmp'); end
if nargin < 2, EdfFile = 'active.edf'; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check EyeLink status
if ~checkeyelink('isrecording')
    stopeyelinkrecord;
end
% if ~checkeyelink('isopen')
%     openeyelink;
%     wasOpen = 0;
% else
%     wasOpen = 1;
% end

%% OpenFile
err = Eyelink('OpenFile','filename');
if err
    dispinfo(mfilename,'error','Cannot open EyeLink data file on EyeLink PC.'); 
    return % <===!!!
end

%% Eyelink('ReceiveFile') documentation:  
% [status =] Eyelink('ReceiveFile',['filename'], ['dest'], ['dest_is_path'])
%  If <src> is omitted, tracker will send last opened data file.
%  If <dest> is omitted, creates local file with source file name.
%  Else, creates file using <dest> as name.  If <dest_is_path> is supplied and
% non-zero
%  uses source file name but adds <dest> as directory path.
%  returns: file size if OK, 0 if file transfer was cancelled [see below], negative =  error
% code

% <Bug on EyeLink 3.10 !!!: returns 0 instead of file size.>

%% ReceiveFile
fprintf('\n')
% dispinfo(mfilename,'info','Tranfering eye data file from EyeLink PC...');
fprintf('Tranfering eye data file from EyeLink PC...');
status = Eyelink('ReceiveFile', FILE_NAME_ON_EL_PC, DestDir, 1);
if status < 0
    dispinfo(mfilename,'error','Error while receiving file !'); 
    error('Error while receiving file.');
    COSY_EYELINK.isFileTransfered = false;
elseif status >= 0  % <v3-beta28: Bug on EyeLink 3.10 !!!: returns 0 instead of file size: use ">=" in pace of ">">
    dispinfo(mfilename,'info',['File succesfully transfered to "' fullfile(DestDir,EdfFile) '".'])
    if ~strcmpi(FILE_NAME_ON_EL_PC, EdfFile)
        copyfile(fullfile(DestDir,FILE_NAME_ON_EL_PC), fullfile(DestDir,EdfFile));
        delete(fullfile(DestDir,FILE_NAME_ON_EL_PC));
    end
    COSY_EYELINK.isFileTransfered = true;
elseif status == 0
    % Do nothing because of bug on EyeLink 3.10 (see above)   % <v3-beta28: moved that it was misplaced>
%     msg = 'File transfer was cancelled by user.';
%     dispinfo(mfilename,'error',msg);
%     warning(msg)
end
COSY_EYELINK.isFileRecorded = 0;

%% CloseFile
Eyelink('CloseFile');
