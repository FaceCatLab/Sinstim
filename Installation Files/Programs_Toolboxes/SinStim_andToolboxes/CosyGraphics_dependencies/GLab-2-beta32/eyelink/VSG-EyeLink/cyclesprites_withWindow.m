function  err = cyclesprites_withWindow(windowSpecs)
% cyclesprites(XTABLE,YTABLE,STABLE)   Blit sprites made by sprites4rts using page cycling
%
% cyclesprites   Uses global XTABLE, YTABLE and STABLE variables (made by data4rts)


% ben    mai-juin 2005
%        dec 2006: overlay
% JBB    mar 2008: adapted for EyeLink
% JBB/SC aug 2008: eye position window


global XTABLE YTABLE STABLE OVERLAYPAGES USE_EYELINK
global SPRITEPAGE SPRITEPOS ERROR_RTS
globalvsg


if ERROR_RTS
    return
end

% default windows parameters
if nargin == 0,
	windowSpecs.xCenter = pix2deg(XTABLE');		% centered on target (deg)
	windowSpecs.yCenter = pix2deg(YTABLE');
	windowSpecs.xWidth = 20;			% width (i.e., length of side) (deg)
	windowSpecs.yWidth = 20;
	windowSpecs.gracePeriod = Inf;		% grace period (can be outside of window) (msec)
end
initialGracePeriod = 500;	% 500 msec grace period at trial onset to acquire fixation point

[xMinus, xPlus, yMinus, yPlus] = ...
	inverseCalibration(	windowSpecs.xCenter, windowSpecs.yCenter, ...
						windowSpecs.xWidth, windowSpecs.yWidth);
gracePeriod = windowSpecs.gracePeriod;	% note: time values in msec so no conversion needed
xWidth = windowSpecs.xWidth/2;			% precalculate half-widths
yWidth = windowSpecs.yWidth/2;

% 
% Initialisation
% ---------------------------------------------------------------

nbPages = max(getpageindex(1:32));
nbImages = size(XTABLE,2);

err = 0;
CS = [];

%%% %%%%%%%%%%%%%%%%%%%%%%%% %%%

% Convert sprite positions :

spritepos = SPRITEPOS;
% Convert coord. : upper-left corner --> center of the sprite
spritepos(:,1) = spritepos(:,1) + spritepos(:,3) / 2;
spritepos(:,2) = spritepos(:,2) + spritepos(:,4) / 2;
% Convert origin : upper-left corner --> center of the screen
spritepos(:,1) = spritepos(:,1) - crsGetScreenWidth  / 2;
spritepos(:,2) = spritepos(:,2) - crsGetScreenHeight / 2;

%%% %%%%%%%%%%%%%%%%%%%%%%%% %%%


% Prepare page cycling
% ---------------------------------------------------------------

% Get struct. array for vsgPageCyclingSetup
Sequence = getsequence(nbImages);

% % Set overlay pages
% for i = 1 : length(Sequence)
%     Sequence(i).ovPage = OVERLAYPAGES(i);
% %     if (i == 1 && OVERLAYPAGES(1) ~= 0) || (i > 1 && Sequence(i).ovPage ~= Sequence(i-1).ovPage)
%     if (i > 1 && Sequence(i).ovPage ~= Sequence(i-1).ovPage)
%         Sequence(i).Page = Sequence(i).Page + vsgDUALPAGE;
%     end
% end

% Add trigger flag for first image
if ~isvisage, %(BUG WITH TRIGGER CODES WITH VISAGE (2))
    Sequence(1).Page = Sequence(1).Page + vsgTRIGGERPAGE; %Trigger on first image displayed
end

% Add a black image at the end, with stop & trigger flags
if ~isvisage,   theend.Page = 0 + vsgTRIGGERPAGE;
else,           theend.Page = 0; %(BUG WITH TRIGGER CODES WITH VISAGE)
end
theend.Xpos   = 0;
theend.Ypos   = 0;
theend.ovPage = 0;
theend.ovXpos = 0;
theend.ovYpos = 0;
theend.Frames = 1;
theend.Stop   = 1;
Sequence = [Sequence theend];  

% nbImages = length(Sequence);  %%!

vsg(vsgPageCyclingSetup,length(Sequence),Sequence)  % cycling setup
vsg(vsgSetCommand,vsgVIDEODRIFT)          % allow videowindow changes (for normal video RAM)


% First draw loop : draw on the framestore pages before cycling begins
% ---------------------------------------------------------------------

vsg(vsgSetCommand,vsgCYCLEPAGEDISABLE) %(ADDED FOR VISAGE (3))
vsg(vsgSetZoneDisplayPage, vsgVIDEOPAGE, 0); %(ADDED FOR VISAGE (4))

for i = 1 : nbPages,  % (i = index of frame)
    
    vsg(vsgSetDrawPage, vsgVIDEOPAGE, getpageindex(i), 0);
    
    %%% INSERT DRAW CODE HERE %%%
    
    for t = 1 : size(STABLE,1) % (t = index of target)
            
        sprite = STABLE(t,i);
        
        if sprite           
            x0 = spritepos(sprite,1);
            y0 = spritepos(sprite,2);
            w  = spritepos(sprite,3);
            h  = spritepos(sprite,4);
            x1 = XTABLE(t,i);
            y1 = YTABLE(t,i);          
            vsg(vsgDrawMoveRect,vsgVIDEOPAGE,SPRITEPAGE,x0,y0,w,h,x1,y1,w,h);
        end
    end
    
    %%% %%%%%%%%%%%%%%%%%%%%%%%% %%%
end
i = nbPages + 1;	% ready for second draw loop, below

% initialize eye-position check variables 
state = 0;		% 0 = in window; 1 = outside
tExit = Inf;	% time that eye left window
abort = 0;
eye_used = 0;	% always get left eye sample
xx = 0; yy = 0; tt = 0;	t0 = 0;		% initialize variables outside of RT loop

%%% DEBUGGING %%%
dump.winXminus = xMinus;			% initialize fields of save structure
dump.winXplus = xPlus;
dump.winYminus = yMinus;
dump.winYplus = yPlus;
dump.eyeX = zeros(nbPages+1, 1);
dump.eyeY = zeros(nbPages+1, 1);
dump.time = zeros(nbPages+1, 1);
dump.state = repmat(-1, nbPages+1, 1);
dump.targX = repmat(NaN, nbPages+1, 1);
dump.targY = repmat(NaN, nbPages+1, 1);

if USE_EYELINK,
	err = Eyelink('StartRecording');
	if err ~= 0,
		fprintf('Eyelink recording error, aborting trial.  Check connection, camera power, etc.\n');
		Eyelink('StopRecording');
		return
	end
	waitSecs(0.050);	% give the recording time to start
	evt = Eyelink('newestfloatsample'); 	% get initial sample for time value
	t0 = evt.time;
	priority(2);		% set max priority
end

% Start cycling
% ---------------------------------------------------------------------

vsg(vsgSetCommand,vsgCYCLEPAGEENABLE)  % START PAGE CYCLING !!!

cs = -1;
while cs == -1, % Wait cycling begins actually (FOR VISAGE (1))
    cs = getpagecyclingstate(length(Sequence)); % Get cycling state (values begin at 0)
end

if USE_EYELINK,
	Eyelink('Message', 'TRIALSYNCTIME');
	priority(1);	% lower priority OK for buffer refresh loop
end

% Second draw loop : refresh framestore pages during cycling
% ---------------------------------------------------------------------

while i <= nbImages && ~abort,  % (i = index of frame)   

    % Wait until videowindow has been moved
    while cs < i-nbPages & cs ~= -1,
        cs = getpagecyclingstate(length(Sequence));
    end
    CS(i) = cs;
    
  % vsg(vsgSetDrawPage, vsgVIDEOPAGE, getpageindex(i-nbPages), 0); %??? pq i-nbPages ???
    vsg(vsgSetDrawPage, vsgVIDEOPAGE, getpageindex(i), 0);
    
    %%% INSERT DRAW CODE HERE %%%
    
    for t = 1 : size(STABLE,1) % (t = index of target)
        
        sprite = STABLE(t,i);
        
        if sprite
            x0 = spritepos(sprite,1);
            y0 = spritepos(sprite,2);
            w  = spritepos(sprite,3);
            h  = spritepos(sprite,4);
            x1 = XTABLE(t,i);
            y1 = YTABLE(t,i);
            vsg(vsgDrawMoveRect,vsgVIDEOPAGE,SPRITEPAGE,x0,y0,w,h,x1,y1,w,h);
        end
    end
    
    %%% %%%%%%%%%%%%%%%%%%%%%%%% %%%

	% sample position from Eyelink
	evt = Eyelink('newestfloatsample'); 	% get the sample
	xx = evt.px(eye_used+1);      			% get raw pupil position from sample 
	yy = evt.py(eye_used+1);
	tt = evt.time;							% get time stamp from sample

	% check if eye is out of window
	% note that NaN boundries will skip check
	if 	(	( ~isnan(xMinus(i)) && xx < xMinus(i) ) || ...
			( ~isnan(xMinus(i)) && xx > xPlus(i)  ) || ...
			( ~isnan(yMinus(i)) && yy < yMinus(i) ) || ...
			( ~isnan(yMinus(i)) && yy > yPlus(i)  )    ) && ...
		(tt - t0 > initialGracePeriod),
		if state == 0,	% if we are transitioning from state 0 to 1, start the exit timer
			tExit = tt;
			state = 1;
		end				% otherwise the state and timer mark are unchanged
	else	% eye is in window!
		if state == 1,	% move back to normal state and reset exit timer
			state = 0;
			tExit = Inf;
		end				% otherwise don't need to do anything
	end

	% if eye is out of window, check if exit timer has expired
	if state && (tt - tExit > gracePeriod),
		abort = 1;
		vsg(vsgSetCommand,vsgCYCLEPAGEDISABLE)  		% halt page cycling ASAP
		vsg(vsgSetZoneDisplayPage, vsgVIDEOPAGE, 0);	% blanks target
	end

	% DEBUG
	dump.eyeX(i) = xx;
	dump.eyeY(i) = yy;
	dump.time(i) = tt;
	dump.state(i) = state;
	dump.targX(i) = x1;
	dump.targY(i) = y1;

	i = i + 1;

    % Wait until cycling state changes
%     while cs == getpagecyclingstate(length(Sequence)),
%     end     
    
end

if USE_EYELINK,
	Eyelink('StopRecording');
	priority(0);	% return to normal priority
end

assignin('base', 'dump', dump);
assignin('base', 'windowSpecs', windowSpecs);
assignin('base', 'evt', evt);

% vsg(vsgIOWriteDigitalOut,1,vsgDIG2);

% ---------------------------------------------------------------------

%Error tests
CS;
cycling_delays = testcycling(CS);
disp(['Page cycling finished. Delays:  [ ' num2str(testcycling(CS)) ' ]'])
% if cycling_delays, CS, end
if sum(cycling_delays) >= max(getpageindex(1:99))
    err = 1;
end
if err
    disp('!!! PAGE CYCLING FAILURE !!!');
end