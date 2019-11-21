function savevideorecord(FileName,Hz)
% SAVEVIDEORECORD  Create video file from images captured in video recording mode.
%    SAVEVIDEORECORD(FILENAME)  saves captured video images (see SETVIDEORECORD) to file.
%    Supported file types are '.wmv', '.wma', '.asf' and '.avi'.  Videos are stored uncompressed
%    to ensure maximum chances to get a smooth playback.
%
% See also SETVIDEORECORD, MMWRITE.
%
% Ben, Oct 2012.

global COSY_VIDEO

if nargin < 2
    Hz = getscreenfreq;
end

n = length(COSY_VIDEO.RecordedImages);

video.times = (1:n) * (1/Hz);
for i = 1 : n
    video.frames(i).cdata = COSY_VIDEO.RecordedImages{i};
    video.frames(i).colormap = [];
end
[w,h] = getscreenres;
video.height = h;
video.width = w;

dispinfo(mfilename,'info',sprintf('Writing recorded video to file "%s"...',FileName));
[path,name,ext] = fileparts(FileName);
switch lower(ext)
    case {'.wmv','.wma','.asf'}
        conf.videoQuality = 100; % Uncompressed to get deterministic reading times (!!)
        mmwrite(FileName,video,conf);
    case '.avi' % (no compression by default)
        mmwrite(FileName,video);
    otherwise
        if isopen('display'), stopcosy; end
        error('Unknown file extension. Valid file types are: *.avi, *.wmv, *.wma, *.asf.')
end

COSY_VIDEO.iDisplay = 0;
COSY_VIDEO.RecordedImages = {}; % clear it to save memory.