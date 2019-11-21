function stopeyelinkrecord(DestDir,EdfFile)
% STOPTEYELINKRECORDING    Stop data recording and transfer data file to GLab PC.
%    STOPTEYELINKRECORDING  stops recording. Data are transfered to "glabtmp>\active.edf",
%    which will be used by SAVETRIALS* functions.
%
%    STOPTEYELINKRECORDING(DESTDIR)  writes file in DESTDIR directory.
%
%    STOPTEYELINKRECORDING(DESTDIR,FILENAME)  gets a custom EDF file. Normally you should not need that.


global GLAB_EYELINK

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 1, DestDir = glabtmp; end
if nargin < 2, EdfFile = 'active.edf'; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if checkeyelink('isrecording')
    dispinfo(mfilename,'info','Stopping EyeLink recording...')
    GLAB_EYELINK.isRecording = 0;
    Eyelink('StopRecording');
end


% %% SUB-FUNCTION: GETEYELINKFILE %%%%%%%%%%%%%%%%%%%% %%
% function geteyelinkfile(DestDir,EdfFile)
% % GETEYELINKFILE  Get last EDF file from EyeLink computer. <TODO: update doc>
% %    GETEYELINKFILE  gets last 'ACTIVE.EDF' file from the EyeLink computer and write it
% %    in '<glabtmp>\active.edf'. NB: On the EyeLink PC side, the system is supposed 
% %    to have been configured to use 'ACTIVE.EDF' as file name. (This is our IoNS convention,
% %    it's not a factory default.)
% %
% %    GETEYELINKFILE(DESTDIR)  writes file in DESTDIR directory.
% %
% %    GETEYELINKFILE(DESTDIR,FILENAME)  gets a custom EDF file. Normally you should not need that. <???>
% 
% %% Check EyeLink status
% if ~checkeyelink('isrecording')
%     stopeyelinkrecord;
% end
% % if ~checkeyelink('isopen')
% %     openeyelink;
% %     wasOpen = 0;
% % else
% %     wasOpen = 1;
% % end
% 
% %% OpenFile
% err = Eyelink('OpenFile','filename');
% if err, error('Cannot open file.'); end
% 
% %% Eyelink('ReceiveFile') documentation:  
% % [status =] Eyelink('ReceiveFile',['filename'], ['dest'], ['dest_is_path'])
% %  If <src> is omitted, tracker will send last opened data file.
% %  If <dest> is omitted, creates local file with source file name.
% %  Else, creates file using <dest> as name.  If <dest_is_path> is supplied and
% % non-zero
% %  uses source file name but adds <dest> as directory path.
% %  returns: file size if OK, 0 if file transfer was cancelled [see below], negative =  error
% % code
% 
% % Bug on EyeLink 3.10 !!!: returns 0 instead of file size.
% 
% %% ReceiveFile
% % dispinfo(mfilename,'info','Tranfering eye data file from EyeLink PC to "<glabtmp>\active.edf"...')
% status = Eyelink('ReceiveFile',EdfFile,DestDir,1);
% if status < 0,
%     dispinfo(mfilename,'error','Error while receiving file !'); 
%     error('Error while receiving file.');
% elseif status == 0, 
%     dispinfo(mfilename,'info',['File succesfully transfered to "' fullfile(DestDir,'active.edf') '".'])
%     % Do nothing because of bug on EyeLink 3.10 (see above)
% %     dispinfo(mfilename,'warning','File transfer canceled by user.');
% end
% 
% %% CloseFile
% Eyelink('CloseFile');