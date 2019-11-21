function  err = cyclesprites(xtable,ytable,stable,overlaypages)
% cyclesprites(XTABLE,YTABLE,STABLE)   Blit sprites made by sprites4rts using page cycling
%
% cyclesprites   Uses global XTABLE, YTABLE and STABLE variables (made by data4rts)


% ben   mai-juin 2005
%       dec 2006: overlay


global XTABLE YTABLE STABLE OVERLAYPAGES USE_EYELINK
global SPRITEPAGE SPRITEPOS ERROR_RTS
globalvsg


if ERROR_RTS
    return
end


if nargin
    XTABLE = xtable;
    YTABLE = ytable;
    STABLE = stable;
    if nargin == 4, OVERLAYPAGES = overlaypages;
    else,           OVERLAYPAGES = zeros(1,size(XTABLES,2));
    end
end
    

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

if USE_EYELINK,
	err = Eyelink('StartRecording');
	if err ~= 0,
		fprintf('Eyelink recording error, aborting trial.  Check connection, camera power, etc.\n');
		Eyelink('StopRecording');
		return
	end
	waitSecs(0.050);
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

for i = nbPages + 1 : nbImages,  % (i = index of frame)
    

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
    
    % Wait until cycling state changes
%     while cs == getpagecyclingstate(length(Sequence)),
%     end     
    
end

if USE_EYELINK,
	Eyelink('StopRecording');
	priority(0);	% return to normal priority
end

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