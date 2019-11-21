function ok = checkdir(abspath,newdir)
% CHECKDIR  Ensure that a directory exists, creating it if necessary.
%    OK = CHECKDIR(ABSPATH)  Checks that each dir in ABSPATH exists, creating it if not. When 
%    ABSPATH exists, returns OK = 1 ; if an error occured during a dir creation, displays error
%    message and returns OK = 0;
%
%    OK = CHECKDIR(PARENTDIR,SUBDIR)  is the same than  CHECKDIR(FULLFILE(PARENTDIR,SUBDIR)).
%
%    This function is an improvement over MATLAB's MKDIR. An other advantage over MKDIR is that it
%    makes some consistency checks on the ABSPATH string (fileseps correctness).
%
% Ben,  Jun 2010.

%% Check path consistency
if nargin >= 2
    abspath = fullfile(abspath,newdir);
end
if ispc % On Windows, '\' and '/' are ok ; on Unix, only '/' is ok..
    abspath(abspath == '\') = '/'; % ..let's use only '/'.
end
if ~isempty(strfind(abspath(2:end),'//')) % NB: "abspath(2:end)" because of remote addresses like \\servername\foldername
    if ispc, abspath(abspath == '/') = '\'; end
    error(['Invalid path: Repeated file separators: "' abspath '".'])
end
if abspath(end) ~= '/'
    abspath(end+1) = '/';
end
if ispc && abspath(2) == ':'
    drive = upper(abspath(1:2));
    if ~exist(drive,'dir'), error(['Drive ' drive ' does not exist.']), end
end

%% Check/create each dir one by one
ok = true;
sep = find(abspath == '/');
for s = 2 : length(sep)
    absnewdir = abspath(1:sep(s));
    parentdir = abspath(1:sep(s-1));
    newdir = abspath(sep(s-1)+1:sep(s)-1);
    if ~exist(absnewdir,'dir')
        [success,msg] = mkdir(parentdir,newdir);
        if success
            dispinfo(mfilename,'info',['Created new directory: "' absnewdir '"']);
        else
            ok = false;
            dispinfo(mfilename,'error',['Cannot create directory "' absnewdir '"' 10 msg]);
            break  % <---!!!
        end
    end
end