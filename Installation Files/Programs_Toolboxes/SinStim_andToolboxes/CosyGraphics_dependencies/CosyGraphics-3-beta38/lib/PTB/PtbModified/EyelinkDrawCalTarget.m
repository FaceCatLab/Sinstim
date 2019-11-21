function rect=EyelinkDrawCalTarget(el, x, y)

global GLAB_DISPLAY
% draw simple calibration target
%
% USAGE: rect=EyelinkDrawCalTarget(el, x, y)
%
%		el: eyelink default values
%		x,y: position at which it should be drawn
%		rect: 

% simple, standard eyelink version
%   22-06-06    fwc OSX-ed

cosyglobal % <CosyG, v3-beta5>

if isptb
    y = y - COSY_DISPLAY.Offset(2); % <CosyG, v3-beta5: coord from EL must be translated of TWICE the y offset!!>

    [width, height]=Screen('WindowSize', el.window);
    size=round(el.calibrationtargetsize/100*width);
    inset=round(el.calibrationtargetwidth/100*width);
    
    rect=CenterRectOnPoint([0 0 size size], x, y);
    Screen( 'FillOval', el.window, el.foregroundcolour,  rect );
    rect=InsetRect(rect, inset, inset);
    Screen( 'FillOval', el.window, el.backgroundcolour, rect );
    Screen( 'Flip',  el.window);
    
else % Cogent % <CosyG, v3-balpha?, Alex Zenon & ben Jacob>
    [width,height] = getscreenres;
    x = (width/2)-x-1;
    y = (height/2)-y-1;
    size=round(el.calibrationtargetsize/100*width);
    inset=round(el.calibrationtargetwidth/100*width);
    rect=CenterRectOnPoint([0 0 size size], x, y);
    draw( 'round', [el.foregroundcolour el.foregroundcolour el.foregroundcolour]/255, el.window,  [x y], size);
    draw( 'round', [el.backgroundcolour el.backgroundcolour el.backgroundcolour]/255, el.window,  [x y], inset);
    displaybuffer(el.window);
    
end