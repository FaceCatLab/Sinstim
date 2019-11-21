function copybufferthroughmask(FgBuff, AlphaMaskBuff, xy, BgBuff, TargBuff)
% COPYBUFFERTHROUGHMASK  Copy buffer "through" a mask. {fast}
%    COPYBUFFERTHROUGHMASK(b, alphaMask, xy)  copies buffer of handle b, through a mask buffer
%    (an aperture) of handle 'alphaMask', positionned at coordinates xy, into the backbuffer.  The  
%    mask buffer must have been previously created with STOREALPHAMASK (see).
%
%    COPYBUFFERTHROUGHMASK(FgBuff, AlphaMask, xy, Bg)  copies foreground buffer through alpha-mask 
%    over background Bg (buffer or color) into backbuffer. 'Bg' can be the handle of a buffer or
%    an [r g b] triplet, or be empty (use current background color).
%
%    COPYBUFFERTHROUGHMASK(FgBuff, AlphaMask, xy, Bg, TargetBuff)  copies into TargetBuff in place of
%    backbuffer.
%
% See also: STOREALPHAMASK, COPYBUFFER.
%
% Ben, Sep 2011.

global COSY_DISPLAY

%% tmp code............................................................
if 0 % Tmp code  <TODO: Suppr this in next version>
    % BgBuff <tmp code>
    Z = zeros(getscreenres(2), getscreenres(1), 3);
    P=Z; P(:,:,3) = 1;
    BgBuff = storeimage(P);
    F=Z; F(:,:,1) = 1;
    FgBuff = storeimage(F);

    % AlphaMaskBuff <tmp code>
    xy = [-100 -100];
    M = matdraw('round', 0, ones(100), [0 0], 90); imshow(M); % <tmp>
    % MaskMat = zeros(100,100,4);
    % MaskMat(:,:,4) = Mask;
    MaskMat = double(repmat(M, [1 1 4]));
    AlphaMaskBuff = storeimage(MaskMat);

    masktex=storeimage(double(Mask));
    myrect=[100 100 150 150];
    
    % TargBuff <tmp code>
    TargBuff = gcw;
    
    copybufferthroughmask(FgBuff, AlphaMaskBuff, rand(1,2)*200-100, BgBuff, 0); dib;
end
%........................................................................

%% Check we are on PTB
if iscog
    stopcogent;
    error('This function does not support Cogent. You must start CosyGraphics with startpsych to get it running.')
end

%% Input Args
% Defaults values:
if ~exist('xy','var')
    xy = [0 0];
    if ~exist('BgBuff','var')
        BgBuff = [];
        if ~exist('TargBuff','var')
            TargBuff = gcw;
        end
    end
end

% BgBuff, :
switch numel(BgBuff)
    case 0  % []
        BgColor = COSY_DISPLAY.BackgroundColor;
        isPeriphBuff = 0;
    case 1  % Buffer #
        isPeriphBuff = 1;
    case {3,4}  % Color
        BgColor = BgBuff;
        BgBuff = [];
        isPeriphBuff = 0;
end
    
% TargBuff:
if ~exist('TargBuff','var') || TargBuff==0
    TargBuff = gcw;
end

%% Copy buffers!
% Step 1: Draw the alpha-mask into the backbuffer.
[sOld,dOld] = Screen('BlendFunction', TargBuff, GL_ONE, GL_ZERO);
if isPeriphBuff
    copybuffer(AlphaMaskBuff, TargBuff, xy);
else
    copybuffer(AlphaMaskBuff, TargBuff, xy, '-colorfilter', BgColor);
end
% imshow(getbufferalpha)

% Step 2: Draw peripheral (background) image.
if isPeriphBuff
    Screen('BlendFunction', TargBuff, GL_DST_ALPHA, GL_ZERO);
    copybuffer(BgBuff,TargBuff);
end

% Step 3: Draw foveated (foreground) image.
Screen('BlendFunction', TargBuff, GL_ONE_MINUS_DST_ALPHA, GL_ONE);
copybuffer(FgBuff,TargBuff); 

% Restore buffer's state
[sOld,dOld] = Screen('BlendFunction', TargBuff, sOld, dOld);
