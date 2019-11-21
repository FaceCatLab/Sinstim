function reinitdisplay
% REINITDISPLAY  Re-initialize PTB's display - usefull to fix some bizarre bugs. {slow}
%    REINITDISPLAY  opens a new PsychToolBox on-screen window which replaces the current one for CosyGraphics. 
%    This can serve as a hack to fix some bugs which appears with the graphics load after some time.
%    Note that the old onscreen window is not closed and still remains in video memory, so don't call
%    reinitdisplay to many times. The handle of the new on-screen window can be get by GCW, as usual.
%    The function has no effect over Cogent.
%
% Ben, June 2001.

global COSY_DISPLAY

if ~isopen('display')
    error('No open display.')
end

if isptb
    dispinfo(mfilename, 'warning', 'Re-initializing display... This can cause visual bugs...');
    
    if COSY_DISPLAY.Screen  % Full screen
        rect = [];
    else                    % Windowed
        rect = COSY_DISPLAY.WindowRect4PTB;
    end
    
    w = Screen('OpenWindow', COSY_DISPLAY.ScreenNumber4PTB, COSY_DISPLAY.BackgroundColor, rect);
    
    old_w = gcw;
    COSY_DISPLAY.BUFFERS.Backbuffer = w;
    
    clearbuffer;
    displaybuffer;
    
%     Screen('Close',old_w);
%     
%     clearbuffer;
%     displaybuffer;
     
    dispinfo(mfilename, 'info', 'Display is re-initialized.');
    
else
    dispinfo(mfilename, 'warning', 'This function has no effect over Cogent.');
    
end
