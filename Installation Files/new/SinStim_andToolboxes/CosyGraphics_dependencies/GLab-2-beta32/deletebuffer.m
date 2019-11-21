function deletebuffer(b)
% DELETEBUFFER   Delete offscreen b.
%    DELETEBUFFER(b)  deletes offscreen buffer(s) of given handle(s).
%    b is a scalar or a vector.
%
%    DELETEBUFFER ALL  deletes all offscreen buffers. (Exept buffer 0 
%    wich cannot be deleted.)
%
% Ben, Sept 2007

global GLAB_BUFFERS

% Recursive call if b is a cell array
if length(b) > 1
	if ischar(b) && strcmpi(b,'all')
		b = GLAB_BUFFERS.OffscreenBuffers;
	end
end

% Find buffer indexes
f = zeros(1,length(b));
for i = 1 : length(b)
    idx = find(GLAB_BUFFERS.OffscreenBuffers == b(i));
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
GLAB_BUFFERS.OffscreenBuffers(f) = [];
GLAB_BUFFERS.isTexture(f) = [];
if ismember(GLAB_BUFFERS.CurrentBuffer,b)
    GLAB_BUFFERS.CurrentBuffer = 0;
end
