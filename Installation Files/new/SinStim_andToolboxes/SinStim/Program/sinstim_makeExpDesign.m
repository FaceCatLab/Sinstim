% Extension to sinstim created by Goedele Van Belle and Renaud Laguesse
% (Face Categorisation Lab, Neurocs, Louvain La Neuve)

clear all
close all
clc

experimentPath = uigetdir (cd, 'Where is your experiment folder?');  % define the path of the files to use
expDesign = {};
% ask which paramater files to use
paramPath=uigetdir (experimentPath, 'Where are your parameter scripts?');  % define the path of the files to use
files=dir(paramPath);   %explore the directory specified
str={files.name}; %make a cell that contain the name that aree in the directory
[s, ok] = listdlg('PromptString','Select parameter files:','SelectionMode','multiple','ListString',str); % create a list dialog that contains the name that where in the directory
if ok ==1
    paramFiles=str(s); %create a cell containing the name of the file selected in the list dialog (with the reference of each)
end

% ask for each parameter file which stim folders we want to use with them
stimPath=uigetdir (experimentPath, 'Where are stimulus folders?');  % define the path of the files to use

for paramFileNr = 1:numel(paramFiles)
    paramFile = paramFiles{paramFileNr};
    % ask which paramater files to use
    files=dir(stimPath);   %explore the directory specified
    str={files.name}; %make a cell that contain the name that aree in the directory
    [s, ok] = listdlg('PromptString',['Select the stim folders you want to use with this parameter file: ', paramFile],'SelectionMode','multiple','ListString',str); % create a list dialog that contains the name that where in the directory
    if ok ==1
        stimFiles=str(s); %create a cell containing the name of the file selected in the list dialog (with the reference of each)
    end
    for stimFolderNr = 1:numel(stimFiles)
        expDesign = [expDesign ; stimFiles(stimFolderNr), cellstr(paramFile)];
    end
end
% order expDesign according to stim folder name
[sortedFirstColOfExpDesign, newInd] = sort(expDesign(:,1));
expDesign = expDesign(newInd, :);

% ask how many repetitions of each combination of stimFolder - paramfile
% you want
repetitions = str2num(cell2mat(inputdlg('How many times do you want each combination of stimulus folder and parameter file to be repeated?')));
expDesignFinal = {};
questions = {};
for rep = 1:repetitions
    expDesignFinal = [expDesignFinal;expDesign];
    for questNr = 1:size(expDesign,1)
        questions = [questions , cellstr([int2str(questNr),'  ', expDesign{questNr, 1},'  ', expDesign{questNr, 2}])];
    end
end

% ask whether order of trials need to be randomized
randomizeOrder = questdlg('Do you want the trial order to be randomized over repetitions?','','Yes','No','No');
if strcmp(randomizeOrder,'Yes')
    expDesignFinal = expDesignFinal(randperm(numel(expDesignFinal)), :);
    % ask the order of the trials if order is not randomized
else
    orderTrials = inputdlg(questions);
end

