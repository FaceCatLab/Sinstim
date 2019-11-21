function [ keyout, t, n ] = waitkey( duration, keyin, event )

% Read previous keypresses.
% Wait for a specific key to be pressed after the call to waitkey.
% All key presses will be automatically read.
%
% Cogent 2000 function.  v1.0
% Ben, Mar. 2008: 		 v1.1	Suppress logging and display in Matlab 
%                 				Command window for timing accuracy.

global cogent;

t0 = time;
keyout = [];
t = [];
n = 0;

% Handle any pending key presses from before waitkey call
readkeys;
% logkeys; % Suppr. by Ben for timing accuracy.

while isempty(keyout)  &  time-t0 < duration

readkeys;
% logkeys; % Suppr. by Ben for timing accuracy.

   if isempty(keyin)
      index = find( cogent.keyboard.value == event );
   else
      index = find( cogent.keyboard.value == event & ismember(cogent.keyboard.id,keyin) );
   end
   
   keyout = cogent.keyboard.id( index );
   t      = cogent.keyboard.time( index );  
   n      = length( index );
   
end
