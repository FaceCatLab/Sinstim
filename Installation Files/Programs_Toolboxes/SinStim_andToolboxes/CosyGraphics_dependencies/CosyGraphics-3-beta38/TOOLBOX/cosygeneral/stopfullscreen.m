function stopfullscreen
% STOPFULLSCREEN  Stop cosy if in full-screen.
%    STOPFULLSCREEN  by itself stops CosyGraphics if in fullscreen ; if lets it open but not deletes 
%    all image buffers.
%
% Example:
%       if isaborted
%           stopfullscreen;
%           return
%       end
%
% See also: STOPCOSY, ISABORTED, CHECKABORTKEY, RESETABORTFLAG.

evalin('caller', 'if isopen(''fullscreen''), stopcosy; deletebuffer all; end');