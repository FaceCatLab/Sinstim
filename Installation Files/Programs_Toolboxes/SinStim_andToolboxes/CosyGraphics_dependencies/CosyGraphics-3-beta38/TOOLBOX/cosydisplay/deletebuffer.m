function deletebuffer(b)
% DELETEBUFFER  Delete offscreen buffer.
%    DELETEBUFFER(b)  deletes offscreen buffer(s) of handle(s) b.
%    'b' is a scalar or a vector.
%
%    DELETEBUFFER ALL  deletes all offscreen buffers. (Except buffer 0 
%    wich cannot be deleted.)
%
% Ben, Sept 2007

global COSY_DISPLAY

% Recursive call if b is a cell array
if length(b) > 1
	if ischar(b) && strcmpi(b,'all')
        b = setdiff(COSY_DISPLAY.BUFFERS.OffscreenBuffers,...
            [COSY_DISPLAY.BUFFERS.DraftBuffer COSY_DISPLAY.BUFFERS.BackgroundBuffer]);
	end
end

% Find buffer indexes
f = zeros(1,length(b));
for i = 1 : length(b)
    idx = find(COSY_DISPLAY.BUFFERS.OffscreenBuffers == b(i));
    if isempty(idx)
        idx = NaN;
        warning(['Cannot find buffer ' int2str(b(i)) '.'])
    end
    f(i) = idx;
end
f(isnan(f)) = [];

% Delete buffer
for i = 1 : length(b)
    if iscog % CG
        cgfreesprite(b) % !
    else     % PTB
        Screen('Close',b);
    end
end
    
% Delete handle & flag
COSY_DISPLAY.BUFFERS.OffscreenBuffers(f) = [];
COSY_DISPLAY.BUFFERS.isTexture(f) = [];
COSY_DISPLAY.BUFFERS.isFloat(f) = [];
if ismember(COSY_DISPLAY.BUFFERS.CurrentBuffer4CG,b)
    COSY_DISPLAY.BUFFERS.CurrentBuffer4CG = 0;
end
