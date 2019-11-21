% MARCUSLABLABDEMO:  Example of a Rashbass experiment for the human lab.


%% Params
%%%%%%%%%%%%%%%%
nTrials = 4;
%%%%%%%%%%%%%%%%

%% Settings
% ... <??>

%% Init GLab, // port, PSB
startglab('ptb',0,[800 600],[.5 .5 .5]); % 'ptb' or 'cog'= library to use, 0= screennumber (0=windowed), [800 600]= resolution, [.5 .5 .5]= bg colour.
openparallelport out;
% openeyelink; % Not yet supported on Matlab 6.5
% openPSB;
% psb_fullblanking blue on; % Suppress blue channel on PSB monitor.

% Sound:
opensound;
storetuut(3000,30,1);

% Background:
b = storeimage(rand(600,800,3));
setbackground(b);

%% Get trajectory structure
dim = 10;
rgb = [1 0 0]; % MUST contain red for PSB !!!
fix1 = preparetrajectory('fix','round',dim,rgb,[-200 0],1000,'-tolwin',250,[100 100]);
gap = preparetrajectory('gap',500);
rampe = preparetrajectory('rampe','round',dim,rgb,[200 0],2000,[],[],'-tolwin',250,[200 100],'-sound',1,0);
fix2 = preparetrajectory('fix','round',dim,rgb,[200 0],1000,'-tolwin',0,[100 100]);
traj = [fix1 gap rampe fix2];
disptable(traj,'-h') % display 'traj' structure in command window in the form of a table

%% Display block
for i = 1 : nTrials
    displaytrajectory(traj,'-tolwin','mouse',0,1);
    wait(700) % Intertrial
    if isabort, break, end
end

%% Stop
% psb_fullblanking blue off;
stopglab

%% Save data
cd(glabtmp) % for demo, let's save in GLab's temporary dir.
savetrials4eyeview('gui')
