function savetrials(filename)
% SAVETRIALS  Save block of trials. <TODO: UNFINISHED!>
%    SAVETRIALS(FILENAME)  saves data that have been automatically collected between STARTTRIAL 
%    and STOPTRIAL.  Data will be saved both as a MATLAB .mat file and as a standard .txt file. 
%    The latter can be read by other programs (e.g.: Excell, Statistica, SPSS,...).
%
% See also: STARTTRIAL, DRAWTARGET, STOPTRIAL.

%% Load data from tmp dir
% STOPTRIAL has saved trial data in "tmp" directory
tmpfile = fullfile(glabtmp,'trials.mat');
if exist(tmpfile,'file')
    load(tmpfile,'Trials')
else
    error(['Cannot find file "' tmpfile '".'])
end

%% 
rmfield(Trials,