function setdraw(varargin)
% SETDRAW  Set drawing settings. <not finished>
%    SETDRAW(SettingName,SettingValue)  sets the value of specified setting.
%
%    SETDRAW(SettingName1,SettingValue1,SettingName2,SettingValue2,...)
%
% Valid setting names are:
%
%   'Scale':
%       SETDRAW('Scale','Pixel')  sets pixel coordinate. (G-Lab's default.)
%
%       SETDRAW('Scale',ScreenWidthDeg)  set degree (of visual angle) as the co-
%       ordinate system to use, and sets given value as the screen width in degrees.
%    
%       SETDRAW('Scale',[ScreenWidthMM ObserverDistanceMM)  set degree of visual
%       angle) as the coordinate system, and compute the screen with in deg from 
%       screen width and observer distance in millimeters.
%
%   'XAlign','YAlign':
%       SETDRAW('XAlign',Alignement)  sets horizontal alignement for all drawing 
%       operations. Alignement value can be: 'L' (or 'Left'), 'C' (or 'Center'),
%       'R' (or 'Right').
%   
%       SETDRAW('YAlign',Alignement)  sets vertical alignement for all drawing 
%       operations. Alignement value can be: 'T' (or 'Top'), 'C' (or 'Center'),
%       'B' (or 'Bottom').
%
%   'LineWidth'
%       SETDRAW('LineWidth',w)  sets line width to w pixels.
%
%   'DrawColor'
%       SETDRAW('DrawColor',rgb)  sets pen color. rgb is a red-green-blue triplet 
%       in the range 0.0 to 1.1.
%
%       SETDRAW('BackgroundColor',rgb)  sets default background color. rgb is a 
%       red-green-blue triplet in the range 0.0 to 1.1.
%       
%	, 'BackgroundColor', ('TransparencyColor'), 'FontName', 'FontSize'.
%       <TODO>

global GLAB_DISPLAY

for i = 1 : 2 : nargin-1
	Value = varargin{i+1};
	switch lower(varargin{i})
		case 'scale'
			if ischar(Value) && strfind(lower(Value),'pixel')
				cgscale
			elseif isnumeric(Value) && length(Value == 1)
				cgscale(Value)
			elseif isnumeric(Value) && length(Value == 2)
				cgscale(Value(1),Value(2))
			else
				error('Invalid value for ''ScreenWidth'' Setting.')
			end
            
		case 'xalign'
			if strncmpi('Value','L',1) | strcnmpi('Value','C',1) | strncmpi('Value','R',1)
				yvalue = getdraw('YAlign');
				cgalign(Value,yvalue);
			end
            
		case 'yalign'
			if strncmpi('Value','T',1) | strncmpi('Value','C',1) | strncmpi('Value','B',1)
				xvalue = getdraw('XAlign');
				cgalign(xvalue,Value);
			end
            
		case 'drawcolor'
			cgpencol(Value(1),Value(2),Value(3));
            
		case 'backgroundcolor'
			GLAB_DISPLAY.BackgroundColor = varargin{1}(:)';
            clearbuffer(0);
            
		case 'linewidth'
			cgpenwid(Value);
            
		case 'fontname'
			h = getdraw('FontHeight');
			cgfont(Value,h);
            
		case 'fontheigth'
			n = getdraw('FontName');
			cgfont(n,Value);
            
		otherwise
			error(['Invalid property name: ' varargin{i} '.'])
	end
end