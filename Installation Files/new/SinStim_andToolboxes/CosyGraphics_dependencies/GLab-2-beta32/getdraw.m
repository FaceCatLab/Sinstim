function varargout = getdraw(varargin)
% GETDRAW  Get drawing settings.
%    Settings = GETDRAW  returns all setting values in a structure.
%
%    Value = GETDRAW(SettingName)  returns value of given setting.
%    Valid setting names are: 'PixelScale', 'DrawColor', 'BackgroundColor', 
%    ('TransparencyColor'), 'LineWidth', 'FontName', 'FontSize'.
%
%    [Value1,Value2,...] = GETDRAW(SettingName1,SettingName2,...)
%
% Ben, apr. 2008.

%    Settings = GETDRAW('all')  returns the raw structure returned by cgGetData.

global GLAB_BACKGROUND

l = strcmpi(varargin,'FontColor');
if any(l), varargin(l) = {'DrawColor'}; end

GPrim = cgGetData('GPD');
GScnd = cgGetData('GSD');

drawcolor = [GPrim.DrawCOL.CR.Red GPrim.DrawCOL.CR.Grn GPrim.DrawCOL.CR.Blu] / 255;
trancolor = [GPrim.TranCOL.CR.Red GPrim.TranCOL.CR.Grn GPrim.TranCOL.CR.Blu] / 255;
switch GPrim.AlignX
	case 0, xalign = 'L';
	case 1, xalign = 'C';
	case 2, xalign = 'R';
end
switch GPrim.AlignY
	case 0, yalign = 'T';
	case 1, yalign = 'C';
	case 2, yalign = 'B';
end

if ~nargin
	Out.PixelScale			= GScnd.PixScale; % Pixels per unit
	Out.XAlign				= xalign;
	Out.YAlign				= yalign;
	Out.DrawColor			= drawcolor;
	Out.BackgroundColor		= GLAB_BACKGROUND;
	Out.TransparencyColor	= trancolor;
	Out.LineWidth			= GPrim.LineWidth;
	Out.FontName			= GPrim.Fontname; %(sic)
	Out.FontSize			= GPrim.PointSize;
    varargout{1} = Out;
else
    for arg = 1 : nargin
        switch lower(varargin{arg})
            case 'pixelscale',			Out = GScnd.PixScale;
            case 'xalign',				Out = xalign;
            case 'yalign',				Out = yalign;
            case 'drawcolor',			Out = drawcolor;
            case 'backgroundcolor',		Out = GLAB_BACKGROUND;
            case 'transparencycolor',	Out = trancolor;
            case 'linewidth',			Out = GPrim.LineWidth;
            case 'fontname',			Out = GPrim.Fontname; %(sic)
            case 'fontsize',			Out = GPrim.PointSize;
            case 'all',					Out = GPrim;
            otherwise,          error('Invalid setting name.');
        end
        varargout{arg} = Out;
    end
end
