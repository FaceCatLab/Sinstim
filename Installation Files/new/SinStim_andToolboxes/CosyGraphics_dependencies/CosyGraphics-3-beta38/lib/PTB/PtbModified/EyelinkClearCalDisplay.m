function EyelinkClearCalDisplay(el)

if isptb
    Screen( 'FillRect',  el.window, el.backgroundcolour );	% clear_cal_display()
    Screen( 'Flip',  el.window);
else % Cog <AlexZ>
    clearbuffer(el.window, [el.backgroundcolour el.backgroundcolour el.backgroundcolour]/255);
    displaybuffer(el.window);
end