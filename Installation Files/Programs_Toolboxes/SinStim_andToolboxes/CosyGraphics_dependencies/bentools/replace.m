function replace(varargin)
% REPLACE  Replace expression in the files of a directory (including sub-dir.)
%    REPLACE(exp0,exp1)          replaces exp0 by exp1 in M-files of the current directory.
%    REPLACE(exp0,exp1,ext)      replaces in files with extention 'ext' (use '*' for all files).
%    REPLACE(exp0,exp1,ext,dir)  replaces in files of the given directory.
%    REPLACE('-r',...)           recursive mode: replaces also in sub-directories.
%
%   See also SEARCH.

% ben   dec 2006   0.99
%       jan 2007   1.0    Replace in M-files only by default. Fix recursive call for sub-dir.
%                         Display only if changes made.
%       jun        1.0.1  Invert order of 'ext' and 'dir' arguments to be consistent with search.m
%                         Buggy! Don't use this version!
%       oct        1.0.2  Fix 1.0.1 (arg. order bugs).
%       jan 2010   1.1    -r option (recursive). Default mode is now non-recursive.


%% Input Args
if strcmp(varargin{1},'-r')
    isRecursive = 1;
    varargin(1) = [];
else
    isRecursive = 0;
end
exp0 = varargin{1};
exp1 = varargin{2};
try   ext = varargin{3};
catch ext = 'm';
end
try   dirpath = varargin{4};
catch dirpath = pwd;
end
if dirpath(2) ~= ':', dirpath = [cd filesep dirpath]; end % full path
if dirpath(end) == filesep, dirpath(end) = []; end


%% Change dir.
pd = cd;
cd(dirpath) %---------!
d = dir;
d = d(3:end);


%% REPLACE EXP0 BY EXP1 IN EACH FILE

for i = find(~[d.isdir])
    if ext == '*' || strcmpi(d(i).name(end-length(ext)+1 : end),ext)
        fid = fopen(d(i).name,'r+');
        text = fscanf(fid,'%c');
        fclose(fid);
        
        ff = strfind(text,exp0);
        for f = ff(end:-1:1)
            if f > 1
                before = text(1:f-1);
            else
                before = [];
            end
            if f + length(exp0) <= length(text)
                after = text(f+length(exp0):end);
            else
                after = [];
            end
            text = [before exp1 after];
                
            fid = fopen(d(i).name,'w');
            fprintf(fid,'%s',text);
            fclose(fid);
        end
		if length(ff)
			disp([cd filesep d(i).name ' : ' num2str(length(ff)) ' change(s)'])
		end
    end
end


%% RELAUCH RECURSIVELY FOR EACH SUB-FOLDER

if isRecursive
    for i = find([d.isdir])
        replace('-r',exp0,exp1,ext,[dirpath filesep d(i).name]) % !!!
    end
end


%% Restore previous dir.
cd(pd) %---------!