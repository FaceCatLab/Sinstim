function createvideotestfile(FileName,Resolution,NbOfFrames)
% CREATEVIDEOTESTFILE  Create video file of alternating black/white frames to test real-time flow.
 %   CREATEVIDEOTESTFILE(FileName,Resolution,NbOfFrames)
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%
 rgb1 = [0 0 0];
 rgb2 = [1 1 1];
 %%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 if nargin < 3
     NbOfFrames = 10 * round(getscreenfreq);
 end

 startpsych(0,Resolution);

 startvideorecord;
 starttrial;

 for f = 1 : NbOfFrames
     if rem(f,2), clearbuffer(0,rgb1);
     else         clearbuffer(0,rgb2);
     end
     displaybuffer(0, oneframe);
 end

 stoptrial;
 stopvideorecord;

 stopcosy;

 savevideorecord(FileName);