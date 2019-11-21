function erasecaltarget(el, rect)

% erase calibration target
%
% USAGE: erasecaltarget(el, rect)
%
%		el: eyelink default values
%		rect: rect that will be filled with background colour 
if ~IsEmptyRect(rect)
    if isptb
        Screen( 'FillOval', el.window, el.backgroundcolour,  rect );
        Screen( 'Flip',  el.window);
    else
        draw( 'round', [el.backgroundcolour el.backgroundcolour el.backgroundcolour]/255, el.window, [mean(rect([1 3])) mean(rect([2 4]))], diff(rect([1 3])));
        displaybuffer(el.window);
    end
end
