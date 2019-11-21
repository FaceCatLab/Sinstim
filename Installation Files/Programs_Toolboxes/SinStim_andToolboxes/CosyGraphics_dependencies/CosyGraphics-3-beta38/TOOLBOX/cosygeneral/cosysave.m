function cosysave(SubjName,Block)
% COSYSAVE  CosyGraphics standard save function.
%    COSYSAVE(SUBJNAME,BLOCK)  creates, if needed, a ".\save\SUBJNAME\" sub-directory in the calling 
%    m-file's containing directory and saves two files into:  1) Saves all variables of the calling m-file 
%    in a .mat file.  2) Saves the BLOCK structure in a .tsv file (ascii text file, tab separated values). 
%    Fields of the  BLOCK structure are vertical vectors (usually doubles or cell array of strings), 
%    and become columns in the .tsv file, field names becoming column titles.  One of BLOCK's fields
%    must be called 'Cond'.
%    If SUBJNAME is an empty string, or the string 'nobody' or 'x', 'xx', 'xxx', etc., nothing will
%    be saved.
%
% Example: called D:\MATLAB\myexperiment.m for subject Georgette in November 2012:
%    cosysave('Georgette',Block);
%
%    Files saved are:
%       D:\MATLAB\myexperiment\Georgette\myexperiment_Georgette_2012-11-12_15h29m17s.mat
%       D:\MATLAB\myexperiment\Georgette\myexperiment_Georgette_2012-11-12_15h29m17s.tsv
%
% See also READCONDTABLE, SAVETABLE.
%
% BenJ, Oct 2012.


%% Check input args
if nargin ~= 2
    error('Wrong number of arguments.')
end
if ~ischar(SubjName), error('Invalid argument: "SubjName" must be a string.'), end
if ~isstruct(Block), error('Invalid argument: "Block" must be a structure.'), end
if isfield(Block,'Cond')
    nTrials = length(Block.Cond);
elseif isfield(Block,'CondNum') % <not used for the moment. For fw compat. in case of change in a further version CGr.>
    nTrials = length(Block.CondNum);
end
fields = fieldnames(Block);
for f = 1 : length(fields)
    [m,n] = size(Block.(fields{f}));
    if m == nTrials % ok
    elseif m == 1 && n == nTrials % also ok
    else error(['Invalid field: ' fields{f} '. Invalid dimensions (' num2str(m) '-by-' num2str(n) ').'])
    end
end

%% If no subject name given ==> RETURN !!!
if isempty(SubjName) || strcmpi(SubjName,'nobody') || all(lower(SubjName) == 'x')
    if isempty(SubjName), SubjName = 'an empty string';
    else                  SubjName = ['''' SubjName ''''];
    end
    msg = ['No subject name PROVIDED (subject name is ' SubjName '): Nothing will be saved.'];
    dispinfo(mfilename,'warning',msg);
    
    return  %                                                                     <===RETURN===!!!
end

%% Get path to m-file
fullname = which(callername);
if isempty(fullname)
	path = cd;
else
	f = find(fullname == filesep);
	path = [fullname(1:f(end)-1) filesep];
end

%% Add "./save" and "./save/<SubjName>" sub-dirs
path = fullfile(path,'save',SubjName);
checkdir(path);

%% Get save files names
filename = [callername '_' SubjName datesuffix];
if isabort, filename = [filename '_aborted']; end
fullname_mat = fullfile(path,[filename '.mat']);
fullname_tsv = fullfile(path,[filename '.tsv']);

% %% Add Subj and Block columns
% s.Subj = cell(nTrials,1);
% for i = 1:nTrials, s.Subj{i} = SubjName; end
% s.Block = repmat(Block,1);
% 
% Block = structmerge(s,Block);

%% Save!
% 1) Saves all variables of the calling m-file in a .mat file:
cmd = ['save(''' fullname_mat '''); '];
msg = ['All variables of ' upper(callername) ' succesfully saved in file "' fullname_mat '".'];
evalin('caller', [cmd 'dispinfo(''' mfilename ''',''info'',''' msg ''');']); % We eval dispinfo() after save(), so it's executed only if save() returned without errors.

% 2) Saves the BLOCK structure in a .tsv file:
savetable(fullname_tsv, Block, nTrials);