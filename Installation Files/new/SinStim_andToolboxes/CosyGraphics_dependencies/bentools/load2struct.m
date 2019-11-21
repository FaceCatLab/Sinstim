function S = load2struct(DirName,varargin)
% LOAD2STRUCT
%    S = LOAD2STRUCT(DIRNAME,VARNAME1,VARNAME2,...)  loads variables from all mat-files in directory DIRNAME
%    and store them in fields S.(VARNAME1), S.(VARNAME2),... in struture S. To each file corresponds one row
%    in the structure fields.
%
% See also DISPTABLE.

od = pwd;
cd(DirName) % <--!
Files = dir;
cd(od)      % <--!
Files = Files(~[Files.isdir]);

VarNames = varargin;
for v = 1 : length(varargin)
    p = find(VarNames{v} == '.');
    if any(p)
        VarNames{v} = VarNames{v}(1:p(1)-1);
    end
end

S = [];

hWB = waitbar(0,'Reading files...');

for f = 1 : length(Files)
    waitbar(f/length(Files),hWB);
    tmp = load(fullfile(DirName,Files(f).name),VarNames{:});
    S.FileName{f,1} = Files(f).name;
    for v = 1 : length(varargin)
        tmp_fieldname = varargin{v};
        value = eval(['tmp.' tmp_fieldname ';']);
        fieldname = tmp_fieldname; 
        fieldname(fieldname == '.') = '_';
        if isnumeric(value) || islogical(value)
            S.(fieldname)(f,:) = value;
        else
            S.(fieldname){f,1} = value;
        end
    end
end

close(hWB)