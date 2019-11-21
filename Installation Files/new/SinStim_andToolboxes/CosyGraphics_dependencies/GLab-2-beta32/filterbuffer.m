function bf = filterbuffer(b,kernel)
% FILTERBUFFER  Filter an offscreen buffer. <PTB only>
% bf = filterbuffer(b,kernel)  filters buffer b, applying kernel. All the job
%    is done by the GPU. 
%
%    'kernel' is a simple m-by-n matrix of floating point numbers with m and
%    n being odd numbers, e.g., 1x1, 3x3, 5x5, 7x7, 9x9,..., 1x3, 1x9, 7x1 ...
%    Each entry in the kernel matrix is used as a weight factor for the
%    convolution.
%  
%    The simplest way to get a 2D kernel is to use the function
%    kernel = fspecial(...); fspecial is part of the Matlab image
%    processing toolbox, see "help fspecial" for more information.


% Programmer's notes: 
% 1) This code is mainly taken from FastFilteredNoiseDemo.
% 2) The LoadGLSLProgramFromFiles has been modified.

% Performances: 
% See below. Measured on DARTAGNAN, on M7.5.
% Note that first call is far SLOWER !!! Pre-load function ! 
% Even after, seems VERY _VARIABLE !!! Seems more variable on M6.5 !!

global GLAB_BUFFERS

Verbosity = 0;

% Build shader from kernel:
convoperator = CreateGLOperator(gcw, kPsychNeed32BPCFloat); % 0.2 ms on DARTAGNAN
% t2=time; dt2=t2-t1
nrinputchannels = 4; % <in/out inverted ??? Seems to be different on DARTAGNAN and CHEOPS !>
nroutchannels = 4;
Add2DConvolutionToGLOperator(convoperator, kernel, [], nrinputchannels, nroutchannels, Verbosity); % 2.1 ms on DARTAGNAN (very variable!)
glFinish;
% t3=time; dt3=t3-t2

% Apply filter to texture:
for i = 1 : numel(b)
    bf(i) = Screen('TransformTexture', b(i), convoperator, []); % 1.4 ms on DARTAGNAN
end
% t4=time; dt4=t4-t3

% Global vars
GLAB_BUFFERS.OffscreenBuffers(end+1) = bf;
GLAB_BUFFERS.isTexture(end+1) = 1;