function savetrials4eyeview(gdffilename,varargin)
% SAVETRIALS4EYEVIEW  Export trials data to Eyeview.
%    SAVETRIALS4EYEVIEW(FilePrefix)  saves automatically recorded trials data (see STARTTRIAL 
%    and STOPTRIAL) in a file readable by Eyeview 0.25 or later. 
%    For safety all variables in the caller function space will also be saved "as it".
%
%    SAVETRIALS4EYEVIEW('GUI')  opens a dialog box to let the user put a file name.
%
%    SAVETRIALS4EYEVIEW(...,'VARNAME1.field_name1',value1,'VARNAME2.field_name2',value2,...)  <TODO!!!>
%    stores values in fields of Eyeview's variables. 'VARNAME' can be 'FILE', 'BLOCKS' or 'TRIALS'.
%    'field_name' is the name of the field you want to have in Eyeview.
%
%    SAVETRIALS4EYEVIEW(...,'-open',1)  opens saved trials in Eyeview.
%    SAVETRIALS4EYEVIEW(...,'-open',0)  is the same than the default.
%
% Example:
%    savetrials4eyeview('gui') 

% <TODO: what about multiple targets ??? Currently takes only TARGETS(1)>

%% Global Vars
cosyglobal  % CosyGraphics vars
global USER % Eyeview var

%% Input Args
% File name:
if nargin < 1
    error('''FilePrefix'' argument is missing.')
end
if strcmpi(gdffilename,'GUI')
    if isopen('display')
        beep
        msg = {'CosyGraphics display was not stopped!'; ...
            [mfilename ' was to stop CosyGraphics to let you see the dialog box.']; ...
            ['Please move ' mfilename ' after stopcosy in your script.'] };
        warning(msg);
        warndlg(msg);
        stopcosy;
    end
    [gdffilename,pathname] = uiputfile('.gdf');
    gdffilename = fullfile(pathname,gdffilename);
end
if isazero(gdffilename) %% uigetfile returns 0 when user clicks "Cancel".
    return  % <=== RETURN === !!!
end

% Option
doOpenEyeview = 0;
if any(isoption(varargin)) % <review code if onother otion implemented>
    f = findoptions(varargin);
    if strcmpi(varargin{f},'-open')
        doOpenEyeview = varargin{f+1};
        varargin(f:f+1) = [];
    else error('Unknown option.')
    end
end

% Experiment specific variables: <TODO!!!>
UserDef.VarNames   = varargin(1:2:end-1);
UserDef.FieldNames = varargin(2:2:end);

%% FILE
FILE.Tsystem = 'CosyGraphics';
FILE.Tsystem_version = vnum2vstr(cosyversion);
FILE.Esystem = 'Eyelink';
FILE.Tfrq = getscreenfreq;
FILE.Tresolution = getscreenres; % just in case...

%% BLOCKS
% Fields of the "BLOCKS" structure (BLOCKS.*) have to be stored one by one in Eyeview's BLOCKS(b).*
BLOCKS.protocol_file = COSY_GENERAL.UserScript;
d = datevec(date);
BLOCKS.acquisition_date = d(3:-1:1);

% Offset & gain:
BLOCKS.scale_offset = -getscreenres/2; % to convert from graphics co-ord used by EyeLink to cartesian co-ord.
BLOCKS.scale_gain = [1 -1] / deg2pix(1); % to convert from pixels to degrees and to invert Y axis.

%% Get trials data
CosyGraphicsTrials = gettrials;

%% CosyGraphicsTrials -> TRIALS
for i = 1 : length(CosyGraphicsTrials)
    t0 = CosyGraphicsTrials(i).PERDISPLAY.TimeStamps(1);
    TRIALS(i).Tt = CosyGraphicsTrials(i).PERDISPLAY.TimeStamps - t0;
    TRIALS(i).Et = CosyGraphicsTrials(i).PERDISPLAY.TimeStamps - t0;
    TRIALS(i).rTh = pix2deg(CosyGraphicsTrials(i).PERDISPLAY.TARGETS(1).XY(:,1));
    TRIALS(i).rTv = pix2deg(CosyGraphicsTrials(i).PERDISPLAY.TARGETS(1).XY(:,2));
    for t = 2 : length(CosyGraphicsTrials(i).TargetNames)
        if strcmpi(CosyGraphicsTrials(i).TargetNames{t},'eye') % online eye..
            TRIALS(i).rOh = pix2deg(CosyGraphicsTrials(i).PERDISPLAY.TARGETS(t).XY(:,1)); % store it in Oh, Ov
            TRIALS(i).rOv = pix2deg(CosyGraphicsTrials(i).PERDISPLAY.TARGETS(t).XY(:,1));
        else
            TRIALS(i).(['rT' int2str(t) 'h']) = pix2deg(CosyGraphicsTrials(i).PERDISPLAY.TARGETS(t).XY(:,1));
            TRIALS(i).(['rT' int2str(t) 'v']) = pix2deg(CosyGraphicsTrials(i).PERDISPLAY.TARGETS(t).XY(:,2));
        end
    end
    
    % Eyeview events:
    T = CosyGraphicsTrials(i).PERDISPLAY.Tag;
    % trial
    i0 = 1;
    i1 = size(T,1);
    TRIALS(i).trial = subEvEventMatrix(i0, i1, TRIALS(i).Tt);
    % fix1, fix2:
    f = strmatch('fix',T);
    [g0,g1] = findgroup(f,1,2);
    i0 = f(g0);
    i1 = f(g1);
    for e = 1 : length(i0)
        event = sprintf('fix%d',e);
        TRIALS(i).(event) = subEvEventMatrix(i0(e), i1(e), TRIALS(i).Tt);
    end
    % gap:
    f = strmatch('gap',T);
    [g0,g1] = findgroup(f,1,2);
    i0 = f(g0);
    i1 = f(g1);
    for e = 1 : length(i0)
        if e == 1, event = 'gap'; % only "gap" has currently be used in EV
        else       event = sprintf('gap%d',e); % if there is more than one, call them "gap2", etc.
        end
        TRIALS(i).(event) = subEvEventMatrix(i0(e), i1(e), TRIALS(i).Tt);
    end
    % rampe:
    f = strmatch('rampe',T);
    [g0,g1] = findgroup(f,1,2);
    i0 = f(g0);
    i1 = f(g1);
    for e = 1 : length(i0)
        if e == 1, event = 'rampe'; % only "rampe" has currently be used in EV
        else       event = sprintf('rampe%d',e); % if there is more than one, call them "rampe2", etc.
        end
        TRIALS(i).(event) = subEvEventMatrix(i0(e), i1(e), TRIALS(i).Tt);
    end
    
end

%% Add date suffix and .GDF (CosyGraphics Data File) extension to file name
% Remove .gdf extension if already there
if length(gdffilename) > 4 && strcmpi(gdffilename(end-3:end),'.gdf')
    gdffilename(end-3:end) = [];
end
% Add <datesuffix>.gdf
gdffilename = [gdffilename datesuffix '.gdf'];
    
%% Save GDF file
if ~any(gdffilename == filesep) 
    gdffilename = fullfile(pwd,gdffilename); % add path to name
end
dispinfo(mfilename,'info',['Saving CosyGraphics data to "' gdffilename '"...'])

% 1) Save all experiment variables into .gdf file, for safety:
% <Bug: "Error using ==> psychhid", don't understand>
% cmd = ['save6 -mat ' gdffilename ';'];
% evalin('caller',cmd);
% <Let's try this:>
v = version;
if v(1) <= '6', cmd = ['save -mat ' gdffilename ';'];
else            cmd = ['save -mat -v6 ' gdffilename ';'];
end
evalin('caller',cmd);
% 2) Append 'FILE', 'TRIALS' variables in the same file
save6(gdffilename,'-mat','-append','FILE','BLOCKS','TRIALS');

%% Save EDF file
% gdffilename (full name) -> gdffilename (relative name) + pathname
f = find(ismember(gdffilename,'/\'));
if isempty(f)
    pathname = pwd;
else
    pathname = gdffilename(1:f(end));
    gdffilename = gdffilename(f(end)+1:end);
end

% gdf-file -> edf-file
edffilename = gdffilename;
edffilename(end-2) = 'e';

% Get eyelink EDF-file
source = fullfile(cosydir('tmp'),'active.edf');
if isfieldtrue(COSY_EYELINK,'isFileTransfered')
    dest = fullfile(pathname,edffilename);
    dispinfo(mfilename,'info',['Saving EyeLink data to "' dest '"...']);
    cp(source,dest);
    rm([dest(1:end-3) 'asc']); % remove old .asc file if there is one.
else
    msg = sprintf('No EyeLink data file. Cannot find "%s"',source)
    dispinfo(mfilename,'warning',msg)
    warning(msg)
end

dispinfo(mfilename,'info','Done.')

%% Open trials in EYEVIEW
if doOpenEyeview
    v = version;
    if v(1) >= '7'  % MATLAB 7
        if exist('starteyeview') == 2
            % Open Eyeview
            %         if ~isfilledfield(USER,'user')
            %             dispinfo(mfilename,'info','Initializing EYEVIEW for "glab" user...')
            %             starteyeview glab;
            %         end
            starteyeview('glab'); % <nb: "starteyeview glab;" bugs when EV not installed.>
            evMain(edffilename,pathname)
        else
            beep
            warning('Cannot find Eyeview.')
        end
        
    else                % MATLAB 6
        dispinfo(mfilename,'error','EYEVIEW is not supported on MATLAB 6.')
%         warning('EYEVIEW is not supported on MATLAB 6.')
        
    end
    
end


%% %%%%%%%%%%%%% SUB_FUNCTION %%%%%%%%%%%%% %%
function M = subEvEventMatrix(i0,i1,times)
% Returns a std Eyeview event matrix 

%     col1: times            col2: indexes
M = [ times(i0)             i0    ;...
      times(i1)             i1    ;...
      times(i1)-times(i0)   i1-i0 ];