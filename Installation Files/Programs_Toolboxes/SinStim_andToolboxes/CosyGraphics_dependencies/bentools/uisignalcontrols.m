function [hControls,Tags] = uisignalcontrols(varargin)
% UISIGNALCONTROLS
%    hControls = UISIGNALCONTROLS(hAxes,side,ww,hh)
%       hAxes: handles of a vertical axis array
%       side: 'L' or 'R' <todo: 'menu'>
%       ww: [dx1,w1,w2,w3,dx2]
%       hh: [h,dy]
%
% Example:
%         uisignalcontrols([GLMHANDLES.Axes.Axis]','L',[.005 .05 .012 .012 .030],[.024 .005])
%
% Ben, 1st April 2010.

%% INITIAL CALL
if ~ischar(varargin{1})
    hAxes = varargin{1};
    side = varargin{2};
    ww = varargin{3};
    hh = varargin{4};

    % Vars
    nAxes = numel(hAxes);
    hSignals = cell(nAxes,1);
    Tags = cell(nAxes,1);
    hControls = cell(nAxes,1);

    % Move Axes
    for a = 1 : nAxes
        p = get(hAxes(a),'Pos');
        switch side
            case 'L'
                x0 = sum(ww);
                d = x0 - p(1);
                p(3) = p(3) - d;
                p(1) = x0;
            case 'R'
                % <TODO>
        end
        set(hAxes(a),'Pos',p)
    end

    % Get Signals
    for a = 1 : nAxes
        % Get all axes' children:
        hChildren = get(hAxes(a),'Child');

        % Keep only those who are tagged:
        handles = [];
        tags = {};
        for c = 1 : length(hChildren)
            tag = get(hChildren(c),'Tag');
            if ~isempty(tag)
                handles(end+1) = hChildren(c);
                tags{end+1} = {tag};

            end
        end
        hSignals{a} = handles';
        Tags{a} = tags';

        %% Plot Controls
        hControls{a} = zeros(length(hSignals),length(ww)-2);
        h = hh(1);
        dy = hh(2);
        p = get(hAxes(a),'Pos');
        y0 = p(2) + p(4) - h;

        for s = 1 : length(hSignals{a})
            u = [];
            u.hTarget = hSignals{a}(s);
            x0 = ww(1);
            w = ww(2);
            hControls{a}(s,1) = uicontrol('Style','check','Str',Tags{a}{s},...
                'Foreground',get(hSignals{a}(s),'Color'),'Units','norm','pos',[x0 y0 w h],...
                'UserData',u,'Value',1,'Call',[mfilename ' ToggleVisible']);
            x0 = x0 + w;
            w = ww(3);
            hControls{a}(s,2) = uicontrol('Style','check','Units','norm','pos',[x0 y0 w h],...
                'UserData',u,'Call',[mfilename ' ToggleMarker']);
            x0 = x0 + w;
            w = ww(4);
            hControls{a}(s,3) = uicontrol('Style','push','Str',' ','Units','norm','pos',[x0 y0 w h],...
                'UserData',u);

            y0 = y0 - dy - h;
        end
    end

%% CALLBACKS
else
    u = get(gcbo,'UserData');
    
    switch varargin{1}
        case 'ToggleVisible'
            oldProp = get(u.hTarget,'Vis');
            if iscell(oldProp), oldProp = oldProp{1}; end
            switch oldProp
                case 'on',   set(u.hTarget,'Vis','off')
                case 'off',  set(u.hTarget,'Vis','on')
            end
            
        case 'ToggleMarker'
            oldProp = get(u.hTarget,'Marker')%;
            if iscell(oldProp), oldProp = oldProp{1}; end
            switch oldProp
                case 'none',  set(u.hTarget,'Marker','.')
                otherwise,    set(u.hTarget,'Marker','none')
            end
            get(u.hTarget,'Marker')
    end
end
            