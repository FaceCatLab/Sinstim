% Extension to sinstim created by Goedele Van Belle and Renaud Laguesse
% (Face Categorisation Lab, Neurocs, Louvain La Neuve)

clear all
close all
clc

subjectnm = char(inputdlg('give the name of the subject'));
expPath=uigetdir (cd, 'Select your experiment folder, then click ok');  % define the path of the files to use
cd(expPath);

SaveDir = [expPath, '\data\', subjectnm, '\'];

startAgain = 0;
if ~exist(SaveDir)
    mkdir(SaveDir);
    files=dir(expPath);   %explore the directory specified
    str={files.name}; %make a cell that contain the name that aree in the directory
    
    str2 = {};
    indices = [];
    for lineNr = 1:numel(str)
        try
            desfileNm = str{lineNr};
            if strcmp(desfileNm(numel(desfileNm)-3:numel(desfileNm)), '.mat')
                str2 = [str2; desfileNm];
                indices = [indices,lineNr];
            end
        end
    end
    try
        [s, ok] = listdlg('PromptString','Select experiment design:','ListString',char(str2),'ListSize',[300 300]); % create a list dialog that contains the name that where in the directory
        if ok ==1
            expDesignFileNm=str(indices(s)); %create a cell containing the name of the file selected in the list dialog (with the reference of each)
        end
        expDesignFileNm = [expPath, '\', expDesignFileNm{1}];
        load(expDesignFileNm);
    end
    if ~exist('randomizeOrder', 'var')
        randomizeOrder = questdlg('Do you want the trial order to be randomized?','','Yes','No','No');
    end
    if strcmp(randomizeOrder,'Yes')
        [sortedCol, newInd] = sort(randperm(numel(trialList(:,1))));
        trialList = trialList(newInd, :);
    end
    
    
    save([SaveDir, 'trialOrder.mat'], 'trialList', 'expDesignFileNm');
    % make a text file with the name of the asa files for each trial
    for runNr = 1:size(trialList, 1)
        asaName = [subjectnm, '_', trialList{runNr, 1},'_',trialList{runNr, 2}(1:numel(trialList{runNr, 2})-2),'_', int2str(runNr)]; % -2 to remove the .m
        dlmwrite([SaveDir, subjectnm, '_asaFilenames.txt'], asaName, 'delimiter', '', 'newline', 'pc','-append');
    end
else
    startAgain = str2num(cell2mat(inputdlg(['how many trials did ',subjectnm, ' finish correctly (in total)?'])));
    load([SaveDir, '\trialOrder.mat']);
    trialList = trialList(startAgain+1:size(trialList, 1), :);
end

disp('you can now put the text file of the asa filenames on a usb stick:  space bar to start the experiment');
pause()

runSinstimNow = questdlg('Do you want to run sinstim now?','','Yes','No','No');

if strcmp(runSinstimNow,'Yes')
    % run sinstim for each stimulus folder
    runNr = 1;
    while runNr <= size(trialList, 1)
        disp(['trial ', int2str(startAgain+runNr),'   stimuli used: ', trialList{runNr,1}]);
        %         SubjName2 = [subjectnm, '_', trialList{runNr,1}];
        %         ImageDir = [stimPath, '\',trialList{runNr,1}];
        while KbCheck WaitSecs(0.1); end;
        
        sinstim_customStimList([expPath, '\parameters\',trialList{runNr,2}],[expPath, '\stimuli\',trialList{runNr,1}],SaveDir,[subjectnm, '_', trialList{runNr,1}],1);
        openWins = Screen('Windows');
        Screen('TextSize',openWins(1), 10);
        Screen('TextColor', openWins(1),[0,0,255]);
        %         Screen('Close',openWins(23:numel(openWins)));
        DrawFormattedText(openWins(1), ['trial ', int2str(runNr),' done!   stim: ', trialList{runNr,1},'   param: ', trialList{runNr,2}]);
        Screen('Flip', openWins(1));
        while KbCheck  WaitSecs(0.01); end
        keydown = 'noKey';
        while(~strcmp('q', keydown) && ~strcmp('n', keydown) && ~strcmp('r', keydown))
            [keyIsDown, secs, keydown] = KbCheck;
            if keyIsDown
                key = char(KbName(keydown));
                keydown = key(1,:);
            end
        end
        if strcmp('n', keydown)
            runNr = runNr+1;
        end
        quitExp = double(strcmp('q', keydown));
        if quitExp        break;    end
        
    end
    
    % stop sinstim
    stoppsych;
end

