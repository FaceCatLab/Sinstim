function p = getscoreproperties(ScoreName)
% GETSCOREPROPERTIES  Get properties of score display.
%    GETSCOREPROPERTIES  by itself, on the command-line, prints all score properties
%    on the command window.
%
%    P = GETSCOREPROPERTIES('Increment')  returns structure P containing the properties
%    controlling the display of the score increment (last points gained).
%
%    P = GETSCOREPROPERTIES('CurrentTotal')  returns structure P containing the properties
%    controlling the display of the current total (displayed during/after each trial).
%   
%    P = GETSCOREPROPERTIES('FinalTotal')  returns structure P containing the properties
%    controlling the display of the final total (displayed at end of block/experiment).

global COSY_SCORE % <Modular var: accessed only by module's functions (!!)>

%% Init CosyScore module if necessary
if ~(isfilledfield(COSY_SCORE,'isInitialized') && COSY_SCORE.isInitialized)
    openscore defaults;
end

% %% Input Args
% if ~nargin
%     error('Missing argument: "ScoreName" argument is undefined. (ScoreName can be ''increment'', ''currenttotal'' or ''finaltotal''.)')
% end

%% Command-line use: Print properties
if ~nargout && ~nargin && isempty(callername)
    disp(' ')
    disp('''Increment'':')
    disp(getscoreproperties('increment'))
    disp('''CurrentTotal'':')
    disp(getscoreproperties('currenttotal'))
    disp('''FinalTotal'':')
    disp(getscoreproperties('finaltotal'))
    
%% Standard use: Return a structure.
else
    switch lower(ScoreName)
        case 'increment'
            p = COSY_SCORE.INCREMENT;
        case 'currenttotal'
            p = COSY_SCORE.CURRENTTOTAL;
        case 'finaltotal'
            p = COSY_SCORE.FINALTOTAL;
        otherwise
            error(['Invalid input argument: ''' ScoreName ''' is not a valid score name. Valid names are: ''increment'', ''currenttotal'', ''finaltotal''.'])
    end
    
end