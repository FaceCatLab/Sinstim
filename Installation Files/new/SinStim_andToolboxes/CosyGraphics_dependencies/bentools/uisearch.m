function varargout = uisearch(varargin)
% UISEARCH  Graphical User Interface for SEARCH function.
%    UISEARCH
%    UISEARCH(Str)
%    UISEARCH(Str,FileExt)
%    UISEARCH(Str,FileExt,Dir)
%
% Programmers only:
%    UISEARCH('Callback',...) Callback syntax.
%
% Dependencies: search, screenresolution.
%
% Ben, May 2008 - 1.0
%      Jul 2010 - 2.0    Add input arguments. 
%      Jun 2011 - 2.1    Add dir field.
%      Sep 2011 - 2.1.1  Align to right. Close previous figure.

% <Programmer's note: v2.0 is incompatible with EyeView's version.>

persistent FileExt hListBox hFig

if ~nargin || ~strcmpi(varargin{1},'callback') % === FIRST CALL, BY USER ===
	
	% Input Args
    if nargin >= 1,  Str = varargin{1};
    else			 Str = '';
    end
	if nargin >= 2,	 FileExt = varargin{2};
    else			 FileExt = 'm';
    end
    if nargin >= 3,	 Dir = varargin{3};
        cd(Dir)
        disp(Dir)
    else             Dir = cd;
    end
    
	% Figure
	[ScreenW,ScreenH] = getscreenresolution;
	W = 640;
% 	X0 = (ScreenW - W) / 2;
%   X0 = min((ScreenW - W)/2, 10);  % <v2.1>
    X0 = ScreenW - W + 3;           % <v2.1.1>
	Y0 = 36;
	H = ScreenH - 2 * Y0;
    try close(hFig); end            % <v2.1.1>
	hFig = figure('Name',['Search'],...
		'MenuBar','none','Unit','pixel','Pos',[X0 Y0 W H]);
	p = get(hFig,'Pos');
	
	% Function handle: Store the handle of 'uisearch' & 'search' functions in the figure.
	u.fSearch = @search;
	u.fUISearch = @uisearch;
	set(hFig,'UserData',u)
	
	% UI Controls
	w = 80;
	h = 20;
    dx = 3;
	dy = 2;
    y0 = H-h;
	hDirField = uicontrol('Style','edit','Str',Dir,...
		'Unit','pixel','Pos',[dx y0 W-w-dx h],...
		'BackgroundColor','w','HorizontalAlign','left',...
		'Call','u=get(gcf,''UserData''); d=get(gcbo,''Str''); cd(d); disp(d);');
    hDirButton = uicontrol('Style','pushbutton','Str','Browse',...
		'Unit','pixel','Pos',[W-w y0 w h],...
        'Call','u=get(gcf,''UserData''); d=uigetdir; if d, cd(d); disp(d); set(u.hDirField,''Str'',d); end');
    y0 = H-2*h-dy;
	hSearchLabel = uicontrol('Style','text','Str','Search :',...
		'Unit','pixel','Pos',[1 y0 w h],'BackgroundColor',get(gcf,'Color'));
	hSearchField = uicontrol('Style','edit','Str',Str,...
		'Unit','pixel','Pos',[1+w y0 W-w-dx h],...
		'BackgroundColor','w','HorizontalAlign','left',...
		'Call','u=get(gcf,''UserData''); feval(u.fUISearch,''Callback'',''Search'');');
	hListBox = uicontrol('style','listbox',...
		'Unit','pixel','Pos',[1 1 W y0-1-dy],...
		'Call','u=get(gcf,''UserData''); feval(u.fUISearch,''Callback'',''OpenToLine'');');
	set([hSearchLabel hSearchField hListBox],'Unit','norm')
    
    u.hDirField = hDirField;
    u.hSearchField = hSearchField;
    set(hFig,'UserData',u)
    
    % If 'Str' arg given, evaluate Search callback
    if ~isempty(Str)
        uisearch('Callback','Search');
    end

else % === RECURSIVE CALLS, BY GUI's CALLBACKS ===

    switch varargin{2}

        case 'Search'
            u = get(gcf,'UserData');
            Pattern = get(u.hSearchField,'str');
            Dir = get(u.hDirField,'str');

            [Files,Lines] = feval(u.fSearch, Pattern, FileExt, Dir);
            if ~isempty(Files)
                c = {};
                for i = 1 : length(Files)
                    for j = 1 : length(Lines{i})
                        L = num2str(Lines{i}');
                        line = [Files{i} ', at line:  ' L(j,:)];
                        c = [c; {line}];
                    end
                end
                set(hListBox,'Str',c)
            else
                msgbox('No match found.');
            end

        case 'OpenToLine'
            c = get(gcbo,'str');
            v = get(gcbo,'val');
            f = findstr(c{v},', at line:');
            filename = c{v}(1:f-1);
            linenumber = str2num(c{v}(f+10:end));
            opentoline(filename,linenumber);

    end

end