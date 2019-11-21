function [keyOut,t,n] = waitkeydown(varargin)
% WAITKEYDOWN  Wait for a key press.
%    [keyNumber,time] = WAITKEYDOWN  Waits for any key press and returns the key ID number and time.
%    
%    [keyOut,time] = WAITKEYDOWN(keyName|keyNumber|keyCode)  waits only for the specified keys.
%    keyOut is at the same format than the input argument (name, number or code). <TODO!>
%
%    [keyOut,time] = WAITKEYDOWN(keyName|keyNumber|keyCode,timeout)  waits no more than given 
%    timeout (ms).
%
%    [keyOut,time] = WAITKEYDOWN(keyName|keyNumber|keyCode,<timeout>,lib)  forces library to use.
%    lib can be 'Cog' or 'PTB'.
%
% See also: OPENKEYBOARD, WAITKEYUP, GETKEYDOWN, GETKEYUP, GETKEYNUMBER, GETKEYCODE, GETKEYNAME.
%
% Ben, Feb. 2009.


global cogent;

t0 = time;

%%%%%%%%%%%%%%
dt = 2.5; % delta time (PTB only).
%%%%%%%%%%%%%%


%% INPUT ARGS

error( nargchk(0,3,nargin) ); % <ben> fix: 1 --> 0

timeout = inf;

if numel(varargin) && strcmp(varargin{end},'up')
    % Called by WAITKEYUP:
    isDown = 0;
    varargin(end) = [];
else
    isDown = 1;
end
    
if numel(varargin) && (strcmpi(varargin{end},'PTB') || strcmpi(varargin{end},'Cog'))
    % Library specified:
    lib = varargin{end};
    varargin(end) = [];
else
    % Library not specified ; use current lib.:
    lib = getlibrary('Keyboard');
end

if nargin && isnumeric(varargin{1}) && length(varargin{1}) == 1 && varargin{1} > 255
    % Backward compat. with Cogent2000
    % Order of argument is the reverse in Cogent2000, but usually timeout=inf.
    % So the first arg. is interpreted as timeout if > 255.
    timeout = varargin{1};
    varargin(1) = [];
end

if numel(varargin),
    keyIn = varargin{1};
else
    keyIn = [];
end

if numel(varargin) >= 2,
    timeout = varargin{2};
end

% keyIn -> keyCode & keyNumber
keyNumber = getkeynumber(keyIn);
if keyNumber == 0 | isnan(keyNumber), keyNumber = []; end % <To be sure, behavior of getkeycode([]) not yet definitively decided.>


%% WAIT KEY PRESS

if strcmpi(lib,'Cog') % Cog
    [keyOut,t,n] = waitkey(timeout,keyNumber,128*isDown);
    
else                  % PTB       <DON'T WORK !!!> <TODO: Rewrite using waitframe>
    while 1
        [isDown,secs,code] = KbCheck;
        n = getkeynumber(code);
        if ~isempty(n) 
            if isempty(keyIn) ...                 % if no key # given..
                    || any(ismember(n,keyNumber)) % or if key pressed is one of key given..
                break  % <--!!                     ..break loop!
            end
        end
        if time - t0 <= timeout - dt
            wait(dt)
        else
            waituntil(t0 + timeout)
            break % !
        end
    end
    if n,   keyOut = n;
    else    keyOut = [];
    end
    
end