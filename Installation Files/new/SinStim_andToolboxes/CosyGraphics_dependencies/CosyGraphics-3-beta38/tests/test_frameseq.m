function test_frameseq(nTrials,nRepeats)
% test_frameseq


shape = 'round';
dim = 16;
fixL  = frameseq(shape,rand(1,3),dim, 'fix',[-300 0],oneframe);
rampeFw = frameseq(shape,rand(1,3),dim, 'rampe',[300 0],2000-oneframe,[],[], '-tolwin',250,[200 100]);
gap  = frameseq('',500);
fixR  = frameseq(shape,rand(1,3),dim, 'fix',[300 0],10);
rampeBw = frameseq(shape,rand(1,3),dim, 'rampe',[-300 0],2000-oneframe,[],[], '-tolwin',250,[200 100]);
traj = [fixL rampeFw gap fixR rampeBw];
traj = repmat(traj,1,nRepeats);


startglab('ptb', 1, 1024, [.4 .4 .4]);


%% Display block
for i = 1 : nTrials
    
    displayframeseq(traj,'-tolwin','mouse',0,1);
    
    clearbuffer(0, [.8 .8 .8]);
    displaybuffer(0);
    wait(3000) % Intertrial
    if isabort, break, end
end

stopglab;