function writeprt(FileName,Experiment,Conditions,Onsets,Offsets,Colors,ResolutionOfTime)
% WRITEPRT   Create a PRT file for BrainVoyager.
%    WRITEPRT(FileName,Experiment,Conditions,Onsets,Offsets,Colors,<ResolutionOfTime>)
%       FileName: the name of the PRT file to be created.
%       Experiment: the name of the experiment.
%       Conditions: the names of the conditions, in a cell array.
%       Onsets:  the onset times, in a matrix: one column per condition. 
%                Missing values (because not all cond. have same number
%                of occurences) replaced by 0s or NaNs.
%       Offsets: the offset times, idem.
%       Colors: a N-by-3 matrix containing the colors for each condition,
%               either in the range 0 to 255 or in the range 0 to 1.
%       ResolutionOfTime: <optionnal> the time unit: 'msec' or 'Volumes'.
%                         Default is 'msec'.

EL = char([13 10]); % End of Line;

if ~exist('ResolutionOfTime','var'), ResolutionOfTime = 'msec'; end

Str = [ EL...
'FileVersion:        2' EL EL...
'ResolutionOfTime:   ' ResolutionOfTime EL EL...
'Experiment:         ' Experiment EL...
EL...
'BackgroundColor:    0 0 0' EL...
'TextColor:          255 255 255' EL...
'TimeCourseColor:    255 255 255' EL...
'TimeCourseThick:    3' EL...
'ReferenceFuncColor: 128 128 128' EL...
'ReferenceFuncThick: 3' EL...
EL...
'NrOfConditions:     ' int2str(length(Conditions)) EL...
EL ];

if max(max(Colors)) <= 1, Colors = round(Colors * 255); end

for c = 1 : length(Conditions)
    n = length(~isnan(Onsets(:,c)) & Onsets(:,c)); % # of rows without 0s or NaNs (= # occurences for this condition)
    M = int2str([Onsets(1:n,c) Offsets(1:n,c)]);
    M(:,end+1) = char(13);
    M(:,end+1) = char(10);
    M = M';
    M = M(:)';
    
    Str = [ Str ...
            Conditions{1} EL...
            int2str(n) EL...
            M...
            'Color: ' int2str(Colors(c,:)) EL EL...
        ];
end
        
disp(Str)

% WRITE FILE
fid = fopen(FileName,'w');
fprintf(fid,'%s',Str);
fclose(fid);
