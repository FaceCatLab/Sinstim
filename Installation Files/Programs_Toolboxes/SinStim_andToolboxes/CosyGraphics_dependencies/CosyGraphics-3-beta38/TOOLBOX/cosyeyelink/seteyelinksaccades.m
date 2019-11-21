function seteyelinksaccades(saccade_velocity_threshold, saccade_acceleration_threshold)
% SETEYELINKSACCADES  EyeLink's saccade detection settings.
%    SETEYELINKSACCADES(VelThresh,AccThresh)  sets velocity threshold (deg/s) and acceleration 
%    threshold (deg/s²) for sccade detection.  Default values are 30 deg/s and 8000 deg/s².
%
% Ben, Jul 2011.

%% %%%%%%%%%%%% PARAMS %%%%%%%%%%%%%% %%
if ~nargin % Default values: Let's use EyeLink's standard config as defaults:
    saccade_velocity_threshold = 30; % EyeLink default = 30 (std config) or 22 (hi sensitivity config)
    saccade_acceleration_threshold = 8000; % EyeLink default = 8000 (std config) or 3800 (hi sensitivity config)
    % NB: Std config: ignores small saccade / High sensitivity: detects very small saccades
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

if ~isopen('eyelink')
    error('EyeLink communication not open. See OPENEYELINK.')
end

Eyelink('command', ['saccade_velocity_threshold = ' saccade_velocity_threshold]);
Eyelink('command', ['saccade_acceleration_threshold = ' saccade_acceleration_threshold]);

% Let's be verbose:
msg = ['Saccade detection parameters set: velocity thresh.: ' ...
    num2str(saccade_velocity_threshold) ...
    ', acceleration thresh.: ' ...
    num2str(saccade_acceleration_threshold) ...
    ];
if ~nargin
    msg = [msg ' (defaults).'];
else
    msg = [msg '.'];
end
dispinfo(mfilename,'info',msg);
if checkeyelink('isdummy')
    dispinfo(mfilename,'warning','No saccade detection in dummy mode.');
end