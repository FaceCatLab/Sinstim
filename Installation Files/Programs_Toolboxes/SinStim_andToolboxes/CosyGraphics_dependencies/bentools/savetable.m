function table = savetable(filename,varargin)
% SAVETABLE  Export Matlab variable(s) as a standard TAB-separated table in a *.TSV text file.
%    This function saves any type of Matlab variables as a standard table in a text file (*.tsv: 
%    Tab Separeted Values) which is readable by other programs like Excell, Gnumeric, OpenOffice.Calc,
%    Statistica or SPSS. Default file extension is .tsv, but any other extension can be choosen by  
%    the user. Unless the extension is .csv (Comma Separated Values), column separators are always 
%    tabs. (Both Excel and Gnumeric have bugs when reading CSV files ; TSB files are ok, at my knowledge.)
%    Alternatively, the function can output the table as a string vector. Variable to be saved can be 
%    of many types. See below:
%
%    SAVETABLE(filename,D)  save dataset D to a plain text file. (See " help dataset ", or see help  
%    of de Statistics toolbox about dataset objects.)
%
%    SAVETABLE(filename,S,n)  converts structure S to ASCII table. S is a scalar structure of vectors.
%    Each field contains n elements vectors or n-by-m matrices. n is the number of rows in the table.
%    Field names give column titles for the table. <TODO: cell arrays>
%
%       Example: 
%          "perTrial" structure, with two fields: "x" and "y",
%           as perTrial.x(i) is the x value for trial #i,
%              ¯¯¯¯¯¯¯¯¯¯¯¯¯
%           nTrials = length(perTrial);
%           savetable('myfile',perTrial,nTrials)  will generate an two columns table ('x' and 'y') 
%           ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯  with one row per trial.
%
%    SAVETABLE(filename,S)  converts structure S to ASCII table. The structure S is a vector, with one
%    element per row in the table.
%
%       Example: 
%          "perTrial" structure, with two fields: "x" and "y",
%          as perTrial(i).x is the x value for trial #i,
%             ¯¯¯¯¯¯¯¯¯¯¯¯¯
%          savetable('myfile',perTrial)  will generate an two columns table ('x' and 'y') 
%          ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯  with one row per trial.
%
%    SAVETABLE(filename,col1,...,colN)  converts variables col1 to colN into an ascii table. col* 
%    arguments can be numerical vectors or matrices, string arrays or cell arrays. Variable names 
%    give column titles for the table.
%
%       Example: 
%          Two vectors: "x" and "y",
%
%          savetable('myfile',x,y)  will generate an two columns table ('x' and 'y') 
%          ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯  with one row per vector element, and save it in file 'myfile.tsv'.
%
%    SAVETABLE(filename,M,<titles>)  converts the numeric matrix M to ASCII table. The optionnal argument
%    "titles" is a cell horizontal vector and contains the column titles. If "titles" is missing or empty, 
%    columns have no titles.
%
%       Example: 
%          An N-by-2 matrix XY,
%
%          savetable('myfile',XY,{'x','y'})  will generate an two columns table ('x' and 'y')
%          ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯  with N rows.
%
%    STR = SAVETABLE(filename,...)  returns the ascii table as a string vector. If 'filename' is a
%    valid file name, the table will be also saved in file. If 'filename' is empty, no file will be
%    saved.
%
%    SAVETABLE(filename,...,'-append')  if file already exists, append table in it, instead of  
%    replacing file. If file does not exist, creates it as normally. NB: The existing file is 
%    supposed to have been created by SAVETABLE itself, if if has been created by any other program, 
%    consistency is not ensured.
%
%    SAVETABLE(filename,...,'-overwrite')  if file already exists, overwrites it. (Default behavior 
%    is to ask user what to do.)
%
%    SAVETABLE(filename,...,'-sep',s)  uses s as column separator. Default separators are comma (',')
%    for *.csv files and tabs (char(9)) for all other file extensions.
%
%
% Related BenTools functions:
%    See also: DISPTABLE, STDTEXTREAD, OPENEXCEL, READTXT, WRITETXT.
%
% Related CosyGraphics functions:
%    See also: READCONDTABLE, COSYSAVE.
% 
%
% Ben,  08 Jan 2010.  SAVETXT (v1.0) <now deprecated>
%       17 Nov 2010:  SAVETABLE (v2.0) <Replacement of SAVETXT>  See btversion (v0.10.11) for changelog.

%       18 Nov        Fix SAVETABLE(M,titles)
%       21 Mar 2012   Add input arg checks.
%       18 Apr        Add support for dataset obj. as arg.


% <TODO: cell arrays>


%% Input Args
if nargin < 2, error('Not enough input arguments.'), end

% File name
if ~ischar(filename), error('First argument must be the file name.'), end
[p,f,ext] = filenameparts(filename);
if isempty(ext)
    ext = 'tsv'; % .TSV is the default file extension (>< SAVETXT (v1.0))
    filename = [filename '.tsv'];
end
if strcmpi(ext,'csv')
    SEP = ','; % Comma is the default column separator for *.csv files
else % General case: all other extensions
    SEP = char(9); % TAB is the default column separator for other files
end

% Options
options = findoptions(varargin);
isAppend = 0;
isOverwrite = 0;
for i = options;
    switch lower(varargin{i})
        case '-append',     isAppend = 1;
        case '-overwrite',  isOverwrite = 1;
        case '-sep',        SEP = varargin{i+1};
        otherwise,  error(['Unknown option: ' varargin{i}]);
    end
end
if any(options)
    varargin(options(1):end) = [];
end
if isAppend && isOverwrite
    error('Incompatible options: ''-append'' & ''-overwrite''.')
end
if strcmpi(ext,'csv') && SEP(1) ~= ','
    error('*.csv files must use comma ('','') as column separator.')
end


%% Vars
% Init
table = [];


%% CONSTANTS
% Column separator:
% SEP has been already defined above.
% End of line on MS-Windows is CR+LF:
LF  = char(10); % line feed
CR  = char(13); % carriage return:


%% DATASET ARG.: DATASET -> STRUCT.  <18-apr-2012>
if isa(varargin{1},'dataset')
    tmp = struct(varargin{1});
    varargin{2} = size(tmp.props,1);
    varargin{1} = tmp.props;
end


%% SAVETABLE(M,<C>)
if length(varargin) == 1 && isnumeric(varargin{1}) && size(varargin{1},2) > 1 ...       % SAVETABLE(M)
|| length(varargin) == 2 && isnumeric(varargin{1}) && iscell(varargin{2}) && ...        % SAVETABLE(M,titles)
   ( size(varargin{2},1) == 1  || isempty(varargin{2}) )  % ("titles" is a row vector or is empty)
       
       table = '';
       M = varargin{1};
       
       % 1) Titles
       if length(varargin)==2 && iscell(varargin{2}) && size(varargin{2},1)==1;
           if ~isAppend || ~exist(filename,'file') % Use titles only if we are creating a new file
               C = varargin{2};
               if length(C) > 0 && length(C) ~= size(M,2)
                   error('Number of column titles does not match number of columns.')
               end
               for i = 1 : length(C)
                   table = [table C{i} SEP]; % +title +SEP
               end
               % End of line:
               table = [table(1:end-1) char([CR LF])];  % replace last SEP by CR LF
           end
       end
       
       % 2) Data
       for i = 1 : size(M,1)
           for j = 1 : size(M,2)
               data = num2str(M(i,j));
               table = [table data SEP]; % +data +SEP
           end
            % End of line:
            table = [table(1:end-1) char([CR LF])];  % replace last SEP by CR LF
       end
%        table(end-1:end) = []; % Remove last linefeed and carriage return <???>


%% SAVETABLE(S,<n>)
elseif isstruct(varargin{1})
    S = varargin{1};
    
    % 1) Titles
    titles = fieldnames(S);

    for j = 1 : length(titles)
        table = [table titles{j} SEP]; % +title +SEP
    end
    table = [table(1:end-1) CR LF];  % End of line: remove last SEP and add CR LF

    % 2) Data
    %    STR = SAVETABLE(S)
    if length(varargin) == 1     % S(i).x
        for i = 1 : length(S)
            for j = 1 : length(titles)
                data = S(i).(titles{j});
                data = num2str(data);
                table = [table data SEP]; % +data +SEP
            end
            % End of line:
            table = [table(1:end-1) CR LF];  % replace last SEP by CR LF
        end
        
    %    STR = SAVETABLE(S,n)
    
    elseif length(varargin) == 2  % S.x(i)
        n = varargin{2};
       
        % Convert horizontal vectors to vertical / Suppress fields containing scalars
        if n > 1
            for j = length(titles) : -1 : 1
                if size(S.(titles{j}),1) == 1
                    if size(S.(titles{j}),2) == n % if it's a horizontal vector
                        S.(titles{j}) = S.(titles{j})';
                    elseif size(S.(titles{j}),2) == 1 % if it's a scalar
                        S = rmfield(S, titles{j});
                        titles(j) = [];
                    else
                        error(['Invalid number of elements in field "' titles{j} '".'])
                    end
                end
            end
        end
        % Rewrite titles in table (because scalar fields may have been deleted)
        table = '';
        for j = 1 : length(titles)
            table = [table titles{j} SEP]; % +title +SEP
        end
        table = [table(1:end-1) CR LF];  % End of line: remove last SEP and add CR LF
        % Make table
        for i = 1 : n
            for j = 1 : length(titles)
                if iscell(S.(titles{j}))
                    data = S.(titles{j}){i};
                else
                    data = S.(titles{j})(i);
                end
                data = num2str(data);
                table = [table data SEP]; % +data +SEP
            end
            % End of line:
            table = [table(1:end-1) CR LF];  % replace last SEP by CR LF
        end
        
    else
        error('Improper input argments')
        
    end
    
    
%% SAVETABLE(col1,col2,...)
elseif length(varargin) > 1
    
    % Input Arg.: Ensure that vectors are verticals
    for j = 1 : length(varargin)
        if size(varargin{j},1) == 1 && size(varargin{j},2) > 1
            varargin{j} = varargin{j}';
        end
    end

    % 1) Titles
    for j = 1 : length(varargin)
        title = inputname(1 + j);
        if size(varargin{j},2) == 1 || ischar(varargin{j}) % If it's a vector, or any character array..
            table = [table title SEP]; % +title +SEP
        else % If it's a numeric matrix or a cell matrix..
            for col = 1 : size(varargin{j},2)
                table = [table title int2str(col) SEP]; % +title +SEP
            end
        end
    end
    % End of line:
    table = [table(1:end-1) CR LF];  % replace last SEP by CR LF

    % 2) Data
    for i = 1 : size(varargin{1},1)
        for j = 1 : length(varargin)
            arg = varargin{j};
            if ischar(arg) % It's a char. array..
                s = arg(i,:);
                if s == 0, s = 'NaN'; end % 0 in strings cause bugs in C.
                table = [table s SEP];
            else % It's a double or a cell array..
                for col = 1 : size(arg,2)
                    if isnumeric(arg),	data = num2str(arg(i,col));
                    elseif iscell(arg), data = num2str(arg{i,col});
                    end
                    table = [table data SEP]; % +data +SEP
                end
            end
        end
        % End of line:
        table = [table(1:end-1) CR LF];  % replace last SEP by CR LF
    end
    
else
    error('Invalid input arguments.')

end


%% Format table
% Replace underscores by spaces in titles
u = table(1,:) == '_';
table(1,u) = ' ';

% % Align columns horizontally
% titles = table(1,:);
% row = titles;
% row(row~=SEP & row~=CR & row~=LF) = ' ';
% nCols = sum(titles == SEP) + 1;
% nRows = sum(tables == LF);
% aligned = [titles; repmat(row,nRows-1,1)];
% % ....

% % Remove last CR LF  <suppr. 17-11-2010>
% table(end-1:end) = [];


%% Outputs
% 1) Write file
if ~isempty(filename)
    % Case of existing file
    if exist(filename,'file')
        % Check that we have writting permission
        fid = fopen(filename,'a');
        if fid < 0
            msg = {['Matlab has not the permission to write on file "' filename '".'],...
                'The most common cause is that the file is already open in Excel (or some other poorly programmed software).',...
                'In this case, close it in Excel, before to click OK below.',...
                ' '};
            h = warndlg(msg,upper(mfilename));
            uiwait(h);
        else
            fclose(fid);
        end
        
        % Append, Overwrite or Cancel
        if isAppend % '-append' option: Read existing file and concatenate tables
            fid = fopen(filename,'r');
            existing = fscanf(fid,'%c');
            fclose(fid);
            if ~isempty(existing)
                % Add end of line to existing table:
                if ~strcmp(existing(end-1:end),[CR LF])
                    existing(end+1:end+2) = [CR LF];
                end
                % Concatenates tables:
                table = [existing table];
            end
            
        elseif isOverwrite % '-overwrite' option
            dispinfo(mfilename,'warning','Overwriting existing file...')
            
        else % Prompt user
            msg = {['File "' filename '" already exists.'],...
                'Overwrite existing file?',...
                ' ',...
                'Yes: Overwrite.',...
                'No:  Choose another location...',...
                'Cancel: Don''t save.',...
                ' '};
            button = questdlg(msg,upper(mfilename));
            switch button
                case 'Yes'    % Yes: Overwrite!
                    dispinfo(mfilename,'info','Overwriting existing file...')
                case 'No'     % No: Select another file
                    [f,p] = uiputfile(filename,'Save file as:');
                    filename = fullfile(p,f);
                case 'Cancel' % Cancel saving
                    dispinfo(mfilename,'info','Saving canceled by user.')
                    clear table
                    return  % <===!!!
            end
        end
    end

    % Write file
    isError = 0;
    fid = fopen(filename,'w');
    if fid < 0 % Error!
        isError = 1;
        % Save to alternative location
        f = find(ismember(filename,'/\'));
        if isempty(f),  filename2 = fullfile(tmpdir,filename);
        else            filename2 = fullfile(tmpdir,filename(f(end+1):end));
        end
        dispinfo(mfilename,'error',['Error in writting to file "' filename '" !!!']);
        dispinfo(mfilename,'info',['Trying to save to alternative location: "' filename2 '"...']);
        fid = fopen(filename2,'w');
        if fid < 0 % Error again!
            error(['Error again! Error in writting to file "' filename '" !!!'])
        end
        % Prepare error message
        s0 =  ' ';
        s1 = [mfilename ': Cannot write file "' filename '" !!!'];
        s2 =  '         However, YOUR DATA ARE NOT LOST: The text table has been saved to an alternative location:';
        s3 = ['         ' filename2];
        msg = [s0 10 s1 10 s2 10 s3];
    end
    fprintf(fid,'%s',table);
    fclose(fid);
    
    if isError
        error(msg)
    else
        dispinfo(mfilename,'info',['Table successfully saved in file "' filename '".']);
    end
    
end

% 2) Output arg.
if nargout == 0 && ~isempty(filename)
    clear table
end
