function v2 = iscog(module)
% ISCOG  True if Cogent2000/CogentGraphics is used as low-level library.
%
%    v2 = ISCOG  if CogentGraphics is used as the main library (for graphics
%    & mouse), returns it's second version number v2 (i.e.: 24 or 28), else
%    returns 0.
%
%    v2 = ISCOG(Module)  returns v2 if Cogent2000/CogentGraphics are used
%    for module 'Module', 0 otherwise. Type 'getlibrary' to get the list
%    of modules.
%
% See also ISPTB, GETLIBRARY, SETLIBRARY.
%
% Ben, Sept-Oct 2008.

global GLAB_LIBRARIES

if ~nargin && ~isempty(GLAB_LIBRARIES)  % Most usual case: Optimized! <v2-beta23> <v2-beta31: fix case GLab not init>
    v2 = GLAB_LIBRARIES.iscog; % <boolean and no more a version # !!!>

else % Non-optim old code
    if ispc % MS-Windows
        if ~nargin, module = 'Graphics'; end
        
        if ~isempty(GLAB_LIBRARIES) % GLab started
            if isfield(GLAB_LIBRARIES.CURRENT,module)
                if strncmpi('C',GLAB_LIBRARIES.CURRENT.(module),1);
                    v = getlibrary('CG','Version');
                    v2 = v(2);
                else
                    v2 = 0;
                end
            else
                error('Invalid module name.')
            end
            
        else % GLab not started
            v = getlibrary('CG','Version');
            v2 = v(2);
            
        end
        
    else % Other OSes: Cogent is not supported.
        v2 = 0;
        
    end

end