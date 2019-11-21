function fitaxesv(hAxes,dy,y0y1,RelativeHeights,varargin)
% FITAXESV
%    FITAXESV(hAxes,dy)  updates axes' y positions and heights to fill the same area than  
%    previousely.
%
%    FITAXESV(hAxes,dy,y0y1)  fills the area between the bottom and top given by the y0y1 vector.
%    FITAXESV(hAxes,dy,[])  is the same than FITAXESV(hAxes,dy).
%
%    FITAXESV(hAxes,dy,y0y1,RelativeHeights)  gives axes heights proportionnal to RelativeHeights
%    values.
%    FITAXESV(hAxes,ydy,y0y1,[])  conserves former relatives heights.
%
%    FITAXESV(hAxes,dy,y0y1,RelativeHeights,hControls)  updates y position of controls associated
%    with the axes. hControls is either a cell vector (one cell per axis) of vecors of handles,
%    or a structure field (structname.fieldname).
%
%    FITAXESV(hAxes,dy,y0y1,RelativeHeights,hControls1,hControls2,...)  is the same for several 
%    sets of associated controls.

% Ben, June 2009    v1.0    Developped for GLM-View.
%      Aug. 2009    v1.1    Fix Matlab zoom bug with invisible axes.
%                           Progrmmer's note: I asked me the question: Do I add an isVisible input arg.? 
%                           Aswer: no. Because it's easier to set Visible independentely 
%                           (set(h,'vis','on'|'off')), then to use fitaxesv to scale axes.


%% Vars
nAxes = length(hAxes);

OldPositions = zeros(nAxes,4);
isVisible = zeros(1,nAxes);
for i = 1 : nAxes
    OldPositions(i,:) = get(hAxes(i),'Position');
    isVisible(i) = strcmpi(get(hAxes(i),'Visible'),'on');
end

nAxesVis = sum(isVisible);

%% Input Args
if isempty(y0y1)
    % Find area currently occupied by axes:
    % We don't take in consideration axes wich are outside of the figure, because
    % FITAXESV puts non-visible axes outside figure to fix Matlab zoom bug. (See below.)
    ii = find(OldPositions(:,2) < 1);
    y0y1 = [min(OldPositions(ii,2)), max(OldPositions(ii,2) + OldPositions(ii,4))];
end
y0y1 = sort(y0y1);

if ~exist('RelativeHeights','var')
    RelativeHeights = ones(1,nAxes);
end
if isempty(RelativeHeights)
    
    RelativeHeights = ones(1,nAxes);
end
RelativeHeights(~isVisible) = 0;
RelativeHeights = RelativeHeights / sum(RelativeHeights);

hControls = {};
while length(varargin);
    if iscell(varargin{1}) % Arg. is a cell
        hControls{end+1} = varargin{1};
        varargin(1) = [];
    else % Input arg was a structure field, which deals in several args
        hControls{end+1} = varargin(1:nAxes);
        varargin(1:nAxes) = [];
    end
end

%% Set Visible Axes New Positions
NewPositions = OldPositions;

hsum = diff(y0y1) - (nAxesVis-1) * dy;
h = RelativeHeights * hsum;

y1 = y0y1(2);
for i = find(isVisible)
    y0 = y1 - h(i);
    NewPositions(i,[2 4]) = [y0 h(i)];
    set(hAxes(i),'Position',NewPositions(i,:))
    y1 = y0 - dy;
end

%% Set Non-Visible Axes Positions
% We put non-visible axes outside figure to fix Matlab zoom bug.
for i = find(~isVisible)
    NewPositions(i,2) = 1; % y outside figure
    set(hAxes(i),'Position',NewPositions(i,:))
end

%% Set Associated Controls Positions (and reset 'Visible' property)
for s = 1 : length(hControls)                % Once per Set of controls..
    for i = 1 : nAxes                        % Once per axis..
        delta = sum(NewPositions(i,[2 4])) - sum(OldPositions(i,[2 4]));
        for c = 1 : numel(hControls{s}{i})  % Once per Control..
            pos = get(hControls{s}{i}(c),'Position');
            pos(2) = pos(2) + delta;
            set(hControls{s}{i}(c),'Position',pos)
        end
    end
end

%% Set Axes X Tick Labels
f = find(isVisible);
if ~isempty(f)
    set(hAxes(f(1:end-1)),'XTickLabel','')
    set(hAxes(f(end)),'XTickLabelMode','auto')
end