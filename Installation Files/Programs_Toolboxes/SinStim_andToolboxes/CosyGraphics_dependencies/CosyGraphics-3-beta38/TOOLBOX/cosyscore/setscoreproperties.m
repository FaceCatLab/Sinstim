function p = setscoreproperties(ScoreName,varargin)
% SETSCOREPROPERTIES  Get properties of score display.  Syntax similar to SET() syntax.
%    SETSCOREPROPERTIES(ScoreName,...)  <TODO: write doc>

global COSY_SCORE % <Modular var: accessed only by module's functions (!!)>

checkscoreopen;

%% Input Vars
ScoreName = upper(ScoreName);
if ~ischar(ScoreName)
    error('Missing input argument: The first argument must be the score name (''increment'', ''currenttotal'' or ''finaltotal'').')
elseif ~any(strcmp(ScoreName,fieldnames(COSY_SCORE)))
    error(['Invalid input argument: ''' ScoreName ''' is not a valid score name.' 10 ...
        'Valid names are: ''increment'', ''currenttotal'' and ''finaltotal''.'])
end
    
%% Set Properties
if nargin==3 && any(strcmpi(varargin{1},{'DIGIT','BAR','SOUND'}))
    fieldname = ['Enable' upper(varargin{1}) '___'];
    switch upper(varargin{2})
        case {'ON' ,1},  COSY_SCORE.(upper(ScoreName)).(fieldname) = true;
        case {'OFF',0},  COSY_SCORE.(upper(ScoreName)).(fieldname) = false;
    end
else
    COSY_SCORE.(ScoreName) = setpropstruct(COSY_SCORE.(ScoreName), varargin{:});
end
