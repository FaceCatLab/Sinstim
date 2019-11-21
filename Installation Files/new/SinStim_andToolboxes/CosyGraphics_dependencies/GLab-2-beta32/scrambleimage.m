function I = scrambleimage(I,BG)
% SCRAMBLEIMAGE  Scramble FOREGROUND pixels in image(s).
%    I = scrambleimage(I,BG)  scrambles foreground pixels in image ,
%    matrix I. BG is the background mask, see BACKGROUNDMASK.
%    I and BG can also be cell arrays.

% Init Random Generator!
rand('state',sum(100*clock));

% Input Args
if ~iscell(I)
    I = {I};
    BG = {BG};
    isCellArg = 0;
else
    isCellArg = 1;
end

% Scramble Pixels
for i = 1 : numel(I)
    f = find(~BG{i});
    f2 = f(randperm(length(f)));
    for k = 1 : size(I{i},3)
        CH = I{i}(:,:,k);
        CH(f) = CH(f2);
        I{i}(:,:,k) = CH;
    end
end

% Output Arg
if ~isCellArg
    I = I{1};
end