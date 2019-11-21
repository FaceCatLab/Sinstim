function t = sendparallelbyte(varargin)
% SENDPARALLELBYTE  Send one byte through parallel port.
%    SENDPARALLELBYTE(n)  sends number n, an integer in the range 0:255, trough the port
%    open by OPENPARALLELPORT.
%
%    SENDPARALLELBYTE(bits)  'bits' is a vector of binary values.
%
%    SENDPARALLELBYTE(n,...)  send bytes trough LPTn.
%
%    t = SENDPARALLELBYTE(...)  returns time (ms). 
%
% Examples:
%       openparallelport out;               % open the port for output (open the 8 lines)
%       t = sendparallelbyte(8)             % set port value to: 0 0 0 0 1 0 0 0
%       wait(1)                             % let line 3 stay high 1 ms
%       sendparallelbyte(0)                 % reset to 0 (all lines low)
%       t = sendparallelbyte([1 0 1])       % set port value to: 0 0 0 0 0 1 0 1
%       wait(1)                             % let lines 0 and 2 stay high 1 ms
%       sendparallelbyte([0 0 0 0 0 0 0 0]) % reset to 0 (all lines low)

% Ben,  Nov. 2007	v1.0
%       Dec         v1.3  Fix case when no // port
%       Feb. 2009   v2.0  Rewrite
% <TODO: vertical binvec ???>

global GLAB_PARALLELPORT GLAB_IS_RUNNING GLAB_DEBUG

nargchk(1,2,nargin);

%% Check OS: // port supported only on Windows
if ~ispc
    t = NaN;
    return % <---!!!
end

%% Check that // port is open
if isempty(GLAB_PARALLELPORT) % Port is not open.
    if GLAB_IS_RUNNING % G-Lab is running, maybe we are in real-time: impose use of openparallelport.
%         dispinfo(mfilename,'warning','Parallel port not open. See OPENPARALLELPORT.')
        t = -1;
        return % <---!!!
    else % G-Lab is not running, I suppose that we are not in real-time: let's open the port implicitly.
        openparallelport out
    end
end

%% Input args
if nargin >= 2
    PortNum = varargin{1};
else
    PortNum = GLAB_PARALLELPORT.PortNum;
    if length(PortNum) > 1
        error(['More than one // port are open.' 10 ...
            'You must give the port number as first argument to sendparallelbyte.'])
    end
end

value = varargin{end};
if value < 0
    error('SENDPARALLELBYTE: Invalid value. Value cannot be negative.')
elseif value > 255
    warning(['SENDPARALLELBYTE: To high value: ' num2str(value) '. Value has been ceiled to 255.'])
    value = 255;
end

%% Send byte!
if ~isempty(GLAB_PARALLELPORT)
    t0 = time;
    switch GLAB_PARALLELPORT.OptimizationLevel
        case 0,     putvalue(getparallelport(PortNum),value);
        case 0.5,   putvalue(GLAB_PARALLELPORT.PortObject{PortNum},value);
        case 1,     putvalue(GLAB_PARALLELPORT.PortObject{PortNum}.Line,value);
        case 1.5,   putvalue(GLAB_PARALLELPORT.PortLine{PortNum},value);
        case 2,     putvalue(GLAB_PARALLELPORT.PortUddObject{PortNum},value);
    end
    t = time;
    GLAB_PARALLELPORT.dt = t - t0; % For debug purpose
    
else
    t = 0;
end

%% Print events in command window
if value > 0
    glabhelper_dispevent(mfilename,['Sent byte ' int2str(value) '.'],t);
end