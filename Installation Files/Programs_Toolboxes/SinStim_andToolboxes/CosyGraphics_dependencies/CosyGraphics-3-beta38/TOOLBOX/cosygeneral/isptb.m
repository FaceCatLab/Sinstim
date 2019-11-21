function b = isptb(module)
% ISPTB  True if PsychToolBox is used as low-level library.
%
%    true = ISCOG  returns 1 if PsychToolBox is used as the main library
%    (for graphics & mouse).
%
%    ISPTB(Module)  returns 1 if PsychToolBox is used for used for module
%    'Module', 0 otherwise. Type 'getcosylib' to get the list of modules.
%
% See also ISCOG, GETCOSYLIB, SETCOSYLIB.
%
% Ben, Sept-Oct 2008.

% ________________
% Todo, version 2:
%    ISPTB  or  ISPTB('Graphics')  returns 1 if PsychToolBox is used as
%    the graphics library and 0 otherwise.

global COSY_GENERAL

if isempty(COSY_GENERAL)
    b = ~ispc;
end


    
%% Most usual case: Optimized!
% <v2-beta23> <v2-beta41: replace IF test by TRY>
if ~nargin
    try
        b = COSY_GENERAL.LIBRARIES.isptb; % <boolean and no more a version # !!!>
        return  % <===!!!
    catch
        % Do nothing: the function will continue adn execute the non-optim old code.
    end
end

%% Non-optim old code
if ~nargin, module = 'Graphics'; end

if isfield(COSY_GENERAL,'LIBRARIES') % CosyGraphics started
    if isfield(COSY_GENERAL.LIBRARIES.CURRENT, module)
        b = strcmp('PTB', COSY_GENERAL.LIBRARIES.CURRENT.(module));
    else
        error(['Invalid module name: ''' module '''.'])
    end
else % CosyGraphics not started
    if ispc % On windows: Use Cogent as default lib. (more stable).
        b = false;
    else % On other OSes: Use PTB.
        b = true;
    end
end
