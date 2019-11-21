% cosydemo_EyeLink_OnlineEvents  Demontration of EyeLink's capacities.
%    cosydemo_EyeLink_OnlineEvents  lauches the demo program: It will display a round at gaze position and the background
%    will flash in orange/red at each saccade/blink event detected. If the calibration has already be done,
%    it has to have been done at 800x600.
%
% Alex Zenon & Ben Jacob, Sep. 2011.

%% Params
screenRes = [800 600];
generalLum = 0.6;
bkgColor = [0.5 0.5 0.5];
curColor = bkgColor;
eyeCursorSize = 5;

%% Init CosyGraphics & EyeLink
startpsych(1,screenRes,bkgColor);
openeyelink;
% if ~checkeyelink('iscalibrated') % <v3-beta0: checkeyelink('iscalibrated') seems bugged. FIXME!>
%     calibeyelink C HV5;
% end
starteyelinkrecord; 

%% Main Loop
[w,h] = getscreenres;
xyText = [0, -h/2+25];
lastEvent = '';

while 1
    q = geteyelinkevents; % get all queued events into 'q' structure
    curColor = bkgColor;
    if ~isempty(q)
        lastEvent = q(end).name;
        switch lastEvent
            case 'STARTSACC',  curColor = [1 1 0];  % saccade: yellow flash
keep=q;
tt = Eyelink('TrackerTime') * 1000;
tm = time;
            case 'STARTBLINK', curColor = [0 .5 1];  % blink: cyan flash
        end 
        fprintf([lastEvent '\n'])
    end
    clearbuffer(0,curColor);
    draw('round',[1 1 1],0,geteye,eyeCursorSize);
    if ~isempty(lastEvent)
        drawtext(lastEvent, 0, xyText, 30);
    end
    t = displaybuffer(0,oneframe);
    
    if isabort % (isabort: true if user pressed Esc)
        break  % <--!!
    end
end

%% Stop All
stopcogent;
workspaceexport;