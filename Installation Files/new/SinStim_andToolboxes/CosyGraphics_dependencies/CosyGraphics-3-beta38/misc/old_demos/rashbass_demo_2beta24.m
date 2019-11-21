% FRAMESEQDEMO:  Example experiment script for the monkey lab.


%% 1) EyeLink Calibration

% starteyelinkcalib('HV5', 1, 800, [3 3 3]/255); % use same values than for startpsych() below


%% 2) Experiment

%%%%%%%%%%%%%%%%
nTrials = 10;
%%%%%%%%%%%%%%%%

%% Get frameseq structure
dim = 10;
rgb = [1 0 0]; % MUST contain red for PSB !!!
fix1  = frameseq('round',rgb,dim, 'fix',[-200 0],1000, '-tolwin',250,[100 100]);
gap   = frameseq('',500);
rampe = frameseq('round',rgb,dim, 'rampe',[200 0],2000,[],[], '-tolwin',250,[200 100]);
fix2  = frameseq('round',rgb,dim, 'fix',[200 0],1000, '-tolwin',0,[100 100]);
seq  = [fix1 gap rampe fix2];

disp('Frame sequence structure:')
disptable(seq,'-h');

%% Init GLab, // port, PSB
startpsych(1, 800, [3 3 3]/255); 
openparallelport out;
openeyelink; % NB: starteyelinkcalib can be before run with same values than startglab ; if not, openeyelink will run a calib.

% openPSB;
% psb_fullblanking blue on; % Suppress blue channel on PSB monitor.

%% Display block
for i = 1 : nTrials
    displayframeseq(seq,'-tolwin','eye',0,1);
    
    wait(700) % Intertrial
    if isabort, break, end
end

%% Stop
% psb_fullblanking blue off;
stopglab

%% Save data -> EYEVIEW
savefile = [glabtmp 'demo']; % use GLab's temp dir for the demo
savetrials4eyeview(savefile,'-open',1);
