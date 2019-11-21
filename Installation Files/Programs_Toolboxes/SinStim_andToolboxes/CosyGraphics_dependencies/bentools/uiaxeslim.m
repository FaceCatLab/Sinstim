function hControls = uiaxeslim(varargin)
% UIAXESLIM  Edit boxes to set axes limits ('XLim' or 'YLim'). <NOT FINISHED>
%    H = UIAXESLIM(hAxes,'X'|'Y',Width,Heigth)
%

%% INITIAL CALL
if isnumercic(varargin{1})
    hAxes = varargin{1};
    XorY = varargin{2};
    w = varargin{3};
    h = varargin{4};
    
   
    switch upper(XorY)
        case 'X' % X: One control pair below latest X axis.
            xlim = get(hAxes(end),'XLim');
            ylim = get(hAxes(end),'YLim');
            x0 = xlim - w/2;
            y0 = ylim(1) - h;
            call = '';

            hControls(1) = uicontrol('style','edit','str',num2str(xlim(1)),'userdata',);
            u.hControls = hControls;
            u.hAxes = hAxes;
            set(hControls,'userdata',u)
            
        case 'Y' % Y: One control pair on the left of each Y axis.
            for ha = hAxes
                
                x0 = xlim(1) - w;
                y0 = ylim - h/2;
            end
            
            
            
    end
        
%% RECURSIVE CALL 
else
    switch varargin{1}
        
        
        case 'DeleteFcn'
            
        
    
end
