function v = togglecheck(h)
% TOGGLECHECK  Toggle 'Checked' status of a uicontrol or uimenu.
%    v = togglecheck(h)  checks/unchecks object of handle h and returns
%    toggled status v. v is a logical (0 or 1).
%
%    v = togglecheck(Label)  checks/unchecks uimenu(v) of given label.
%    This is usefull because gcbo doesn't work with uimenus.

if ischar(h)
    h = findobj('Label',h);
end

switch get(h,'Type')
    case 'uimenu'
        % Property = 'Check'; values = 'on' or 'off'; toggles automatically.
        prop = 'Check';
        
        s = get(h,prop);
        v = strcmpi(s,'on')';

        if any(v),  set(h,prop,'off')
        else        set(h,prop,'on')
        end

        s = get(h,prop);
        v = strcmpi(s,'on')';
        
    case 'uicontrol'
        % Property = 'Value'; values = 1 or 0; does not toggle automatically !
        prop = 'Value';
        
        v = get(h,prop);

        if any(v),  set(h,prop,1)
        else        set(h,prop,0)
        end

        v = get(h,prop);
end

