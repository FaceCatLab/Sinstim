function varargout = trials2block(tr)
% TRIAL2BLOCK                      <TODO: write doc>
%    BL = TRIAL2BLOCK(TR)
%
%    [perTrial,perDisplay,perFrame] = TRIAL2BLOCK(TR)
%
%    [perTrial,perDisplay,perFrame,EventsString] = TRIAL2BLOCK(TR)
%
% Example:
%    [pt,pd,pf] = trials2block(gettrials)
%
% Ben, July 2010.

%% # trials
nTrials = numel(tr);

if nTrials == 0
    bl = [];
    return % !!!
end

% %% Remove TARGET.Tag field <compat with version before 2-beta24> <todo: remove that in later versions>
% for i = 2 : nTrials
%     try tr(i).PERDISPLAY.TARGETS = rmfield(tr(i).PERDISPLAY.TARGETS,'Tag'); end %#ok<TRYNC>
% end

%% First trial
perTrial = rmfield(tr(1),{'PERFRAME','PERDISPLAY'});
perDisplay = tr(1).PERDISPLAY;
perFrame   = tr(1).PERFRAME;

% perTrial: Store char strings in a cell array
fields = fieldnames(perTrial);
for f = 1 : length(fields)
    field = fields{f};
    if ischar(perTrial.(field))
        c = cell(nTrials,1);
        c{1} = perTrial.(field);
        perTrial.(field) = c;
    end
end

%% Main loop
for i = 2 : nTrials
    % per trial
    fields = fieldnames(perTrial);
    for f = 1 : length(fields)
        field = fields{f};
        if ischar(tr(i).(field)) % Character string..
            perTrial.(field){i} = tr(i).(field);
        else                     % Other..
            perTrial.(field) = [perTrial.(field); tr(i).(field)];
        end
    end
    
    % PERDISPLAY
    n = tr(i).nDisplays;
    fields = fieldnames(tr(i).PERDISPLAY);
    for f = 1 : length(fields)
        field = fields{f};
        if ~isstruct(tr(i).PERDISPLAY.(field))
            perDisplay.(field) = catarray(perDisplay.(field), tr(i).PERDISPLAY.(field), n, field);
        end
    end
    
    % PERDISPLAY.TARGETS
    n = tr(i).nDisplays;
    if ~isempty(tr(i).PERDISPLAY.TARGETS);
        fields = fieldnames(tr(i).PERDISPLAY.TARGETS(1));
        for f = 1 : length(fields)
            field = fields{f};
            for t = 1 : numel(tr(i).PERDISPLAY.TARGETS)
                perDisplay.TARGETS(t).(field) = catarray(perDisplay.TARGETS(t).(field), tr(i).PERDISPLAY.TARGETS(t).(field), n, field);
            end
        end
    end
    
    % PERFRAME
    n = tr(i).nFrames;
    fields = fieldnames(tr(i).PERFRAME);
    for f = 1 : length(fields)
        field = fields{f};
        if ~isstruct(tr(i).PERFRAME.(field))
            perFrame.(field) = catarray(perFrame.(field), tr(i).PERFRAME.(field), n, field);
        end
    end        

end

%% Move EventsSting out of perTrial
EventsString = perTrial.EventsString;
perTrial = rmfield(perTrial,'EventsString');

%% Output args
switch nargout
    case 1
        bl.PERTRIAL   = perTrial;
        bl.PERDISPLAY = perDisplay;
        bl.PERFRAME   = perFrame;
        bl.EventsString = EventsString;
        varargout{1} = bl;
    case 3
        varargout{1} = perTrial;
        varargout{2} = perDisplay;
        varargout{3} = perFrame;
    case 4
        varargout{1} = perTrial;
        varargout{2} = perDisplay;
        varargout{3} = perFrame;
        varargout{4} = EventsString;
    otherwise
        error('Wrong number of output arguments.')
end

%% %%%%%%%%%%%% SUB-FUNCTION %%%%%%%%%%% %%
function a = catarray(a, b, n, fieldname)
% Concatenates array a and b.
% Horizontal vectors are concatenated horizontally, others arrays are concatenated vertically.

[nr,nc] = size(b);

if nr == 1 && nc == n,  a = [a, b];
elseif nr == n,         a = [a; b];
else dispinfo(mfilename,'warning',['Invalid array in field "' fieldname '".'])
end