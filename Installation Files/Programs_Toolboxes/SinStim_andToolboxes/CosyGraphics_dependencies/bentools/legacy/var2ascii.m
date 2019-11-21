function text = var2texttable(varargin)
% VAR2TEXTTABLE  Convert Matlab variable(s) to a TAB delimited ASCII table.
%    STR = VAR2TEXTTABLE(col1,...,colN)  converts variables col1 to colN into an ascii table. col* 
%    arguments can be numerical vectors or matrices, string arrays or cell arrays. Variable names 
%    give column titles for the table.
%
%       Example: Two vectors: "x" and "y",
%
%                var2texttable('MyFile.txt',x,y)  will generate an two columns table ('x' and 'y') 
%                                                 with one row per vector element.
%
%    STR = VAR2TEXTTABLE(S,n)  converts structure S to ASCII table. S is a scalar structure of vectors.
%    Each field contains n elements vectors or n-by-m matrices. n is the number of rows in the table.
%    Field names give column titles for the table. <TODO: cell arrays>
%
%       Example: "perTrial" structure, with two fields: "x" and "y",
%                as perTrial.x(i) is the x value for trial #i,
%                             ¯¯¯
%                var2texttable('MyFile.txt',perTrial)  will generate an two columns table ('x' and 'y') 
%                                                      with one row per trial.
%
%    STR = VAR2TEXTTABLE(S)  converts structure S to ASCII table. The structure S is a vector, with one
%    element per row in the table.
%
%       Example: "perTrial" structure, with two fields: "x" and "y",
%                as perTrial(i).x is the x value for trial #i,
%                           ¯¯¯
%                var2texttable('MyFile.txt',perTrial)  will generate an two columns table ('x' and 'y') 
%                                                      with one row per trial.
%
%    STR = VAR2TEXTTABLE(M,<C>)  converts the numeric matrix M to ASCII table. The optionnal argument C 
%    is a cell horizontal vector and contains the column titles. If 'titles' is missing or empty, 
%    columns have no titles.
%
%       Example: An N-by-2 matrix XY,
%
%                var2texttable('MyFile.txt',XY,{'x','y'})  will generate an two columns table ('x' and 'y')
%                                                          with N rows.
%
% Ben, 8 Jan 2010.

% <TODO: cell arrays>


%% Vars
% Init
text = [];

% We use TAB as column separator:
TAB = char(9);  % tabulation
% End of line on MS-Windows is CR+LF
LF  = char(10); % line feed
CR  = char(13); % carriage return:


%% VAR2TEXTTABLE(M,<C>)
if nargin == 1 && isnumeric(varargin{1}) && size(varargin{1},2) > 1 ...       % VAR2TEXTTABLE(M)
|| nargin == 2 && isnumeric(varargin{1}) && iscell(varargin{2}) && ...        % VAR2TEXTTABLE(M,C)
   ( size(varargin{2},2) == size(varargin{1},1) || size(varargin{2},2) == 0 )  
       
       text = [];
       
       % 1) Titles
       if nargin==2 && iscell(varargin{2}) && size(varargin{2},1)==1;
           C = varargin{2};
           for i = 1 : length(C)
               text = [text C{i} TAB]; % +title +TAB
           end
           % End of line:
            text = [text(1:end-1) char([CR LF])];  % replace last TAB by CR LF
       end
       
       % 2) Data
       M = varargin{1};
       for i = 1 : size(M,1)
           for j = 1 : size(M,2)
               data = num2str(M(i,j));
               text = [text data TAB]; % +data +TAB
           end
            % End of line:
            text = [text(1:end-1) char([CR LF])];  % replace last TAB by CR LF
       end
%        text(end-1:end) = []; % Remove last linefeed and carriage return <???>

       
%% VAR2TEXTTABLE(S,<n>)
elseif isstruct(varargin{1})
    S = varargin{1};
    
    % 1) Titles
    titles = fieldnames(S);

    text = [];

    for j = 1 : length(titles)
        text = [text titles{j} TAB]; % +title +TAB
    end
    text = [text(1:end-1) CR LF];  % End of line: remove last TAB and add CR LF

    f = find(text == '_');
    text(f) = repmat(' ',1,length(f));  % replace underscores by spaces

    % 2) Data
    %    STR = VAR2TEXTTABLE(S)
    if length(S) > 1 % Vector structure
        for i = 1 : length(S)
            for j = 1 : length(titles)
                data = S(i).(titles{j});
                data = num2str(data);
                text = [text data TAB]; % +data +TAB
            end
            % End of line:
            text = [text(1:end-1) CR LF];  % replace last TAB by CR LF
        end
        
    %    STR = VAR2TEXTTABLE(S,n)
    else             % Scalar structure of vectors
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
                    data = S.(titles(j))(i);
                end
                data = num2str(data);
                text = [text data TAB]; % +data +TAB
            end
            % End of line:
            text = [text(1:end-1) CR LF];  % replace last TAB by CR LF
        end
    end
    
    
%% VAR2TEXTTABLE(col1,col2,...)
elseif nargin > 1
    
    % Input Arg.: Ensure that vectors are verticals
    for j = 1 : length(varargin)
        if size(varargin{j},1) == 1 && size(varargin{j},2) > 1
            varargin{j} = varargin{j}';
        end
    end

    % 1) Titles
    for j = 1 : length(varargin)
        title = inputname(j + nargin - length(varargin));
        if size(varargin{j},2) == 1 || ischar(varargin{j}) % If it's a vector, or any character array..
            text = [text title TAB]; % +title +TAB
        else % If it's a numeric matrix or a cell matrix..
            for col = 1 : size(varargin{j},2)
                text = [text title int2str(col) TAB]; % +title +TAB
            end
        end
    end
    % End of line:
    text = [text(1:end-1) CR LF];  % replace last TAB by CR LF

    % 2) Data
    for i = 1 : size(varargin{1},1)
        for j = 1 : length(varargin)
            arg = varargin{j};
            if ischar(arg) % It's a char. array..
                s = arg(i,:);
                if s == 0, s = 'NaN'; end % 0 in strings cause bugs in C.
                text = [text s TAB];
            else % It's a double or a cell array..
                for col = 1 : size(arg,2)
                    if isnumeric(arg),	data = num2str(arg(i,col));
                    elseif iscell(arg), data = num2str(arg{i,col});
                    end
                    text = [text data TAB]; % +data +TAB
                end
            end
        end
        % End of line:
        text = [text(1:end-1) CR LF];  % replace last TAB by CR LF
    end
    
else
    error('Invalid input arguments.')

end