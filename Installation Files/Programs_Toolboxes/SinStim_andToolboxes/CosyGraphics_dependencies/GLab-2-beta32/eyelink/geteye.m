function [x,y,sample,raw] = geteye
% GETEYE  Get EyeLink last acquired sample.
%    [x,y] = GETEYE  or  xy = GETEYE  returns gaze position in
%    cartesian coordinates in pixels.
%
%    [x,y,s] = GETEYE  returns also all sample data in structure s, as 
%    returned by s = EyeLink('NewestFloatSample'); See below.
%
%    [x,y,s,r] = GETEYE  returns raw sample data in structure r.
%
%
%    Data types in structure s: (Source: EyeLink Programmer Guide, EyeLink Data Types)
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
%    Example of s structure:
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

global GLAB_EYELINK

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
    if EyeLink( 'NewFloatSampleAvailable') > 0
        % get the sample in the form of an event structure
        [sample,raw] = EyeLink('NewestFloatSampleRaw');
        GLAB_EYELINK.PreviousSample = sample;

    else % no new sample available..
        if isfilledfield(GLAB_EYELINK,'PreviousSample')
            sample = GLAB_EYELINK.PreviousSample; % ..keep the last one.

        else
            error('No sample acquired, yet.')

        end
    end

    %% Get x and y, in cartesian coord.
    if ok
        e = GLAB_EYELINK.EyeUsed;

        if e ~= -1 % do we know which eye to use yet?
            % If we do, get current gaze position from sample
            x = sample.gx(e+1); % +1 as we're accessing MATLAB array
            y = sample.gy(e+1);

            % Do we have valid data and is the pupil visible?
            if x~=GLAB_EYELINK.EL.MISSING_DATA & y~=GLAB_EYELINK.EL.MISSING_DATA & sample.pa(e+1)>0
                % graphics coord. -> cartesian coord.
                [w,h] = getscreenres;
                x =  x - w/2;
                y = -y + h/2;

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
        sample = [];
        raw = [];
    end
end

%% Output Arg.
if nargout <= 1,
    x = [x y];  % [x,y] -> xy
end