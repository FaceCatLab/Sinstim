function tr = glabhelper_processtrials(tr)
% GLABHELPER_PROCESSTRIALS  Post-processing on trials data. Used by GETTRIALS.
% TR = GLABHELPER_PROCESSTRIALS(TR)

%% Debug mode
debug = 0;
if debug, dispinfo(mfilename,'WARNING','Running in debug mode...'), end

%% #
nTrials = numel(tr);

%% Remove fields
nongrata = {'isStarted','isWaitingFirstFrame','EventsString_i0','ParallelOutQueue'};
for f = 1 : length(nongrata)
    try    tr = rmfield(tr,nongrata{f});
    catch  if debug, dispinfo(mfilename,'DEBUGWARNING',['Non existing field: "' nongrata{f} '".']), end
    end
end

%% Change fields: i* -> n*s
if ~isfield(tr,'nFrames')
    for i = 1 : nTrials
        tr(i).nFrames   = tr(i).iFrame;
        tr(i).nDisplays = tr(i).iDisplay;
    end
    tr = rmfield(tr,{'iFrame','iDisplay'});
end

%% Round times to µsec <bizarre bug on M7.5; working well on M6.5>
for i = 1 : nTrials
    % PERFRAME
    n = tr(i).nFrames;
    fields = fieldnames(tr(i).PERFRAME);
    for f = 1 : length(fields)
        field = fields{f};
        if strcmp(class(tr(i).PERFRAME.(field)),'double')
            if any(globfind(field,'*TimeStamps')) || any(globfind(field,'*_ms'))
                tmp = tr(i).PERFRAME.(field) - round(tr(i).PERFRAME.(field)(1));
                tmp = round(tmp*1000) / 1000;
                tr(i).PERFRAME.(field) = tmp + round(tr(i).PERFRAME.(field)(1));
            end
        end
    end
    
    % PERDISPLAY
    n = tr(i).nDisplays;
    fields = fieldnames(tr(i).PERDISPLAY);
    for f = 1 : length(fields)
        field = fields{f};
        if strcmp(class(tr(i).PERDISPLAY.(field)),'double')
            if any(globfind(field,'*TimeStamps')) || any(globfind(field,'*_ms')),
                tr(i).PERDISPLAY.(field) = round(tr(i).PERDISPLAY.(field) * 1000) / 1000;
            end
        end
    end
end

%% Add fields
for i = 1 : nTrials
    dt_ms = diff(tr(i).PERDISPLAY.TimeStamps([1 end]));
    tr(i).MeasuredTotalDuration_s = round(dt_ms) / 1000;
    tr(i).MeasuredTotalDuration_frames = round(dt_ms / oneframe);
    if tr(i).isParallelOut
        tr(i).PERFRAME.ParallelOutDelay_ms = tr(i).PERFRAME.ParallelOutTimeStamps - tr(i).PERFRAME.TimeStamps;
    end
    
    % Matlab Execution Times
    start  = tr(i).PERDISPLAY.AfterDisplayTimeStamps(1:end-1);
    finish = tr(i).PERDISPLAY.BeforeDisplayTimeStamps(2:end);
    cputimes = [NaN, finish - start]; % CPU exec times
    tr(i).PERDISPLAY.MatlabExecutionTimes_ms = cputimes;
    xd = cputimes(~isnan(cputimes));
    if length(xd) >= 2;
        tr(i).MatlabExecutionTime_FirstLoop_ms  = xd(1); % loop 1 (prepares frame 2)
        tr(i).MatlabExecutionTime_SecondLoop_ms = xd(2); % loop 2 (prepares frame 3)
        tr(i).MatlabExecutionTime_Median_ms = median(xd);
        tr(i).MatlabExecutionTime_StdDev_ms = std(xd);
        tr(i).MatlabExecutionTime_Max_ms = max(xd(4:end));
    else
        tr(i).MatlabExecutionTime_FirstLoop_ms  = nan;
        tr(i).MatlabExecutionTime_SecondLoop_ms = nan;
        tr(i).MatlabExecutionTime_Median_ms = nan;
        tr(i).MatlabExecutionTime_StdDev_ms = nan;
        tr(i).MatlabExecutionTime_Max_ms = nan;

    end
    
    % Errors
    tr(i).ERRORS_MissedFrames = nansum(tr(i).PERDISPLAY.MissedFrames);
    if tr(i).isParallelOut
        tr(i).ERRORS_ParallelOutDelayAbove2ms = sum( rmnans(tr(i).PERFRAME.ParallelOutDelay_ms) > 2 );
    end

end

%%  Convert double -> single/int   <Suppressed: Caused to much pb in M6.5>
if 0 % <Suppressed: Caused to much pb in M6.5>
    for i = 1 : nTrials
        % PERFRAME
        n = tr(i).nFrames;
        fields = fieldnames(tr(i).PERFRAME);
        for f = 1 : length(fields)
            field = fields{f};
            if strcmp(class(tr(i).PERFRAME.(field)),'double')
                if any(globfind(field,'*TimeStamps')) || any(globfind(field,'*_ms'))
                    tr(i).PERFRAME.(field) = single(tr(i).PERFRAME.(field));
                end
            end
        end
        
        % PERDISPLAY
        n = tr(i).nDisplays;
        fields = fieldnames(tr(i).PERDISPLAY);
        for f = 1 : length(fields)
            field = fields{f};
            if strcmp(class(tr(i).PERDISPLAY.(field)),'double')
                if any(globfind(field,'*TimeStamps')) || any(globfind(field,'*_ms'))
                    tr(i).PERDISPLAY.(field) = single(tr(i).PERDISPLAY.(field));
                end
            end
        end
        
        % PERDISPLAY.TARGETS
        n = tr(i).nDisplays;
        if ~isempty(tr(i).PERDISPLAY.TARGETS);
            fields = fieldnames(tr(i).PERDISPLAY.TARGETS(1));
            for f = 1 : length(fields)
                field = fields{f};
                for t = 1 : numel(tr(i).PERDISPLAY.TARGETS)
                    tr(i).PERDISPLAY.TARGETS(t).XY = int16(tr(i).PERDISPLAY.TARGETS(t).XY);
                    tr(i).PERDISPLAY.TARGETS(t).WH = int16(tr(i).PERDISPLAY.TARGETS(t).XY);
                    tr(i).PERDISPLAY.TARGETS(t).RGB = single(tr(i).PERDISPLAY.TARGETS(t).RGB);
                end
            end
        end
    end
end

%% Change struct: tr -> tr.PERTRIAL  <!!>
% <TODO: ???>
