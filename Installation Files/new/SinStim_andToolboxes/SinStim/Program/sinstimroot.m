function dirpath = sinstimroot
% SINSTIMROOT  Root directory of SinStim installation
%     S = SINSTIMROOT returns a string that is the name of the directory
%     where the SinStim software is installed.
%  
%     SINSTIMROOT is used to produce platform dependent paths
%     to the various MATLAB and toolbox directories.
%  
%     Example:
%        fullfile(sinstimroot,'Save','MyExperiment','')
%     produces a full path to the SinStim/Save/MyExperiment/ directory that
%     is correct for platform it's executed on.
%  
%     See also CDSINSTIM, MATLABROOT, GLABROOT, BENTOOLSROOT, FULLFILE.

 w = whichdir('sinstim');
 f = find(w == filesep);
 dirpath = w(1:f(end-1));
 