function varargout = uicursor(Action,varargin)
% UICURSOR  Add and manipulate cursor in existing axes.
%    x = UICURSOR('NEW')  creates new cursor and returns x position.
%    x = UICURSOR('NEW',Color)  specifies cursor color. 'Color´ is an [r g b] vector.
%    [x,handle] = UICURSOR('NEW',...)  returns also the handle of the cursor.
%    handle = UICURSOR('SELECT')  is used by UICURSOR('DELETE') and UICURSOR('MOVE').
%    UICURSOR('MOVE') or UICURSOR MOVE  lets you select a cursor with the mouse and then move it.
%    UICURSOR('MOVE',h)  moves cursor of handle 'h´.
%    UICURSOR('DELETE') or UICURSOR DELETE  deletes a cursor. The cursor will have to be selected by mouse.
%    UICURSOR('DELETE',h)  deletes cursor of handle 'h´.
%    UICURSOR('REDRAW',Times,Colors)
%    handles = UICURSOR('GET_HANDLES')  returns a vector with the cursor handles.
%    UICURSOR('CLEAR') or UICURSOR CLEAR  Clear all cursors.
%
% Ben, Jan. 2008

persistent Cursors

if isnumeric(Action)
	n = Action;
	xx = zeros(1,n);
	hh = zeros(1,n);
	for i = 1:n
		if nargin > 1, x = uicursor('new',varargin{1});
		else           x = uicursor('new');
		end
		xx(i) = x;
	end
	varargout{1} = xx;
% 	varargout{2} = hh;  % DEBUG !!!
end

Action = lower(Action);
	
switch Action
	
	case 'new'
		% Input Arg.
		if nargin > 1, Color = varargin{1};
		else           Color = [0 0 1];
		end
		% Get position
		[x,y] = ginput(1);
		% Draw cursor
		set(gca,'YLimMode','manual')
		Cursors(end+1) = plot([x x],[-99999 99999],'Color',Color);
		% Add context menu to cursor
		cm = uicontextmenu;
		uimenu(cm,'Label','Move','Call',['uicursor(''move'',' num2str(Cursors(end),20) ');']);
		uimenu(cm,'Label','Delete','Call',['uicursor(''delete'',' num2str(Cursors(end),20) ');']);
		set(Cursors(end),'UIContextMenu',cm)
		% Output Arg.
		varargout{1} = x;
		varargout{2} = Cursors(end);
		
	case 'select' % Used by UICURSOR MOVE and UICURSOR DELETE
		[x,y] = ginput(1);
		xx = zeros(size(Cursors));
		for i = 1 : length(xx);
			xdata = get(Cursors(i),'xdata');
			xx(i) = xdata(1);
		end
		d = abs(xx - x);
		i = find(d == min(d));
		handle = Cursors(i);
		varargout{i} = handle;
		
	case 'move'
		if     nargin == 2, h = varargin{1};
		elseif nargin == 1, h = uicursor('select');
		end
		set(h,'visible','off')
		[x,y] = ginput(1);
		set(h,'visible','on','xdata',[x x])
		varargout{1} = x;
		
	case 'delete'
		if     nargin == 2, h = varargin{1};
		elseif nargin == 1, h = uicursor('select');
		end
		delete(h);
		i = find(Cursors == h);
		Cursors(i) = [];
		
	case 'redraw'
		Times = varargin{1};
		Colors = varargin{2};
		uicursor clear
		set(gca,'YLimMode','manual')
		for c = 1 : length(Times)
			Cursors(c) = plot([Times(c) Times(c)],[-99999 99999],'Color',Colors(c,:));
		end
		
	case 'get_handles'
		varargout{1} = Cursors;
		
	case 'clear'
		try, delete(Cursors), end
		Cursors = [];
		
end