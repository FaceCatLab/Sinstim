function showbuffers(Buffers,BgColor)
% SHOWBUFFERS  Display the content of offscreen buffers in a Matlab figure.
%    SHOWBUFFERS  shows the content of all buffers. Use the RIGHT ARROW and LEFT ARROWS keys to
%    navigate between them; press Q to quit.
%
%    SHOWBUFFERS(buffers)  shows specified buffers.
%
%    SHOWBUFFERS(buffers,rgb)  uses rgb code as background color.
%
% Ben, Sep 2007  v1.0
%      Oct 2009  v2.0


global GLAB_BUFFERS GLAB_DISPLAY

%% <- In
if ~nargin,
	Buffers = setdiff(GLAB_BUFFERS.OffscreenBuffers,...
        [GLAB_BUFFERS.DraftBuffer GLAB_BUFFERS.BlankBuffer]);
end
Buffers = (unique(Buffers)); % sort it
if isempty(Buffers)
    disp('No existing buffers.')
    return % <---!!!
end
if nargin < 2
    BgColor = [0 0 .5];
end

%% Display first buffer
clearbuffer(0,BgColor);
copybuffer(Buffers(1),0);
displaybuffer(0);

%% Wait user key presses
iBuffer = 1;
nBuffers = length(Buffers);
t0 = time;
while 1
    k = waitkeydown([getkeynumber('RArrow') getkeynumber('LArrow') getkeynumber('Q')]);
    switch k
        case getkeynumber('RArrow')
            if iBuffer < nBuffers
                iBuffer = iBuffer + 1;
                clearbuffer(0,BgColor);
                copybuffer(Buffers(iBuffer),0);
                displaybuffer(0);
            end
        case getkeynumber('LArrow')
            if iBuffer > 1
                iBuffer = iBuffer - 1;
                clearbuffer(0,BgColor);
                copybuffer(Buffers(iBuffer),0);
                displaybuffer(0);
            end
        case getkeynumber('Q')
            clearbuffer(0);
            displaybuffer(0);
            break % <--!
    end
end
