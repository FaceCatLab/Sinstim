function [x,y,fsample] = geteye
% GETEYE  Get EyeLink last acquired sample.
%    xy = GETEYE  returns gaze position in cartesian coordinates in pixels.
%
%    [x,y] = GETEYE  id.
%
%    [x,y,fsample] = GETEYE  returns also all sample data in structure fsample (see below).
%
% See also: OPENEYELINK, ISINSIDE, GETEYELINKEVENTS.
%
%
%%   27.9 FSAMPLE Struct Reference (EyeLink Programmer Guide, p.321)
%             27.9.1 Detailed Description
%             Floating-point sample.
%             The EyeLink tracker measures eye position 250, 500, 1000 or 2000 times per second depending on the
%             tracking mode you are working with, and computes true gaze position on the display using the head camera
%             data. This data is stored in the EDF file, and made available through the link in as little as 3 milliseconds
%             after a physical eye movement. Samples can be read from the link by eyelink_get_float_data() or eyelink_-
%             newest_float_sample().
%             If sample rate is 2000hz, two samples with same time stamp possible. If SAMPLE_ADD_OFFSET is set
%             on the flags, add .5 ms to get the real time. Convenient FLOAT_TIME can also be used.
%             Data Fields
%             • UINT32 time
%             • INT16 type
%             • UINT16 flags
%             • float px [2]
%             • float py [2]
%             • float hx [2]
%             • float hy [2]
%             • float pa [2]
%             • float gx [2]
%             • float gy [2]
%             • float rx
%             • float ry
%             • UINT16 status
%             • UINT16 input
%             • UINT16 buttons
%             • INT16 htype
%             • INT16 hdata [8]
% 
%%    Data types in structure s: (Source: EyeLink Programmer Guide, EyeLink Data Types)
%
%                 UINT32 time;            // time of sample
%                 INT16  type;            // always SAMPLE_TYPE
% 
%                 UINT16 flags;           // flags to indicate contents
%                 // binocular data: indices are 0 (LEFT_EYE) or 1 (RIGHT_EYE)
%                 float  px[2], py[2];    // pupil xy
%                 float  hx[2], hy[2];    // headref xy
%                 float  pa[2];           // pupil size or area
%                 float gx[2], gy[2];     // screen gaze xy
%                 float rx, ry;           // screen pixels per degree (angular resolution)
% 
% 
%                 UINT16 status;          // tracker status flags
%                 UINT16 input;           // extra (input word)
%                 UINT16 buttons;         // button state & changes
% 
%                 INT16  htype;           // head-tracker data type (0=noe)
%                 INT16  hdata[8];        // head-tracker data (not prescaled)
%
%
%%    Example of s structure:
%
%                 s =
%
%             time: 2518887              % tracker time
%             type: 200
%            flags: 42881
%               px: [-32768 -32768]      % pupil x, [left right], -32768 = MISSING_DATA
%               py: [-32768 -32768]
%               hx: [-32768 -32768]      % headref x
%               hy: [-32768 -32768]
%               pa: [1000 32768]         % pupil area
%               gx: [398.8000 -32768]    % screenref gaze x (graphics coord. (JI), pixels)
%               gy: [298.8000 -32768]
%               rx: 21.1000              % ?
%               ry: 19
%           status: 0
%            input: 32768
%          buttons: 0                    % gamepad button ?
%            htype: 0
%            hdata: [0 0 0 0 0 0 0 0]

%%
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

global COSY_EYELINK COSY_DISPLAY

ok = 1;

%% Check EyeLink is recording
if ~checkeyelink('isrecording')
    error('EyeLink tracker not recording. See OPENEYELINK and STARTEYELINKRECORD.')
end

%% Get sample
if checkeyelink('isdummy') %% DUMMY MODE
    % Get mouse sample, as replacement
    [x,y] = getmouse;
    
else                       %% NORMAL MODE
    %% Get eye sample
    if Eyelink('NewFloatSampleAvailable') > 0
        % get the sample in the form of an event structure
        fsample = Eyelink('NewestFloatSample');
        COSY_EYELINK.PreviousSample = fsample;

    else % no new sample available..
        if isfilledfield(COSY_EYELINK,'PreviousSample')
            fsample = COSY_EYELINK.PreviousSample; % ..keep the last one.

        else
            error('No sample acquired, yet.')

        end
    end

    %% Get x and y, in cartesian coord.
    if ok
        e = COSY_EYELINK.EyeUsed;

        if e ~= -1 % do we know which eye to use yet?
            % If we do, get current gaze position from sample
            x = fsample.gx(e+1); % +1 as we're accessing MATLAB array
            y = fsample.gy(e+1);

            % Do we have valid data and is the pupil visible?
            if x~=COSY_EYELINK.EL.MISSING_DATA & y~=COSY_EYELINK.EL.MISSING_DATA & fsample.pa(e+1)>0
                % PTB coord. -> cartesian coord.
                [w,h] = getscreenres;
                x =  x - w/2;
                y = -y + h/2 + COSY_DISPLAY.Offset(2);

            else
                ok = 0;

            end

        else
            error('EyeUsed = -1; Don''t know what eye to use.')

        end
    end

    %% No sample available
    if ~ok
        x = NaN;
        y = NaN;
        fsample = [];
    end
end

%% Output Arg.
if nargout <= 1,
    x = [x y];  % [x,y] -> xy
end