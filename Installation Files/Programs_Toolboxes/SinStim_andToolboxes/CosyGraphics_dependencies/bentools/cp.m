function cp(varargin)
% CP  Copy file.
%    CP [OPTIONS] SOURCEFILE DESTFILE
%    CP [OPTIONS] SOURCEFILE DESTDIR  <todo>
%
% Options:
%    -r, -R, --recursive   copy directories recursively  <TODO>
%
%    -u, --update          copy only when the SOURCE file is newer than the destination file
%                          or when the destination file is missing
%
% See also COPY.
%
% <TODO: jokers in file names: See getfilesize code!!>


%% UNIX: Use the OS's cp command
if ~ispc  %
    cmd = 'cp ';
    for i = 1 : nargin
        cp = [cmd, varagin{i}, ' '];
    end
    [status,result] = unix(cmd);
    disp(result);

end


%% Windows: XCOPY is not reliable, use only MATLAB code.
if ispc
    % Default options
    Opt.i = 0;
    Opt.r = 0;
    Opt.u = 0;

    % Options
    iopt = findoptions(varargin);
    for i = iopt
        switch varargin{i}
            case {'-i','--interactive'}
                Opt.i = 1;

            case {'-r','-R','--recursive'}
                Opt.r = 1;

            case {'-u','--update'}
                Opt.u = 1;

            otherwise
                if varargin{i}(2) ~= '-' && length(varargin{i}) > 2  % Multiple options..
                    for o = 2 : length(varargin{i})
                        if varargin{i}(o) == 'R' % particular case of -r/-R option: case insensitive
                            Opt.r = 1;
                        else
                            Opt.(varargin{i}(o)) = 1;
                        end
                    end

                else
                    error(['Invalid option: ''' varargin{i} ''''])

                end
        end
    end

    varargin(iopt) = [];
    if length(varargin) ~= 2
        error('Wrong number of arguments.')
    end

    % Source
    Source = varargin{1};
    if length(Source) > 1 && (strcmp(Source(1:2),'./') | strcmp(Source(1:2),'.\'))
        Source = fullfile(cd, Source(2:end));
    end
    sep = find(Source == '\' | Source == '/');
    if isempty(sep)
        SourceRootDir = cd;
        SourceFileName = Source;
    else
        SourceRootDir = Source(1:sep(end));
        SourceFileName = Source(sep(end)+1:end);
    end
    if Opt.r
        SourceDirs = getsubdirlist(SourceRootDir);
    else
        SourceDirs = {SourceRootDir};
    end
    if ispc, SourceFileName = lower(SourceFileName); end

    % Destination
    Dest = varargin{2};
    if exist(Dest,'dir')     % cp source dir
        DestRootDir = Dest;
        DestFileName = '';
    elseif strcmp(Dest,'.')  % cp source .
        DestRootDir = cd;
        DestFileName = '';
    else                     % other
        if length(Dest) > 1 && (strcmp(Dest(1:2),'./') | strcmp(Dest(1:2),'.\'))
            Dest = fullfile(cd, Dest(2:end));
        end
        sep = find(Dest == '\' | Dest == '/');
        if isempty(sep)      % cp source file
            DestRootDir = cd;
            DestFileName = Dest;
        else                 % cp source path/file
            DestRootDir = Dest(1:sep(end));
            DestFileName = Dest(sep(end)+1:end);
            checkdir(DestRootDir);
        end
    end
    if ispc, SourceFileName = lower(SourceFileName); end

    % Loop directory by directory
    for d = 1 : length(SourceDirs)
        sdir = SourceDirs{d};
        ddir = fullfile(DestRootDir, sdir(length(SourceRootDir)+1 : end));
        checkdir(ddir);
        sdirlist = dir(sdir);
        ddirlist = dir(ddir);
        if ispc
            for f = 1 : length(sdirlist), sdirlist(f).name = lower(sdirlist(f).name); end
            for f = 1 : length(ddirlist), ddirlist(f).name = lower(ddirlist(f).name); end
        end
        for f = 1 : length(sdirlist)
            ok = 0;
            isOverwrite = 0;
            if sdirlist(f).isdir == 0
                if globcmp(sdirlist(f).name, SourceFileName)
                    ok = 1;
                    if Opt.u  % '--update'
                        for df = 1 : length(ddirlist)
                            if strcmp(sdirlist(f).name, ddirlist(df).name)
                                if datenum(sdirlist(f).date) > datenum(ddirlist(df).date)
                                    isOverwrite = 1;
                                else
                                    ok = 0;
                                end
                                break % <--!!
                            end
                        end
                    end
                end
            end
            if ok
                source = fullfile(sdir, sdirlist(f).name);
                dest   = fullfile(ddir, sdirlist(f).name);
                str = ['Copy "' source '"'];
                if isOverwrite
                    str = [str ' (' sdirlist(f).date ' >>overwriting>> ' ddirlist(df).date ')'];
                else
                    str = [str ' (' sdirlist(f).date ')'];
                end
                disp(str)
                sub_copyfile(source, dest);
            end
        end



    end



end


%% SUB-FUNCTIONS
%% SUB_COPYFILE  Copy file.
%    COPYFILE SOURCEFILE DESTFILE
%
% See also CP.
function sub_copyfile(source,dest)

% <TODO: jokers in file names: See getfilesize code!!>


if exist([source '.m'],'file')
    source = [source '.m'];
elseif ~exist(source,'file')
    error(['File "' source '" does not exist.'])
end

fid = fopen(source,'r+');
if fid < 0, error(['Cannot open source file "' source '".']), end
content = fread(fid,inf,'*uint8');
fclose(fid);

fid = fopen(dest,'w');
if fid < 0, error(['Cannot open dest file "' dest '".']), end
fwrite(fid,content);
fclose(fid);