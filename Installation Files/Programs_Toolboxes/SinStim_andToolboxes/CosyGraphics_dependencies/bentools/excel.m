function fullname = excel(filename)
% EXCEL  Open a file with MS-Excel.
%    EXCEL(FILENAME)  if Excel is installed on the computer, opens file with it.
%
%    EXCEL, by itself, opens a dialog box to select a file opens Excel.
%
%    fullname = EXCEL('find excel.exe')  looks for the excel.exe FILE on "Program Files" folder and,  
%    if found, returns it's full name ; otherwise returns an empty string and issue a warning.
%
% Ben, Jan 2010.

%% FIND EXCEL.EXE
if nargin && strcmp(filename,'find excel.exe')
    fullname = [];
    
    if ispc
        officeroot = 'C:\Program Files\Microsoft Office\';
        od = cd; % <--!
        cd(officeroot)
        d = dir;
        cd(od)   % <--!
        d(1:2) = []; % remove . and ..
        for i = 1 : length(d)
            if d(i).isdir
                name = [officeroot d(i).name filesep 'excel.exe'];
                if exist(name,'file')
                    fullname = name;
                    break % <=== BREAK FOR !!!
                end
            end
        end
        if isempty(fullname)
            warning('Cannot find excel.exe on hard disk.')
        end
        
    else
        warning('excel.m only supports MS-Windows.')
        
    end
    
%% OPENS EXCEL
else
    if nargin == 0
        [filename,pathname] = uigetfile;
        if any(filename ~= 0)
            filename = [pathname filesep filename];
        else
            return % <---!!!
        end
    end
    if ~any(filename == '\' | filename == '/')
        filename = [pwd filesep filename];
    elseif filename(1) == '.'
        filename = [pwd filesep filename(2:end)];
    end
    excel_exe = excel('find excel.exe'); % <=== RECURSIVE CALL !!!
    command = ['"' excel_exe '" "' filename '"&'];
    dos(command,'-echo');
end
