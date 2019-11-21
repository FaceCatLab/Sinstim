% wrapper for file I/O operations for Eyelink system
% automates the process of opening and closing data files on the Eyelink host machine
% also transfers the files to the stimulus machine and renames them to match the experiment
% embedded in callbacks of expwin2.m
% JBB 03-2008
%
% function EyelinkFileIO(mode)
%   mode = 'open' or 'close'

function EyelinkFileIO(mode)

global DO_SAVE EXP_NAME SUBJ_NAME BLOCK_No HANDLE_PATHBOX USE_EYELINK

if DO_SAVE & USE_EYELINK,		% Save only if checkbox is checked AND Eyelink is active

	% Make file name:
	fname = [EXP_NAME '_' SUBJ_NAME '_' datestr(date,'yyyy-mm-dd') '_' BLOCK_No '_X.edf'];
	fullname = [get(HANDLE_PATHBOX,'str') '\' fname];
	
	if strcmpi(mode, 'open'),		% open temporary data file on EL console
		err = Eyelink('OpenFile', 'ACTIVE.EDF');
		if err ~= 0,
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please open file "ACTIVE" on Eyelink console, then press a key.\n');

			pause
		else
			fprintf('File "ACTIVE.EDF" successfully opened on EL host.\n');
		end
		Eyelink('message', fname);	% having associated .vsg file might be useful in future

	elseif strcmpi(mode, 'close'),	% close temporary file on EL console, then move it and rename	
		err = Eyelink('CloseFile');
		if err ~= 0,
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');
			fprintf('File IO error! Please close active file on Eyelink console, then press a key.\n');

			pause
		else
			fprintf('File "ACTIVE.EDF" successfully closed on EL host.\n');
		end

		err = Eyelink('ReceiveFile', '', fullname);	% copy last file written in case of user error
		if err ~= 0,
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');
			fprintf('File transfer error! Copy file manually or it may be overwritten.\n');

		else
			fprintf('File "%s" successfully transferred and saved to this machine.\n', fname);
		end
		% .edf file is now saved on stimulus machine with same name as .vsg file
		% do conversion to .asc on analysis machine (to save space during archiving / file transfer)
	else

		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');
		fprintf('Error: unknown mode.  Data will not be saved / transferred!!\n');

	end

end % if DO_SAVE & USE_EYELINK
