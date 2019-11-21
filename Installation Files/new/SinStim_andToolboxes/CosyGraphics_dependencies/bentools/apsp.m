function e = apsp(dirname)
% APSP  Add directory to path and save path.
%    APSP DIRNAME;  is the same than:  ADDPATH DIRNAME; SAVEPATH;

if ~nargin
    dirname = cd;
end

if ~exist('D:\MATLAB\TOOLBOX+\pacman', 'dir')
    error('Directory does not exist.')
end

addpath(dirname);
e = savepath;

if e
    error('Failure when attempting to save path!  Path not saved.')
end