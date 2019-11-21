function name = callername(option)
% CALLERNAME  Name of the caller function.
%    CALLERNAME  returns the name of the "parent" m-file of the m-file which executes callername.
%    (i.e.: the file which calls the file which calls callername.)
%
% See also MFILENAME, DBSTACK. 
%
% Ben,  Jun 2010.

%       Feb 2010,    v0.1    Using evalin and mfilename. Cannot work.
%       Jun 2010     v1.0    Rewrite using dbstack.

%% <First attempt; cannot work because mfilename returns always 'callername'>
% Level 0:  'global CALLERNAME_TMP'
% Level 1:  evalin('caller','global CALLERNAME_TMP')
% Level 2:  evalin('caller','evalin(''caller'',''global CALLERNAME_TMP'')')

% global CALLERNAME_TMP
% evalin('caller','evalin(''caller'',''global CALLERNAME_TMP'')')
% 
% evalin('caller','evalin(''caller'',''CALLERNAME_TMP = mfilename;'')')
% 
% name = CALLERNAME_TMP;
% clear global CALLERNAME_TMP

%% <2d attempt: use dbstack>
% Get the debug stack
s = dbstack; 28, assignin('base','s',s);
% s(1) -> 'callername' (this function)
% s(2) -> mfile which is calling callername; empty if caller name called directly from workspace
% s(3) -> the caller mfile we are looking for; empty if mfile lvl 2 called from workspace
if length(s) >= 3
    name = s(3).name;
else
    name = '';
end
