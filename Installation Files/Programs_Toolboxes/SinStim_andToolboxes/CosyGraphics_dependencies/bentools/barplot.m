function [H,X] = barplot(varargin)
% BARPLOT  Bar graph.
%    This function is a wrapper for MATLAB's BAR function.
%
%    BARPLOT(...)  is the same than  BAR(...).  See HELP BAR.
%
%    BARPLOT(...,'errorbar',E)  plots with error bars [Y-E Y+E].
%
%    BARPLOT(...,'errorbar',L,U)  plots with error bars [Y-L Y+U].
%
%    BARPLOT(...,'errorbar',...,LineSpec)  plots the error bars using color specified by the string 
%    LineSpec (linestyle specs are not applied).  LineSpec can be 'r', 'g', 'b', 'y', 'c', 'm',
%    'k' (black) or 'w'.
%
%    H = BARPLOT(...)  returns all handles in structure H.  Handles are both handles of groups of   
%    objects (see HBGROUPS) and handles of actual graphical objects (patches for bars and lines for  
%    errorbars).
%
%    [H,X] = BARPLOT(...)  returns X co-ordinates of bars.
%
% See also: BAR, ERRORBAR, PLOT.
%
% Ben, Jan 2009. v0.1

% INPUT ARGS
%============
% Error bar:
errorbar_argin = {};
for i = 2 : nargin
    if strcmpi(varargin{i},'errorbar')
        errorbar_argin = varargin(i+1:end);
        varargin = varargin(1:i-1);
        break
    end
end

% INIT.
%=======
H = struct('hggroups',[],'patches',[],'errorbars_hggroups',[],'errorbars_lines',[]);
X = [];

% PLOT BARS
%===========
% m groups, n series
% Ex: m=2, n=4
%                 |
%    |        |   |
%  | |   |    |   | |
%  | | | |    | | | |

% Plot! And get handles to barseries objects (group objects)
h = bar(varargin{:}); % !   
if isempty(h)
    return % !!!
end
H.hggroups = h; % 1-by-n

% m, n
m = size(get(H.hggroups(1),'XData'),2); % # groups
n = length(H.hggroups);                 % # series

% Get handles to patches (actual graphical objects)
H.patches = zeros(1,n);
for j = 1 : n
    H.patches(j) = get(H.hggroups(j),'Children');
end

% Get individual bars X, Y co-ord.
X = zeros(m,n);
Y = zeros(m,n);
for j = 1 : n
    xdata = get(H.patches(j),'XData');
    X(:,j) = (xdata(1,:) + xdata(3,:))' / 2;
    ydata = get(H.hggroups(j),'YData');
    Y(:,j) = ydata';
end

% PLOT ERROR BARS
%=================
if ~isempty(errorbar_argin)
    % Input args
    if ~ischar(errorbar_argin{end})
        errorbar_argin{end+1} = 'k';
    end
    ax = axescheck(varargin);
    if isempty(ax), ax = gca; end
    
    % Plot!
    hs = get(ax,'NextPlot')
    set(ax,'NextPlot','add') % Set hold status on.
    h = errorbar(ax,X,Y,errorbar_argin{:}); % !
    set(ax,'NextPlot',hs) % Restore hold status.
    H.errorbars_hggroups = h; % 1-by-n
    
    % Get line H
    H.errorbars_lines = zeros(1,n);
    for j = 1 : n
        ch = get(H.errorbars_hggroups(j),'Children');
        delete(ch(1)); % Delete curve ("data line") ; keep only bars.
        H.errorbars_lines(j) = ch(2);
    end
    
end