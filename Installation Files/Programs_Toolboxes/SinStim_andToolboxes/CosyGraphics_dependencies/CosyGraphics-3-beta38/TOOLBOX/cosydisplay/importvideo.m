function importvideo 
% IMPORTVIDEO  Import images and sound from a video-file as Matlab variables. <unfinished>
%    [video,audio] = IMPORTVIDEO(filename)  reads file (mpg, avi, wmv, asf, wav, mp3, gif, ...)
%    and video and audio content as Matlab strucures.


[video,audio] = IMPORTVIDEO(mmread);


videoDuration = video.times(end)-video.times(1) + video.times(2)-video.times(1);