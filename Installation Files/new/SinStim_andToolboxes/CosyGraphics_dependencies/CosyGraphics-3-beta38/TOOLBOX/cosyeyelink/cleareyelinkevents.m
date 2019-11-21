function cleareyelinkevents
% CLEAREYELINKEVENTS  Clear EyeLink's events and samples queue. 
%    CLEAREYELINKEVENTS  clears the queue.  Note that both events (fixations, saccades, etc.) and  
%    eye samples (position and pupil data) share the same queue.
% 
% See also: GETEYELINKEVENTS, SETEYELINKEVENTS.

% This is a hack: Low level Eyelink() function lacks a ClearQueue sub-function
% and behaves strangely. The following code empirically seems to work.
q1=geteyelinkevents; % first is always empty (don't ask me why...)
q2=geteyelinkevents; % second is always typ 1 + type 25 events (undocumented)
while ~isempty(geteyelinkevents); end % call until we get an empty queue