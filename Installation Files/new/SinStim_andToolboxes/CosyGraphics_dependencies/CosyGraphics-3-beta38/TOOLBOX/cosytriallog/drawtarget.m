function drawtarget(iTarget, shape, rgb, b, xy, wh, linewidth)
% DRAWTARGET  Draw a target during a trial AND record it's co-ordinates. {fast}
%    DRAWTARGET(targetNum, shape, rgb, b, xy, w|wh)  records all parameters to be saved by SAVETRIALS. 
%    The trial must have been first initialized with STARTTRIAL.  targetNum is the target's number.  
%    b must always be 0 (backbuffer).  DRAWTARGET is a wrapper for DRAW.  See DRAW for mor informations
%    about other arguments arguments. 
%
%    Note bout buffers: DRAWTARGET draws always on buffer 0 (backbuffer). It's not possible to draw
%    on an other offscreen buffer, because DRAWTARGET is intended to be used *just before* the 
%    display.
%
% Example:
%       startpsych(0,[800 150],[.5 .5 .5]);
%       nTrials = 3;
%       x = -200:2:200;
%       y = 0;
%       for n = 1 : nTrials
%           starttrial;
%           for f = 1 : length(x)
%               drawtarget(1, 'round', [1 0 0], 0, [x(f) y], 10);
%               displaybuffer(0,oneframe);
%           end
%           stoptrial;
%           wait(700)
%       end
%       savetrials('my-file.mat');
%       stopcosy;
%
% See also STARTTRIAL, STOPTRIAL, GETTARGETDATA.

%% Global var
global COSY_TRIALLOG
if isempty(COSY_TRIALLOG) || ~COSY_TRIALLOG.isStarted
    error('DRAWTARGET can only be used once a trial is initialized by STARTTRIAL.')
end

%% Input vars
% wh
if length(wh) == 1
    wh = [wh wh]; 
elseif length(wh) > 2  % DRAW('polygon',  RGB, b, XY, XYXYXY)
    w = max(wh(1:2:end)) - min(wh(1:2:end));
    h = max(wh(2:2:end)) - min(wh(2:2:end));
    wh = [w h];
end
% linewidth
if ~exist('linewidth','var')
    linewidth = 0;
end

%% Draw
draw(shape,rgb,0,xy,wh,linewidth);

%% First call for this target: Variables initialisation
if iTarget > COSY_TRIALLOG.nTargets  % First call for this target..
    % +1 target
    n0 = COSY_TRIALLOG.nTargets;
    COSY_TRIALLOG.nTargets = iTarget;

    % Declare matrices:
    % * Note 1:
    %   First target has been initialised by STARTTRIAL.
    %   Don't forget to update STARTTRIAL in case of modifications!
    %
    % * Note 2:
    %   Performances issues (times measured on DARTAGNAN, on MATLAB 7.5):
    %   -   zeros(20000,2);                30 탎ec, 140 탎ec some hours later! Fixed by Matlab restart.
    %   -   zeros(20000,2) - 9999;         75 탎ec, 177 before restart. THIS IS THE FASTER SYNTAX.
    %   -   zeros(20000,2) + NaN;        3000 탎ec !!! AVOID NaNs DURING REAL-TIME !!!
    %   -   repmat(-9999,20000,2);        120 탎ec
    %   -   char(zeros(20000,2));         640 탎ec
    %   -   char(zeros(20000,8));        3300 탎ec !!! AVOID USE OF CHAR(), USE REPMAT !!!
    %   -   repmat(' ',20000,2);           47 탎ec
    %   -   repmat(' ',20000,8);           90 msec :-)  REPMAT(SCALAR,M,N) IS FAST      (nb: 260 ms on CHEOPS)
    %   -   repmat('        ',20000,1)    580 탎ec !!! AVOID THIS: USE REPMAT(SCALAR,M,N) !!!
    %   -   repmat(('        ')',1,20000) 880 탎ec
    %   Test line:
    %   t0=time; for i=1:1000, z= zeros(20000,2); end, dt=time-t0
    %
    m = length(COSY_TRIALLOG.PERDISPLAY.TimeStamps);
    for i = n0+1 : iTarget
        COSY_TRIALLOG.PERDISPLAY.TARGETS(i).Shape = repmat(' ',20000,8);
        COSY_TRIALLOG.PERDISPLAY.TARGETS(i).XY = zeros(m,2) - 9999; % use -9999 in place of NaNs
        COSY_TRIALLOG.PERDISPLAY.TARGETS(i).WH = zeros(m,2) - 9999;
        COSY_TRIALLOG.PERDISPLAY.TARGETS(i).RGB = zeros(m,length(rgb)) - 9999;
    end
    % Total time: 330 탎ec (m=20000)
end

%% Store x, y coords
iDisplay = COSY_TRIALLOG.iDisplay + 1; % we are storing coords for the *next* display.
COSY_TRIALLOG.PERDISPLAY.TARGETS(iTarget).Shape(iDisplay,1:length(shape)) = shape;
COSY_TRIALLOG.PERDISPLAY.TARGETS(iTarget).XY(iDisplay,:) = xy;
COSY_TRIALLOG.PERDISPLAY.TARGETS(iTarget).WH(iDisplay,:) = wh;
COSY_TRIALLOG.PERDISPLAY.TARGETS(iTarget).RGB(iDisplay,1:length(rgb)) = rgb; % <"1:length(rgb)" in place of ":", so a 4th col will be added if needed.>