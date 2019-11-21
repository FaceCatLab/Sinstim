function b = isptb(module)
% ISPTB  True if PsychToolBox is used as low-level library.
%
%    true = ISCOG  returns 1 if PsychToolBox is used as the main library
%    (for graphics & mouse).
%
%    ISPTB(Module)  returns 1 if PsychToolBox is used for used for module
%    'Module', 0 otherwise. Type 'getlibrary' to get the list of modules.
%
% See also ISCOG, GETLIBRARY, SETLIBRARY.
%
% Ben, Sept-Oct 2008.

% ________________
% Todo, version 2:
%    ISPTB  or  ISPTB('Graphics')  returns 1 if PsychToolBox is used as
%    the graphics library and 0 otherwise.

global GLAB_LIBRARIES

if isempty(GLAB_LIBRARIES)
    b = ~ispc;
end

if ~nargin % Most usual case: Optimized! <v2-beta23>
    b = GLAB_LIBRARIES.isptb;
    
else % Non-optim old code
    % if ~nargin, module = 'Graphics'; end
    
    if isfield(GLAB_LIBRARIES.CURRENT,module)
        b = strncmp('P',GLAB_LIBRARIES.CURRENT.(module),1);
    else
        error('Invalid module name.')
    end
    
    if ~isempty(GLAB_LIBRARIES) % GLab started
        if isfield(GLAB_LIBRARIES.CURRENT,module)
            b = strncmp('P',GLAB_LIBRARIES.CURRENT.(module),1);
        else
            error('Invalid module name.')
        end
    else % GLab not started
        if ispc % On windows: Use Cogent as default lib. (more stable)
            b = 0;
        else % On other OSes: Use PTB
            b = 1;
        end
    end

end