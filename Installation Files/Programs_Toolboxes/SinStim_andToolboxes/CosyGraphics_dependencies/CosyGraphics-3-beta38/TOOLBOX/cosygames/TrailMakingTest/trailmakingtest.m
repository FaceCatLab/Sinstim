function responses = trailmakingtest(XY,Condition,varargin)
% TRAILMAKINGTEST  Trail-making test.
%    responses = TRAILMAKINGTEST(XY,Condition<,TimeOut>)
%
%    responses = TRAILMAKINGTEST(XY,Condition<,TimeOut>,'PropertyName1',PropertyValue1,'PropertyName2',PropertyValue2,...)
%
%    responses = TRAILMAKINGTEST(...)
%
% Example:
%       XY = maketrail(25,50,4);
%       responses = trailmakingtest(XY,'B');

if ~isopen('display'), error('No display open.'); end
resetabortflag;

%% Input Args
% XY, N:
N = size(XY,1);
%Condition:
switch upper(Condition)
    case 'A'
        CircleLabels = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32'};
    case 'B'
        CircleLabels = {'1','A','2','B','3','C','4','D','5','E','6','F','7','G','8','H','9','I','10','J','11','K','12','L','13','M','14','N','15','O','16','P'};
    otherwise
        stopcosy;
        error('Invalid "Condition" argument: Condition must be ''A'' or ''B''.')
end
% TimeOut:
if nargin>2 && isnumeric(varargin{1})
    TimeOut = varargin{1};
    varargin(1) = [];
    if isempty(TimeOut), TimeOut = inf; end
else
    TimeOut = inf;
end
% Properties: (Defaults are defined in GETTRAILPROPERTIES.)
if ~isempty(varargin)
    settrailproperties(varargin{:});
end
Prop = gettrailproperties;

%% Vars
RGB = repmat(Prop.ColorUnselected,N,1);
RGB(1,:) = Prop.ColormapFunction(1);
% RGB(1,:) = Prop.ColorSelected;

%% Load Sounds
fullname = fullfile(whichdir(mfilename),'sounds',Prop.WinningSoundFile);
[y,fs] = loadsound(fullname);
WinningSound.y = y';
WinningSound.fs = fs;

%% Init Display
% startpsych;

% switch Prop.Mode
%     case 0
%         XY = randxy(N,'round',Prop.ExclusionDiameter);
%     case 1
%         tic
%         XY = maketrail(N, Prop.ExclusionDiameter, Prop.NbOfReachableNeighbors);
%         toc
%     case 2
%         TrailNum = 2; %<debug>
%         M = dlmread(fullfile(whichdir(mfilename),'Trails.txt'));
%         XY = zeros(size(M,1),2);
%         XY = M(:,2*TrailNum-1:2*TrailNum) - 300;
% end

OffscreenBuffer = newbuffer;
b = OffscreenBuffer;
draw('rounddots', RGB, b, XY, Prop.CircleDiameter);
draw('rounddots', Prop.ColorInterior, b, XY, Prop.CircleDiameter-2*Prop.LineWidth);
for i=1:N
    xy = XY(i,:) + [0 Prop.FontOffset];
    drawtext(CircleLabels{i}, b, xy, RGB(i,:), Prop.FontSize);
end
displaybuffer(b);
tStart = time;

RGB = Prop.ColormapFunction(N);

%% MAIN LOOP
nSelected = 1;
responses = dataset;
responses.i = zeros(2,1); % to get all dataset's vars expanding verically
respCount = 0;

while (nSelected < N) && (time-tStart < TimeOut*1000)
    [button,xy] = waitmouseclick;
    rt = time - tStart;
    i = 0;
    for i = 1:N
       yes = isinside(xy, 'round', XY(i,:), Prop.CircleDiameter);
       if yes
           break
       end
    end
    isCorrect = (i == nSelected+1);
    % Correct circle? Extend trail to it:
    if isCorrect
        nSelected = i;    
        % Draw line:
        draw('line', RGB(i-1,:), OffscreenBuffer, XY(i-1,:), XY(i,:), Prop.LineWidth);  
        % Redraw circles:
        draw('rounddots', RGB(i-1:i,:), OffscreenBuffer, XY(i-1:i,:), Prop.CircleDiameter);
        draw('rounddots', Prop.ColorInterior, OffscreenBuffer, XY(i-1:i,:), Prop.CircleDiameter-2*Prop.LineWidth);
        drawtext(CircleLabels{i-1}, OffscreenBuffer, XY(i-1,:)-[0 4], RGB(i-1,:), Prop.FontSize);
        drawtext(CircleLabels{i  }, OffscreenBuffer, XY(i  ,:)-[0 4], RGB(i  ,:), Prop.FontSize);
        % Display:
        displaybuffer(OffscreenBuffer);
    end
    % Record response:
    if yes
        respCount = respCount + 1;
        responses.i(respCount) = i;
        responses.label{respCount} = CircleLabels{i};
        responses.error(respCount) = ~isCorrect;
        responses.time(respCount) = round(rt) / 1000;
    end
    if isaborted, return; end
end

%% Play Winning Sound
if nSelected == N
    sound(WinningSound.y, WinningSound.fs);
else
    %<TODO: Play Loosing sound>
end

%% Responses -> workspace
dispinfo(mfilename,'info','Exporting "responses" to workspace...')
assignin('base','responses',responses)
responses
