function table = savetxt(filename,varargin) % <TODO: Rename SAVETABLE ???>
% SAVETXT  Save Matlab variable(s) in standard text format (readable by e.g. Excell).
%    This function saves any type of Matlab variables as a standard table (TAB delimited ASCII 
%    table) in a text file (*.txt) which will be readable by other programs like Excell, Statistica 
%    or SPSS. Alternatively, it can output the table as a string vector. Variable to be saved can 
%    be of many types. See below:
%
%    SAVETXT(filename,col1,...,colN)  converts variables col1 to colN into an ascii table. col* 
%    arguments can be numerical vectors or matrices, string arrays or cell arrays. Variable names 
%    give column titles for the table.
%
%       Example: 
%          Two vectors: "x" and "y",
%
%          savetxt('myfile.txt',x,y)  will generate an two columns table ('x' and 'y') 
%          �������������������������  with one row per vector element.
%
%    SAVETXT(filename,S,n)  converts structure S to ASCII table. S is a scalar structure of vectors.
%    Each field contains n elements vectors or n-by-m matrices. n is the number of rows in the table.
%    Field names give column titles for the table. <TODO: cell arrays>
%
%       Example: 
%          "perTrial" structure, with two fields: "x" and "y",
%           as perTrial.x(i) is the x value for trial #i,
%              �������������
%           nTrials = length(perTrial);
%           savetxt('myfile.txt',perTrial,nTrials)  will generate an two columns table ('x' and 'y') 
%           ��������������������������������������  with one row per trial.
%
%    SAVETXT(filename,S)  converts structure S to ASCII table. The structure S is a vector, with one
%    element per row in the table.
%
%       Example: 
%          "perTrial" structure, with two fields: "x" and "y",
%          as perTrial(i).x is the x value for trial #i,
%             �������������
%          savetxt('myfile.txt',perTrial)  will generate an two columns table ('x' and 'y') 
%          ������������������������������  with one row per trial.
%
%    SAVETXT(filename,M,<C>)  converts the numeric matrix M to ASCII table. The optionnal argument C 
%    is a cell horizontal vector and contains the column titles. If 'titles' is missing or empty, 
%    columns have no titles.
%
%       Example: 
%          An N-by-2 matrix XY,
%
%          savetxt('myfile.txt',XY,{'x','y'})  will generate an two columns table ('x' and 'y')
%          ����������������������������������  with N rows.
%
%    STR = SAVETXT(filename,...)  returns the ascii table as a string vector. If 'filename' is a
%    valid file name, the table will be also saved in file. If 'filename' is empty, no file will be
%    saved.
%
%    SAVETXT(filename,...,'-append')  if file already exists, append table in it, instead of  
%    replacing file. If file does not exist, creates it as normally. NB: The existing file is 
%    supposed to have been created by SAVETXT itself, if if has been created by any other program, 
%    consistency is not ensured.
%
%
% See also: STDTEXTREAD, READTXT, WRITETXT.
% 
%
% Ben,  08 Jan 2010.
%       17 Nov 2010:  Add '-append' option.

% <TODO: cell arrays>


%% Input Args: Options
options = findoptions(varargin);
isAppend = 0;
for i = options;
    if strcmpi(varargin(i),'-append'),  isAppend = 1;
    else     error(['Unknown option: ' varargin(i)]);
    end
end
varargin(options) = [];


%% Vars
% Init
table = [];
isTitles = 1;

% We use TAB as column separator:
TAB = char(9);  % tabulation
% End of line on MS-Windows is CR+LF
LF  = char(10); % line feed
CR  = char(13); % carriage return:


%% SAVETXT(M,<C>)
if length(varargin) == 1 && isnumeric(varargin{1}) && size(varargin{1},2) > 1 ...       % SAVETXT(M)
|| length(varargin) == 2 && isnumeric(varargin{1}) && iscell(varargin{2}) && ...        % SAVETXT(M,C)
   ( size(varargin{2},2) == size(varargin{1},1) || size(varargin{2},2) == 0 )  
       
       table = [];
       M = varargin{1};
       
       % 1) Titles
       if length(varargin)==2 && iscell(varargin{2}) && size(varargin{2},1)==1;
           if ~isAppend || ~exist(filename,'file') % Use titles only if we are creating a new file
               C = varargin{2};
               if length(C) > 0 && length(C) ~= size(M,2)
                   error('Number of column titles does not match number of columns.')
               end
               for i = 1 : length(C)
                   table = [table C{i} TAB]; % +title +TAB
               end
               % End of line:
               table = [table(1:end-1) char([CR LF])];  % replace last TAB by CR LF
           end
       end
       
       % 2) Data
       for i = 1 : size(M,1)
           for j = 1 : size(M,2)
               data = num2str(M(i,j));
               table = [table data TAB]; % +data +TAB
           end
            % End of line:
            table = [table(1:end-1) char([CR LF])];  % replace last TAB by CR LF
       end
%        table(end-1:end) = []; % Remove last linefeed and carriage return <???>


%% SAVETXT(S,<n>)
elseif isstruct(varargin{1})
    S = varargin{1};
    
    % 1) Titles
    titles = fieldnames(S);

    for j = 1 : length(titles)
        table = [table titles{j} TAB]; % +title +TAB
    end
    table = [table(1:end-1) CR LF];  % End of line: remove last TAB and add CR LF

    % 2) Data
    %    STR = SAVETXT(S)
    if length(varargin) == 1     % S(i).x
        for i = 1 : length(S)
            for j = 1 : length(titles)
                data = S(i).(titles{j});
                data = num2str(data);
                table = [table data TAB]; % +data +TAB
            end
            % End of line:
            table = [table(1:end-1) CR LF];  % replace last TAB by CR LF
        end
        
    %    STR = SAVETXT(S,n)
    elseif length(varargin) == 2  % S.x(i)
        n = varargin{2};
        
        % Convert horizontal vectors to vertical
        if n > 1
            for j = 1 : length(titles)
                if size(S.(titles{j}),1) == 1
                    if size(S.(titles{j}),2) == n % if it's a horizontal vector
                        S.(titles{j}) = S.(titles{j})';
                    else
                        error(['Invalid number of elements in field "' titles{j} '".'])
                    end
                end
            end
        end
        % Make table
        for i = 1 : n
            for j = 1 : length(titles)
                if iscell(S.(titles{j}))
                    data = S.(titles{j}){i};
                else
                    data = S.(titles{j})(i);
                end
                data = num2str(data);
                table = [table data TAB]; % +data +TAB
            end
            % End of line:
            table = [table(1:end-1) CR LF];  % replace last TAB by CR LF
        end
    else
        
        error('Improper input argments')
    end
    
    
%% SAVETXT(col1,col2,...)
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
            table = [table title TAB]; % +title +TAB
        else % If it's a numeric matrix or a cell matrix..
            for col = 1 : size(varargin{j},2)
                table = [table title int2str(col) TAB]; % +title +TAB
            end
        end
    end
    % End of line:
    table = [table(1:end-1) CR LF];  % replace last TAB by CR LF

    % 2) Data
    for i = 1 : size(varargin{1},1)
        for j = 1 : length(varargin)
            arg = varargin{j};
            if ischar(arg) % It's a char. array..
                s = arg(i,:);
                if s == 0, s = 'NaN'; end % 0 in strings cause bugs in C.
                table = [table s TAB];
            else % It's a double or a cell array..
                for col = 1 : size(arg,2)
                    if isnumeric(arg),	data = num2str(arg(i,col));
                    elseif iscell(arg), data = num2str(arg{i,col});
                    end
                    table = [table data TAB]; % +data +TAB
                end
            end
        end
        % End of line:
        table = [table(1:end-1) CR LF];  % replace last TAB by CR LF
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
% row(row~=TAB & row~=CR & row~=LF) = ' ';
% nCols = sum(titles == TAB) + 1;
% nRows = sum(tables == LF);
% aligned = [titles; repmat(row,nRows-1,1)];
% % ....

% Remove last CR LF
table(end-1:end) = [];


%% Outputs
% 1) Write file
if ~isempty(filename)
    % Add extention ?
    if ~any(filename == '.')
        filename(end+1:end+4) = '.txt';
    end
    
    % '-Append' option: Read existing file and concatenate tables
    if isAppend && exist(filename,'file')
        fid = fopen(filename,'r');
        existing = fscanf(fid,'%c');
        fclose(fid);
        if ~isempty(fid)
            % Add end of line to existing table:
            if ~strcmp(existing(end-1:end),[CR LF])
                existing(end+1:end+2) = [CR LF];
            end
            % Concatenates tables:
            table = [existing table];
        end
    end
    
    % Write file
    fid = fopen(filename,'w');
    if fid < 0
        varname = [mfilename '_table'];
        assignin('base',varname,table);
        s0 =  ' ';
        s1 = ['SAVETXT: Cannot write file "' filename '" !!!'];
        s2 =  '         However, YOUR DATA ARE NOT LOST: The text table as been exported';
        s3 = ['         to Matlab''s workspace in a variable named "' varname '".'];
        s4 =  '         Save it manually if needed.';
        error([s0 10 s1 10 s2 10 s3 10 s4]);
    end
    fprintf(fid,'%s',table);
    fclose(fid);
end

% 2) Output arg.
if nargout == 0 && ~isempty(filename)
    clear table
end