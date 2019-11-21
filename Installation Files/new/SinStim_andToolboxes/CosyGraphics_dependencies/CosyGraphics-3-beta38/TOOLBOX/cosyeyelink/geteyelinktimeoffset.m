function ms = geteyelinktimeoffset
% GETEYELINKTIMEOFFSET  Time difference between the tracker time and display PC time.
%    offset = GETEYELINKTIMEOFFSET  returns the time offset (in msec).
%
% See also: GETEYELINKTIME.

%% First implementation: Use EyelinkToolbox function: Does not work
% ms = Eyelink('TimeOffset'); % <v3-beta27: Does not work => Rewritten in Matlab>


%% Second implementation: Time offset measured at trial onset by startrial. Not used beacause of drift
% Measured drift between PCs clocks (ATHOS & PLOTINUS): 1 ms/s !!!

% global COSY_EYELINK
% ms = COSY_EYELINK.TimeOffset; % <v3-beta27: Not working properly because of drift between clocks.>


%% Third implementation: Measure (quickly) at each function call (<= avoid drift problem!)
tM_0 = 0;
tM_1 = 0;
tE = 0;

for i = 1:2 % Real-time programming: First loop looses interpretation time, 2d loop is ok (stored in memory).
    tM_0 = GetSecs;
    tE = Eyelink('TrackerTime'); % ask EyeLink first
    tM_1 = GetSecs;
end

delta = mean([tM_0 tM_1]) - tE;

ms = delta * 1000;

%% DEBUG:
% %% Output: Command line use: Print result 
% % Just to avoid that annoying scientific notation of Matlab...
% if isempty(callername)
%     fprintf('%.3f msec\n', ms);
%     if ~nargout, clear ms; end
% end