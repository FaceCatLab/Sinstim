function [keyOut,t,n] = waitkeydown(varargin)
% WAITKEYDOWN  Wait for a key press.
%    [keyNumber,time] = WAITKEYDOWN  Waits for any key press and returns the key ID number and time.
%    
%    [keyOut,time] = WAITKEYDOWN(keyName|keyNumber|keyCode)  waits only for the specified keys.
%    keyOut is at the same format than the input argument (name, number or code). <TODO!>
%
%    [keyOut,time] = WAITKEYDOWN(keyName|keyNumber|keyCode, TimeOut)  waits no more than given 
%    timeout (ms).
%
%    [keyOut,time] = WAITKEYDOWN(keyName|keyNumber|keyCode, t0, TimeOut)  <TODO>
%
%    [keyOut,time] = WAITKEYDOWN(...,'-noclear')   <Cogent only!> doesn't clear the keyboard queue 
%    before to start waiting. (Returns immediately if a key press was alread recorded in the queue.)
%    Use CLEARKEYS before to clear the queue explicitely.
%
%    [keyOut,time] = WAITKEYDOWN(...,lib)  forces library to be used.  'lib' can be 'Cog' or 'PTB'.
%
% See also: OPENKEYBOARD, WAITKEYUP, GETKEYDOWN, GETKEYUP, GETKEYNUMBER, GETKEYCODE, GETKEYNAME.
%
% Ben, Feb. 2009.


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
    lib = getcosylib('Keyboard');
end

if numel(varargin) && strcmpi(varargin{end},'-noclear') % <v3-beta19: New option.>
    doClear = 0;
    varargin(end) = [];
    if isptb('Keyboard'), warning('''-noclear'' option not supported over PsychTB.'), end
else
    doClear = 1;
end

if numel(varargin) && isnumeric(varargin{1}) && length(varargin{1}) == 1 && varargin{1} > 255
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
    if doClear, readkeys; end  % <v3-beta19: Now outside of readkeys>
    [keyOut,t,n] = sub_waitkey(timeout,keyNumber,128*isDown); % <v3-beta19: Beacame a sub-fun>
    
else                  % PTB       <DON'T WORK !!!> <TODO: Rewrite using waitframe>
    t = NaN;
    while 1
        [isDown,secs,code] = KbCheck;
        n = getkeynumber(code);
        if ~isempty(n) 
            if isempty(keyIn) ...                 % if no key # given..
                    || any(ismember(n,keyNumber)) % or if key pressed is one of key given..
                t = time;
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

%% %%%%%%%%%%%%%%% SUB-FUN %%%%%%%%%%%%%%% %%
function [ keyout, t, n ] = sub_waitkey( duration, keyin, event )
% Read previous keypresses.
% Wait for a specific key to be pressed after the call to waitkey.
% All key presses will be automatically read.
%
% Cogent 2000 function.  v1.0
% Ben, Mar. 2008: 		 v1.1	Suppress logging and display in Matlab's command window for timing accuracy.           				

global cogent;

t0 = time;
keyout = [];
t = [];
n = 0;

% Handle any pending key presses from before waitkey call
% readkeys; %<Suppr. by Ben CosyGraphics 3-beta19.>
% logkeys; %<Suppr. by Ben for timing accuracy.>

while isempty(keyout)  &  time-t0 < duration

readkeys;
% logkeys; %<Suppr. by Ben for timing accuracy.>

   if isempty(keyin)
      index = find( cogent.keyboard.value == event );
   else
      index = find( cogent.keyboard.value == event & ismember(cogent.keyboard.id,keyin) );
   end
   
   keyout = cogent.keyboard.id( index );
   t      = cogent.keyboard.time( index );  
   n      = length( index );
   
end