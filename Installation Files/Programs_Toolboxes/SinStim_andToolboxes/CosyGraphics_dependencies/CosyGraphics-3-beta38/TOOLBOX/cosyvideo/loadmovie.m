function h = loadmovie(name)
% LOADMOVIE  Load *.avi movie file into memory. {slow}
%    h = LOADMOVIE(filename)  opens movie file and loads the beginning of the movie in a RAM buffer
%    and returns a handle. The movie is now ready to be played smoothly by PLAYMOVIE, with no latency 
%    at startup. 
%
%    handles = LOADMOVIE(foldername)  loads all *.avi files contained in folder.
%
% Example:
%    h = loadmovie('movie.avi');
%    playmovie(h);
%
% See also: PLAYMOVIE, CLOSEMOVIE.

%% Global var
global COSY_DISPLAY

if ~isfield(COSY_DISPLAY,'MovieHandles')
    COSY_DISPLAY.MovieHandles = [];
end

%% Input var
switch exist(name)
    case 0
        if isopen('display'), stopcosy; end
        error(['File or folder does not exist: "' name '".'])
        
    case 2 % File
        Files = {name};
        
    case 7 % Folder
        Files = {};
        d = dir(name);
        for i = 1 : length(d)
            if ~d(i).isdir
                [p,f,ext] = filenameparts(p(i).name);
                if strcmpi(ext,'avi')
                    Files{end+1} = fullfile(name, d(i).name);
                end
            end
        end
        
    otherwise
        error('?????')
    
end

%% Open movie!
h = zeros(size(Files));

for i = 1 : length(Files)
    if iscog
        % Get first free handle:
        free = setdiff(1:999, COSY_DISPLAY.MovieHandles);
        h(i) = free(1);

        % Open movie!
        cgopenmovie(h(i), Files{i});

    else isptb % <TODO!>
        if isopen('display'), stopcosy; end
        error('Sorry, not yet implemented over PTB. Start CosyGraphics with startcogent if you want to play movies.')
         % <TODO!>
    end
    
end

%% Update global var
COSY_DISPLAY.MovieHandles = union(COSY_DISPLAY.MovieHandles, h);