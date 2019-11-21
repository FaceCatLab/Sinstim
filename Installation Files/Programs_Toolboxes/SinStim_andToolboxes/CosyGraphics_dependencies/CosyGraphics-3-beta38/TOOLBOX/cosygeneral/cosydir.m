function dirpath = cosydir(arg)
% COSYDIR  Location of CosyGraphics's directories.
%    COSYDIR  returns the location of the actual toolbox (the m-files).  Same as COSYDIR TOOLBOX.  
%    COSYDIR ROOT  CosyGraphics's root directory.  Same as COSYGRAPHICSROOT.
%    COSYDIR PARENT  parent of the root dir.
%    COSYDIR TOOLBOX  dir containing the m-files (not directly, but in sub-dirs).  Same as COSYDIR.
%    COSYDIR MEX  dir containing the mex-files (not directly, but in sub-dirs).
%    COSYDIR DEMOS  dir containing the demo m-files.
%    COSYDIR IMAGES  dir containing image files included in the toolbox.
%    COSYDIR VAR  dir containing data files needed by the toolbox.
%    COSYDIR TMP  dir for temporary data.
%    COSYDIR LOG  dir containing log files automatically recorded during experiences.
%
%    Type " help setupcosy " to get info about the directory tree's organisation.
%
% See also COSYGRAPHICSROOT, SETUPCOSY, CDCOSY, OFCOSY.

if ~nargin
    arg = 'toolbox';
end

ExtDirName = 'cosygraphics';

root = cosygraphicsroot;

switch lower(arg)
    case 'root' %<Also defined in SETUPCOSY>
        dirpath = root;
        
    case 'parent' %<Also defined in SETUPCOSY>
        f = find(root == filesep);
        dirpath = root(1:f(end));
        
    case 'toolbox' %<Also defined in SETUPCOSY>
        dirpath = fullfile(root,'TOOLBOX');
        
    case 'mex'
        dirpath = fullfile(root,'mex');
        
    case {'demo','demos'}
        dirpath = fullfile(root,'TOOLBOX','cosydemos');
        
    case 'images'
        dirpath = fullfile(cosydir('demos'),'images');
        
    case 'var'
        dirpath = fullfile(root,'var');
        
    case 'tmp'  % External dir. <NB: Must stay external, because edf2asc use it and cannot be run from inside My Documents.>
        if ispc
            drive = root(1:3);
            dirpath = fullfile(drive,'cosygraphics','tmp');
        else
            dirpath = '/tmp/cosygraphics';
        end
        checkdir(dirpath);
        
    case 'log'  % External dir. <NB: Must stay external, because we don't want the user to copy all the logs when trying to copy the toolbox.>
        if ispc
            drive = root(1:3);
            dirpath = fullfile(drive,'cosygraphics','var','log');
        else
            error('Not yet implemented on Unix.')
        end
        checkdir(dirpath);
        
    otherwise
        error('Invalid argument.')
        
end

if dirpath(end) ~= filesep
    dirpath(end+1) = filesep;
end