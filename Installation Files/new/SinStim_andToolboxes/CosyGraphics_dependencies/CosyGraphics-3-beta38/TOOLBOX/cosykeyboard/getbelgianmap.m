function be = getbelgianmap(b)
% GETBELGIANMAP  Key IDs for a belgian AZERTY keyboard.
%    map = GETBELGIANMAP  returns a structure containing key IDs. Structure
%       fields correspond to key names and field values are key IDs.
%
%   GETBELGIANMAP ?  displays geographical help.
%
% See also GETKEYNUMBER, GETKEYCODE, GETKEYNAME.
%
% Ben, March 2008.

global cogent

if ~iscog('Keyboard')
	error('GETBELGIANMAP can only be used with ''Cog'' library.');
elseif isempty(cogent) || ~isfield(cogent.keyboard,'hDevice')
	openkeyboard;
end

us = cogent.keyboard.map;
be = us;

% (New field names are marked with a "!")
be.A = us.Q;
be.Z = us.W;
be.Q = us.A;
be.W = us.Z;
be.M = us.SemiColon;
be.Comma = us.M;
be.SemiColon = us.Comma;
be.Colon = us.Period; %!
be.Equals = us.Slash;
be.UGrave = us.Apostrophe; %!
be.Mu = us.BackSlash; %!
be.Circumflex = us.LBracket; %!
be.Dollar = us.RBracket; %!
be.Square = us.Grave; %!
be.RParenthese = us.Minus;
be.Minus = us.Equals;
be.Enter = be.Return; %! For consistency with physical key label.

be = rmfield(be,{'Period','Slash','Apostrophe','BackSlash',...
		'LBracket','RBracket','Grave'});

if nargin && strcmp(b,'?')
	clear be
	belgium = [ '                                   #                         '; '                             ####### ###                     '; '            ###           ###############                    '; '        #############  ########################              '; '    ###############################################          '; ' ##################################################          '; '  #################################################          '; '  ################################################           '; '   ##############################################            '; '    ##################################################       '; '           #############################################     '; '            #############################################    '; '             ############################################    '; '                  ########################################   '; '                   ########################################  '; '                         ################################    '; '                          ###############################    '; '                          ##########################         '; '                          ######## ################          '; '                            ###     ##############           '; '                                    ##############           '; '                                       ############          '; '                                         ###########         '; '                                           #########         '; '                                             ######          '];
	disp(belgium)
end
