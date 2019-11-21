function geteyelinkevent
% GETEYELINKEVENT  <TODO>


%                 UINT32 time;       // effective time of event
%                 INT16  type;       // event type
%                 UINT16 read;       // flags which items were included
%                 INT16  eye;        // eye: 0=left,1=right
%                 UINT32 sttime, entime;   // start, end sample timestamps
% 
%                 float  hstx, hsty;       // href position at start
%                 float  gstx, gsty;       // gaze or pupil position at start
%                 float  sta;                  // pupil size at start
%                 float  henx, heny;       // href position at end
%                 float  genx, geny;       // gaze or pupil position at end
%                 float  ena;                  // pupil size at start
% 
%                 float  havx, havy;       // average href position
%                 float  gavx, gavy;       // average gaze or pupil position
%                 float  ava;                  // average pupil size
%                 float  avel;             // average velocity
%                 float  pvel;             // peak velocity
%                 float  svel, evel;       // start, end velocity
% 
%                 float  supd_x, eupd_x;   // start, end angular resolution
%                 float  supd_y, eupd_y;   // (pixel units-per-degree)
%                 UINT16 status;           // error, warning flags
% From: Eyelink Programmer Guide, EyeLink Data Types
