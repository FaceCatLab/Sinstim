function varargout = drawalpha(varargin)
% DRAWALPHA   <TODO>


global COSY_DISPLAY


DestBuffer = varargin{3};
varargin{3} = COSY_DISPLAY.BUFFERS.DraftBuffer;


Screen('BlendFunction', gcw, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

clearbuffer(COSY_DISPLAY.BUFFERS.DraftBuffer, [0 0 0 0]);
varargout = draw(varargin{:});




Screen('BlendFunction', gcw, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);