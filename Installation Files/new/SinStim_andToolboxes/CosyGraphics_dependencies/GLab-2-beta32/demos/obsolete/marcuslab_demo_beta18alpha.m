% MONKEYLABDEMO:  Example experiment script for the monkey lab.

%%%%%%%%%%%%%%%%
nTrials = 3;
%%%%%%%%%%%%%%%%

%% Get trajectory structure
dim = 10;
rgb = [1 0 0]; % MUST contain red for PSB !!!
fix1  = preparetrajectory('round',dim,rgb, 'fix',[-200 0],1000, '-tolwin',250,[100 100]);
gap   = preparetrajectory('',500);
rampe = preparetrajectory('round',dim,rgb, 'rampe',[200 0],2000,[],[], '-tolwin',250,[200 100]);
fix2  = preparetrajectory('round',dim,rgb, 'fix',[200 0],1000, '-tolwin',0,[100 100]);
traj  = [fix1 gap rampe fix2];

%% Init GLab, // port, PSB
startglab('ptb',0,[800 300],[3 3 3]/255);
% startglab('cog',0,[800 600],[3 3 3]/255);
openparallelport out;
openeyelink;
openPSB;
psb_fullblanking blue on; % Suppress blue channel on PSB monitor.

%% Display block
for i = 1 : nTrials
    displaytrajectory(traj,'-tolwin','mouse',0,1);
    wait(700) % Intertrial
    if isabort, break, end
end

%% Stop
psb_fullblanking blue off;
stopglab
