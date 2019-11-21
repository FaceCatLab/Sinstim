function s = waiteyelinksaccade(arg1, arg2)
% WAITEYELINKSACCADE  Wait for a full saccade and get saccade's parameters.
%    S = WAITEYELINKSACCADE(EventWaited, TimeOut);  waits up to TimeOut for a 'STARTSACC' event,
%    then if got one, waits up to one second for a 'ENDSACC' event. The S structure conains all
%    saccade parameters.
%
%    S = WAITEYELINKSACCADE(EventWaited, t0, TimeOut);  waits until t0 + TimeOut, rejects saccades 
%    started before t0.

%% Input Args
switch nargin 
    case 1    
        t0 = time;
        TimeOut = arg1;
    case 2
        t0 = arg1;
        TimeOut = arg2;
end

%% Init Vars
q0 = [];
q1 = [];
gotStart = 0;
gotEnd = 0;

%% Wait STARTSACC...
while ~gotStart && time < t0 + TimeOut
    q = geteyelinkevents;
    for i = 1 : length(q)
        if strcmp(q(i).name,'STARTSACC') && q(i).time > t0 
            q0 = q(i);
            q(1:i) = [];
            gotStart = 1;
            tGotStart = time;
            break %         <---BREAK-FOR---!!! 
        end
    end
    if ~gotStart, wait(1); end
end

%% Wait ENDSACC...
if gotStart
    % Get pupil area at sacc onset %<v3-beta35>
    [x,y,fsample] = geteye;
    isvalid = abs(fsample.pa) < 32768;
    PupilAreaBefore = fsample.pa(isvalid);
    
    % Wait ENDSACC..
    while ~gotEnd && time < tGotStart + 1000;
        for i = 1 : length(q)
            if strcmp(q(i).name,'STARTSACC')
                gotEnd = -1; % error!
                break
            elseif strcmp(q(i).name,'ENDSACC')
                q1 = q(i);
                gotEnd = 1;
                break %         <---BREAK-FOR---!!!
            end
        end
        if ~gotEnd,
            wait(1);
            q = geteyelinkevents; % call it AFTER because on first iteration we check the q comming from previous while loop!
        end
    end
end
if gotEnd == -1, gotEnd = 0; end

%% Get Saccade Parameters
if gotStart
    d0 = q0.data;
    
    if gotEnd
        d1 = q1.data;
    else % endsacc missing
        q1.time = nan;
        d1.gstx = nan;
        d1.gsty = nan;
        d1.genx = nan;
        d1.geny = nan;
        d1.pvel = nan;
        d1.avel = nan;
        d1.ava = nan;
    end

    s.time = q0.time; % same than s.t0_ms, for consistency with geteyelinkevents/waiteyelinkevent q struct.
    s.eye = d0.eye;
    
    s.t0 = round(q0.time);
    s.t1 = round(q1.time);
    s.Duration = s.t1 - s.t0;
    
    s.x0_pix = d0.gstx;
    s.y0_pix = d0.gsty;
    s.x1_pix = d1.genx;
    s.y1_pix = d1.geny;
    s.xAmplitude_pix = s.x1_pix - s.x0_pix;
    s.yAmplitude_pix = s.x1_pix - s.x0_pix;
    s.Amplitude_pix = sqrt(s.xAmplitude_pix^2 + s.yAmplitude_pix^2);
    s.PeakVel_pix_per_s = d1.pvel;
    s.MeanVel_pix_per_s = d1.avel;
    
    s.x0_deg = pix2deg(s.x0_pix);
    s.y0_deg = pix2deg(s.y0_pix);
    s.x1_deg = pix2deg(s.x1_pix);
    s.y1_deg = pix2deg(s.y1_pix);
    s.xAmplitude_deg = pix2deg(s.xAmplitude_pix);
    s.yAmplitude_deg = pix2deg(s.yAmplitude_pix);
    s.Amplitude_deg = sqrt(s.xAmplitude_deg^2 + s.yAmplitude_deg^2);
    s.PeakVel_deg_per_s = pix2deg(s.PeakVel_pix_per_s);
    s.MeanVel_deg_per_s = pix2deg(s.MeanVel_pix_per_s);
    
    s.PupilArea = PupilAreaBefore; %<v3-beta35: Replace mean area (d1.ava), not working, by area at sacc onset (also better scientifically).>
    
else
    s = [];
    
end