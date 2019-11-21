function t = setparallelbit(varargin)
% SETPARALLELBIT
%    SETPARALLELBIT(iPort,i,value)
%
%    SETPARALLELBIT(iPort,i,value)

% Running time: 240 µsec on DARTAGNAN, on Matlab 7.5.

%% Global Vars
global GLAB_PARALLELPORT

if isempty(GLAB_PARALLELPORT)
    error('Parallel port not open. See OPENPARALLELPORT.')
end

%% Input Args
if nargin == 2
    iPort = 1;
elseif nargin == 2
    iPort = varargin{1};
else
    error('Wrong number of arguments.')
end

i = varargin{end-1};
value = varargin{end};

if any(i < 1) || any(i > 8)
    error('Invalid input argument. Line numbers must be integers between 1 and 8.')
end
if ~all(value == 0 | value == 1)
    error('Invalid input argument. Line values must be 0s or 1s.')
end

%% Put Value
% old = GLAB_PARALLELPORT.CurrentByte;
% b = 2^(i-1) .* value;
% new = floor(old/2^i)*2^i + b + rem(old,2^(i-1));

putvalue(GLAB_PARALLELPORT.PortLine{iPort}(i),value);

%% Output Arg
if nargout
    t = time;
end