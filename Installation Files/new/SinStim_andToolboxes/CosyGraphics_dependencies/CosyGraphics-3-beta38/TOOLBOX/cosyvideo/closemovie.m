function closemovie(h)
% CLOSEMOVIE  Close movie file and free up memory.
%    CLOSEMOVIE(h)  closes movie of handle h, freeing up the memory it uses.
%    CLOSEMOVIE ALL  closes all open movies.
%
% See also: LOADMOVIE, PLAYMOVIE.

global GLAB_DISPLAY

if strcmpi(h,'all')
    h = GLAB_DISPLAY.MovieHandles;
end

for i = 1 : length(h)
    if iscog
        cgshutmovie(h(i));

    else
        % <TODO>

    end
end

GLAB_DISPLAY.MovieHandles = setdiff(GLAB_DISPLAY.MovieHandles, h);