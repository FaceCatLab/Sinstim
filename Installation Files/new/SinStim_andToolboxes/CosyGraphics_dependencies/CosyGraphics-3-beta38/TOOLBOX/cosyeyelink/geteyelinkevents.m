function  Q = geteyelinkevents(EventWaited)
% GETEYELINKEVENTS  Get all events currently in EyeLink queue.
%    Q = GETEYELINKEVENTS  returns the whole event queue in structure Q (one element 
%    per event) since recording start or since the last call to GETEYELINKEVENTS or WAITEYELINKEVENT.
%    t is a standard CosyGraphics timestamp (msec, in Matlab PC's time), or a vector of timestamps. 
%    n is the number of events.
%
%    Q = GETEYELINKEVENTS(EventWaited)  waits specific event.  See below for valid event names.
%
%      'EventWaited' can be:
%         'STARTBLINK'  pupil disappeared, time only
%         'ENDBLINK'    pupil reappeared, duration data
%         'STARTSACC'   start of saccade, time only
%         'ENDSACC'     end of saccade, summary data
%         'STARTFIX'    start of "fixation", time only (NB: What SR-Research calls a "fixation" is anything outside saccades.)
%         'ENDFIX'      end of "fixation", summary data
%         'FIXUPDATE'   update within fixation, summary data for interval
%
%        Q strucure's fields are:
%           .name       - event name (see below)
%           .type       - event code number (see below)
%           .time       - event's timestamp (corrected to be in Matlab PC's referential)
%           .eye        - 0: left eye, 1: right eye
%           .data       - EyeLink's summary data structure (FEVENT struct - see below)
%
%
%        Events names and types:
%           STARTBLINK      = 3;
%           ENDBLINK        = 4;
%           STARTSACC       = 5;
%           ENDSACC         = 6;
%           STARTFIX        = 7;
%           ENDFIX          = 8;
%           FIXUPDATE       = 9;
%           LOST_DATA_EVENT = 63;
%
%
%        FEVENT Struct Reference (from EyeLink Programmer’s Guide, p.317)
%             27.8.1 Detailed Description
%             Floating-point eye event.
%             The EyeLink tracker analyzes the eye-position samples during recording to detect saccades, and accumulates
%             data on saccades and fixations. Events are produced to mark the start and end of saccades, fixations
%             and blinks. When both eyes are being tracked, left and right eye events are produced, as indicated in the
%             eye field of the FEVENT structure.
%             Start events contain only the start time, and optionally the start eye or gaze position. End events contain the
%             start and end time, plus summary data on saccades and fixations. This includes start and end and average
%             measures of position and pupil size, plus peak and average velocity in degrees per second.
%             Data Fields
%             • UINT32 time
%             • INT16 type
%             • UINT16 read
%             • INT16 eye
%             • UINT32 sttime
%             • UINT32 entime
%             • float hstx
%             • float hsty
%             • float gstx
%             • float gsty
%             • float sta
%             • float henx
%             • float heny
%             • float genx
%             • float geny
%             • float ena
%             • float havx
%             • float havy
%             • float gavx
%             • float gavy
%             • float ava
%             • float avel
%             • float pvel
%             • float svel
%             • float evel
%             • float supd_x
%             • float eupd_x
%             • float supd_y
%             • float eupd_y
%             • UINT16 status
%
%             27.8.2 Field Documentation
%             27.8.2.1 float ava
%             average area
%             27.8.2.2 float avel
%             avg velocity accum
%             27.8.2.3 float ena
%             ending area
%             27.8.2.4 UINT32 entime
%             end times
%             27.8.2.5 float eupd_x
%             end units-per-degree x
%             27.8.2.6 float eupd_y
%             end units-per-degree y
%             27.8.2.7 float evel
%             end velocity
%             27.8.2.8 INT16 eye
%             eye: 0=left,1=right
%             27.8.2.9 float gavx
%             average x
%             27.8.2.10 float gavy
%             average y
%             27.8.2.11 float genx
%             ending point x
%             Copyright ©2006, SR Research Ltd.
%             27.8 FEVENT Struct Reference 319
%             27.8.2.12 float geny
%             ending point y
%             27.8.2.13 float gstx
%             starting point x
%             27.8.2.14 float gsty
%             starting point y
%             27.8.2.15 float havx
%             average x
%             27.8.2.16 float havy
%             average y
%             27.8.2.17 float henx
%             ending point x
%             27.8.2.18 float heny
%             ending point y
%             27.8.2.19 float hstx
%             starting point x
%             27.8.2.20 float hsty
%             starting point y
%             27.8.2.21 float pvel
%             peak velocity accum
%             27.8.2.22 UINT16 read
%             flags which items were included
%             Copyright ©2006, SR Research Ltd.
%             320 Data Structure
%             27.8.2.23 float sta
%             starting area
%             27.8.2.24 UINT16 status
%             error, warning flags
%             27.8.2.25 UINT32 sttime
%             start times
%             27.8.2.26 float supd_x
%             start units-per-degree x
%             27.8.2.27 float supd_y
%             start units-per-degree y
%             27.8.2.28 float svel
%             start velocity
%             27.8.2.29 UINT32 time
%             effective time of event
%             27.8.2.30 INT16 type
%             event type
%
% See also: GETEYELINKEVENTS.

%% EyeLink's doc 
% !!!---- See end of file for EyeLink doc ----!!!

%% Global & Persistent Vars
global COSY_EYELINK %!<v2-beta55>
persistent isLostDataEvent
if isempty(isLostDataEvent), isLostDataEvent = 0; end

%% Start time!
tFunStart = time;

%% Debug!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
isDebug = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check EyeLink is recording  %!<v2-beta55>
if isempty(COSY_EYELINK) || ~COSY_EYELINK.isRecording  %!<v2-beta55>
    stopcosy; %!<v2-beta55>
    error('EyeLink not recording. See STARTEYELINKRECORD.')
end

%% Input Args
if nargin, EventWaited = upper(EventWaited); end

%% Constants
LOST_DATA_EVENT =  63;
SAMPLE_TYPE     = 200;

STARTBLINK	= 3;
ENDBLINK    = 4;
STARTSACC   = 5;
ENDSACC     = 6;
STARTFIX    = 7;
ENDFIX      = 8;
FIXUPDATE   = 9;

%% Get events from EL's queue
Q = [];
e = 1;

for i = 1:4 %<v3-beta11: HACK!!! Must be called 3 times to get an event!!! Let's call it 4 times for security>
%             %<v3-beta11: Perf. after hack: 0.13 msec (on HERMES)>
    while 1
        type = Eyelink('GetNextDataType');

        if type && type ~= SAMPLE_TYPE && type ~= LOST_DATA_EVENT
            FEvent = Eyelink('GetFloatData', type);

            switch type
                case 3, EventName = 'STARTBLINK';
                case 4, EventName = 'ENDBLINK';
                case 5, EventName = 'STARTSACC';
                case 6, EventName = 'ENDSACC';
                case 7, EventName = 'STARTFIX';
                case 8, EventName = 'ENDFIX';
                case 9, EventName = 'FIXUPDATE';
                case 63, EventName = 'LOST_DATA_EVENT';
                otherwise, EventName = '???';
            end

            Q(e).name = EventName;
            Q(e).type = type;
            if isfield(FEvent,'time')
                Q(e).time = FEvent.time;
            else
                Q(e).time = NaN;
            end
            if isfield(FEvent,'eye')
                switch FEvent.eye
                    case 0, Q(e).eye = 'L';
                    case 1, Q(e).eye = 'R';
                    otherwise, Q(e).eye = '-';
                end
            else
                Q(e).eye = '-';
            end
            
            Q(e).data = FEvent;

            if type == LOST_DATA_EVENT
                if ~isLostDataEvent
                    helper_dispevent(mfilename,'error','Lost data event! Some data sent by the EyeLink PC through TCP/IP have been lost!');
                    isLostDataEvent = 1; % we want tostart do that only once.
                end
            end

            e = e + 1;

        elseif type == 0
            break % ! Queue empty.

        end
    end
    
end

%% Case of specific event
if nargin 
    for e = length(Q) : -1 : 1
        if ~strcmpi(Q(e).name,EventWaited)
            Q(e) = []; % Delete unwanted event
        end
    end
end

%% Timestamps
n = length(Q);
if n
    offset = geteyelinktimeoffset;
    for e = 1 : n
        Q(e).time = offset + Q(e).time;
    end
end

%% Debug
if isDebug
    if n > 0 
        dt = TimeStamps - tFunStart;
        events = '';
        for e = 1:n
            events = [events '  ' Q(e).name];
        end
        drawdebuginfo(events,dt);
    end
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EYELINK PROGRAMMER'S MANUAL DOCUMENTATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% About events, from EyeLink Programmer’s Guide (v3.0, 2006)
%% 7.2.2 Event Data
% The EyeLink tracker simplifies data analysis (both on-line and when processing data files) by detecting
% important changes in the sample data and placing corresponding events into the data stream. These include
% eye-data events (blinks, saccades, and fixations), button events, input-port events, and messages.
% Events may be retrieved by the eyelink_get_float_data() function, and are stored as C structures.
% All events share the time and type fields in their structures. The type field uniquely identifies each
% event type:
% // EYE DATA EVENT: all use FEVENT structure
% #define STARTBLINK 3 // pupil disappeared, time only
% #define ENDBLINK 4 // pupil reappeared, duration data
% #define STARTSACC 5 // start of saccade, time only
% #define ENDSACC 6 // end of saccade, summary data
% #define STARTFIX 7 // start of fixation, time only
% #define ENDFIX 8 // end of fixation, summary data
% #define FIXUPDATE 9 // update within fixation, summary data for interval
% #define MESSAGEEVENT 24 // user-definable text: IMESSAGE structure
% #define BUTTONEVENT 25 // button state change: IOEVENT structure
% #define INPUTEVENT 28 // change of input port: IOEVENT structure
% #define LOST_DATA_EVENT 0x3F // NEW: Event flags gap in data stream
% Events are read into a buffer supplied by your program. Any event can be read into a buffer of type
% ALLF_EVENT, which is a union of all the event and sample buffer formats:
% 
% typedef union {
% FEVENT fe;
% IMESSAGE im;
% IOEVENT io;
% FSAMPLE fs;
% } ALLF_DATA ;
% It is important to remember that data sent over the link does not arrive in strict time sequence. Typically, eye
% events (such as STARTSACC and ENDFIX) arrive up to 32 milliseconds after the corresponding samples,
% and messages and buttons may arrive before a sample with the same time code. This differs from the
% order seen in an ASC file, where the events and samples have been sorted into a consistent order by their
% timestamps.
% The LOST_DATA_EVENT is a newly added event, introduced for version 2.1 and later, and produced
% within the DLL to mark the location of lost data. It is possible that data may be lost, either during recording
% with real-time data enabled, or during playback. This might happen because of a lost link packet or because
% data was not read fast enough (data is stored in a large queue that can hold 2 to 10 seconds of data, and once
% it is full the the oldest data is discarded to make room for new data). This event has no data or time associated
% with it.
%
%% 18.5.2 Processing Link Data (p.103)
% When the EyeLink library receives data from the tracker through the link, it places it in a large data buffer
% called the queue. This can hold 4 to 10 seconds of data, and delivers samples and events in the order they
% were received.
% A data item can be read from the queue by calling eyelink_get_next_data(), which returns a code
% for the event type. The value SAMPLE_TYPE is returned if a sample was read from the queue. Otherwise,
% an event was read from the queue and a value is returned that identifies the event. The header file eye_data.h
% contains a list of constants to identify the event codes.
% If 0 was returned, the data queue was empty. This could mean that all data has been played back, or simply
% that the link is busy transferring more data. We can use eyelink_current_mode() to test if playback
% is done.
% // PROCESS PLAYBACK DATA FROM LINK
% i = eyelink_get_next_data(NULL); // check for new data item
% if(i==0) // 0: no new data
% { // Check if playback has completed
% if((eyelink_current_mode() & IN_PLAYBACK_MODE)==0) break;
% }
% If the item read by eyelink_get_next_data() was one we want to process, it can be copied into
% a buffer by eyelink_get_float_data(). This buffer should be a structure of type FSAMPLE for
% samples, and ALLF_DATA for either samples or events. These types are defined in eye_data.h.
% It is important to remember that data sent over the link does not arrive in strict time sequence. Typically, eye
% events (such as STARTSACC and ENDFIX) arrive up to 32 milliseconds after the corresponding samples,
% and messages and buttons may arrive before a sample with the same time code.
%
%% 18.5.3 Processing Events
% In playback_trial.c, fixations will be plotted by drawing an ’F’ at the average gaze position. The ENDFIX
% event is produced at the end of each fixation, and contains the summary data for gaze during the fixation.
% The event data is read from the fe (floating-point eye data) field of the ALLF_DATA type, and the average
% x and y gaze positions are in the gavx and gavy subfields respectively.
% if(i == ENDFIX) // Was it a fixation event ?
% {// PLOT FIXATIONS
% eyelink_get_float_data(&evt); // get copy of fixation event
% if(evt.fe.eye == eye_used) // is it the eye we are plotting?
% {// Print a black "F" at average position
% graphic_printf(window, black, NONE, (int)evt.fe.gavx, (int)evt.fe.gavy, "F");
% SDL_Flip(window);
% graphic_printf(window, black, NONE, (int)evt.fe.gavx, (int)evt.fe.gavy, "F");
% }
% }
% It is important to check which eye produced the ENDFIX event. When recording binocularly, both eyes
% produce separate ENDFIX events, so we must select those from the eye we are plotting gaze position for.
% The eye to monitor is determined during processing of samples.
%
%% 18.5.4 Detecting Lost Data
% It is possible that data may be lost, either during recording with real-time data enabled, or during playback.
% This might happen because of a lost link packet or because data was not read fast enough (data is stored in
% a large queue that can hold 2 to 10 seconds of data, and once it is full the oldest data is discarded to make
% room for new data). Versions 2.1 and higher of the library will mark data loss by causing a LOST_DATA_-
% EVENT to be returned by eyelink_get_next_data() at the point in the data stream where data is
% missing. This event is defined in the latest version of eye_data.h, and the #ifdef test in the code below
% ensures compatibility with older versions of this file.
% #ifdef LOST_DATA_EVENT // AVAILABLE IN V2.1 OR LATER DLL ONLY
% else if(i == LOST_DATA_EVENT)
% {
% alert_printf("Lost data in sequence");
% }
% #endif

%% 27.8 FEVENT Struct Reference (p.317)
% 27.8.1 Detailed Description
% Floating-point eye event.
% The EyeLink tracker analyzes the eye-position samples during recording to detect saccades, and accumulates
% data on saccades and fixations. Events are produced to mark the start and end of saccades, fixations
% and blinks. When both eyes are being tracked, left and right eye events are produced, as indicated in the
% eye field of the FEVENT structure.
% Start events contain only the start time, and optionally the start eye or gaze position. End events contain the
% start and end time, plus summary data on saccades and fixations. This includes start and end and average
% measures of position and pupil size, plus peak and average velocity in degrees per second.
% Data Fields
% • UINT32 time
% • INT16 type
% • UINT16 read
% • INT16 eye
% • UINT32 sttime
% • UINT32 entime
% • float hstx
% • float hsty
% • float gstx
% • float gsty
% • float sta
% • float henx
% • float heny
% • float genx
% • float geny
% • float ena
% • float havx
% • float havy
% • float gavx
% • float gavy
% • float ava
% • float avel
% • float pvel
% • float svel
% • float evel
% • float supd_x
% • float eupd_x
% • float supd_y
% • float eupd_y
% • UINT16 status
% Copyright ©2006, SR Research Ltd.
% 318 Data Structure
% 27.8.2 Field Documentation
% 27.8.2.1 float ava
% average area
% 27.8.2.2 float avel
% avg velocity accum
% 27.8.2.3 float ena
% ending area
% 27.8.2.4 UINT32 entime
% end times
% 27.8.2.5 float eupd_x
% end units-per-degree x
% 27.8.2.6 float eupd_y
% end units-per-degree y
% 27.8.2.7 float evel
% end velocity
% 27.8.2.8 INT16 eye
% eye: 0=left,1=right
% 27.8.2.9 float gavx
% average x
% 27.8.2.10 float gavy
% average y
% 27.8.2.11 float genx
% ending point x
% Copyright ©2006, SR Research Ltd.
% 27.8 FEVENT Struct Reference 319
% 27.8.2.12 float geny
% ending point y
% 27.8.2.13 float gstx
% starting point x
% 27.8.2.14 float gsty
% starting point y
% 27.8.2.15 float havx
% average x
% 27.8.2.16 float havy
% average y
% 27.8.2.17 float henx
% ending point x
% 27.8.2.18 float heny
% ending point y
% 27.8.2.19 float hstx
% starting point x
% 27.8.2.20 float hsty
% starting point y
% 27.8.2.21 float pvel
% peak velocity accum
% 27.8.2.22 UINT16 read
% flags which items were included
% Copyright ©2006, SR Research Ltd.
% 320 Data Structure
% 27.8.2.23 float sta
% starting area
% 27.8.2.24 UINT16 status
% error, warning flags
% 27.8.2.25 UINT32 sttime
% start times
% 27.8.2.26 float supd_x
% start units-per-degree x
% 27.8.2.27 float supd_y
% start units-per-degree y
% 27.8.2.28 float svel
% start velocity
% 27.8.2.29 UINT32 time
% effective time of event
% 27.8.2.30 INT16 type
% event type

%% 27.9 FSAMPLE Struct Reference (p.321)
% 27.9.1 Detailed Description
% Floating-point sample.
% The EyeLink tracker measures eye position 250, 500, 1000 or 2000 times per second depending on the
% tracking mode you are working with, and computes true gaze position on the display using the head camera
% data. This data is stored in the EDF file, and made available through the link in as little as 3 milliseconds
% after a physical eye movement. Samples can be read from the link by eyelink_get_float_data() or eyelink_-
% newest_float_sample().
% If sample rate is 2000hz, two samples with same time stamp possible. If SAMPLE_ADD_OFFSET is set
% on the flags, add .5 ms to get the real time. Convenient FLOAT_TIME can also be used.
% Data Fields
% • UINT32 time
% • INT16 type
% • UINT16 flags
% • float px [2]
% • float py [2]
% • float hx [2]
% • float hy [2]
% • float pa [2]
% • float gx [2]
% • float gy [2]
% • float rx
% • float ry
% • UINT16 status
% • UINT16 input
% • UINT16 buttons
% • INT16 htype
% • INT16 hdata [8]
