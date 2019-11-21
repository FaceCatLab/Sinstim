function v2 = iscog(module)
% ISCOG  True if Cogent2000/CogentGraphics is used as low-level library.
%
%    ISCOG   returns true if CogentGraphics is used as the main 
%    library (for graphics & mouse), returns false if not.
%
%    v2 = ISCOG(Module)  if Cogent2000/CogentGraphics is used for module
%    'Module', returns it's second version number v2 (i.e.: 25 (or 24), 
%    28 or 29), else returns 0.  Type 'getcosylib' to get the list of modules.
%   
% See also ISPTB, GETCOSYLIB, SETCOSYLIB.
%
% Ben, Sept-Oct 2008.

global COSY_GENERAL

%% Most usual case: Optimized!
% <v2-beta23> <v2-beta31: fix case CosyGraphics not init> <v2-beta41: replace IF test by TRY>
if ~nargin 
    try 
        v2 = COSY_GENERAL.LIBRARIES.iscog; % <boolean and no more a version # !!!>
        return  % <===!!!
    catch
        % Do nothing: the function will continue adn execute the non-optim old code.
    end
end

%% Non-optim old code
if ispc % MS-Windows
    if ~nargin, module = 'Graphics'; end
    
    if isfield(COSY_GENERAL,'LIBRARIES') % CosyGraphics has been started, or setcosylib has been called..
        if isfield(COSY_GENERAL.LIBRARIES.CURRENT, module)
            if strncmpi('C', COSY_GENERAL.LIBRARIES.CURRENT.(module), 1);
                v = getcosylib('CG','Version');
                v2 = v(2);
            else
                v2 = 0;
            end
        else
            error(['Invalid module name: ''' module '''.'])
        end
        
    else % CosyGraphics not started
        v = getcosylib('CG','Version');
        v2 = v(2);
        
    end
    
else % Other OSes: Cogent is not supported.
    v2 = 0;
    
end
