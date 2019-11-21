function save6(varargin)
% SAVE6  Save in MATLAB 6 format.
%    On MATLAB 6 and below, SAVE6 is the same than SAVE
%    On MATLAB 7 and above, SAVE6 is the same than SAVE ... -V6

% Ben,  Aug 2009

%% Add quotes <Fix spaces in names, 06-07-2010>
for i = 1 : length(varargin)
    if varargin{i}(1) ~= '''';
        varargin{i} = ['''' varargin{i} ''''];
    end
end

%% Build command
v = version;
command = ['save ' cell2char(varargin,1)];
if v(1) >= '7', command = [command '-v6']; end

%% Execut command
evalin('caller',command);