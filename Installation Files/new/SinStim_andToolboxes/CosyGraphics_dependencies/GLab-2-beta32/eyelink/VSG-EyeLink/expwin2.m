function expwin2
%EXPWIN2 - Experience window (2d version)


global EXP_NAME SUBJ_NAME BLOCK_No DO_SAVE HANDLE_PATHBOX USE_EYELINK


hExpWin = figure('unit','norm','pos',[0 .57 .4 .4],'name','ExpWin2');

if USE_EYELINK,
	err = Eyelink('Initialize');
	if err ~= 0,
		fprintf('Eyelink initialization error! Check connections, etc.\n');
		close(hExpWin);
		return
	else
		fprintf('Eyelink connection successfully opened.\n');
		Eyelink('Command', 'file_event_filter = MESSAGE');
			% don't write FIX, SACC or BLINK events to .edf file (faster parsing later)
		Eyelink('Command', 'link_sample_data = PUPIL');
			% make sure raw pupil position is available through link (closed-loop applications)
			% APPARENTLY THIS DOES NOT ACTUALLY WORK; HAVE TO MAKE SURE RAW POSITON IS SET ON CONSOLE
		set(hExpWin, 'CloseRequestFcn', 'Eyelink(''Shutdown''); fprintf(''Eyelink closed''); closereq');
			% Eyelink connection will close when this window is closed (Matlab exit OK)
	end
end

% Experience
pd = cd; % --!
cd([matlabroot '\work\vsg\experiences'])
d = dir;
cd(pd)   % --!
d = d(3:end);
c = {};
for i = 1 : length(d)
    if strcmpi(d(i).name(end-1:end),'.m'), 
        c{end+1} = d(i).name(1:end-2);
    end
end
uicontrol('style','text','str','Experience','unit','norm','pos',[.05 .90 .3 .07],...
    'BackgroundColor',[.8 .8 .8],'FontSize',12,'HorizontalAlignment','left');
uicontrol('style','popup','str',c,'unit','norm','pos',[.05 .80 .3 .1],...
    'FontSize',12,'HorizontalAlignment','center',...
    'call','c=get(gcbo,''str''); EXP_NAME=c{get(gcbo,''val'')};');

% Subject
uicontrol('style','text','str','Subject','unit','norm','pos',[.05 .70 .3 .07],...
    'BackgroundColor',[.8 .8 .8],'FontSize',12,'HorizontalAlignment','left');
hSubj = uicontrol('style','edit','unit','norm','pos',[.05 .60 .3 .1],...
    'FontSize',14,'HorizontalAlignment','center',...
    'call','SUBJ_NAME=upper(get(gcbo,''str'')); set(gcbo,''str'',SUBJ_NAME); set(get(gcbo,''userdata''),''enable'',''on'')');

% Save
DO_SAVE = 1;
uicontrol('style','check','str','save :','unit','norm','pos',[.05 .46 .12 .07],...
    'HorizontalAlignment','left','BackgroundColor',[.8 .8 .8],'value',DO_SAVE,...
    'call','DO_SAVE=get(gcbo,''val'');');
HANDLE_PATHBOX = uicontrol('style','edit','str',[matlabroot '\data'],...
    'unit','norm','pos',[.18 .46 .65 .07],'HorizontalAlignment','left');
uicontrol('style','push','str','Browse','unit','norm','pos',[.84 .46 .11 .07],...
    'call','set(HANDLE_PATHBOX,''str'',uigetpath)');

% Block N°
uicontrol('style','text','str','Block No ','unit','norm','pos',[.48 .75 .3 .17],...
    'BackgroundColor',[.8 .8 .8],'FontSize',16,'HorizontalAlignment','right');
BLOCK_No = '001';
hBlockNo = uicontrol('style','edit','str',BLOCK_No,'unit','norm','pos',[.79 .82 .15 .10],...
    'BackgroundColor',[.8 .8 .8],'FontSize',16,'HorizontalAlignment','center',...
    'call','BLOCK_No=get(gcbo,''str'')');

% Trial N°
uicontrol('style','text','str','Trial No ','unit','norm','pos',[.48 .57 .3 .17],...
    'BackgroundColor',[.8 .8 .8],'FontSize',16,'HorizontalAlignment','right');
uicontrol('style','text','str','0','unit','norm','pos',[.79 .57 .1 .17],...
    'BackgroundColor',[.8 .8 .8],'FontSize',16,'HorizontalAlignment','right');

% Push buttons
next_block_str = ['BLOCK_No = [''00'' num2str(str2num(BLOCK_No)+1)];'...
        'BLOCK_No = BLOCK_No(end-2:end);'... % 3 digit string
        'set(get(gcbo,''userdata''),''str'',BLOCK_No);'];
hCal = uicontrol('style','push','str','Calibration','unit','norm','pos',[.05 .25 .4 .15],...
    'BackgroundColor',[.8 .8 .8],'FontSize',14,'HorizontalAlignment','center',...
    'call',['EyelinkFileIO(''open''); calibration2; EyelinkFileIO(''close''); ' next_block_str],...
	'enable','off');
hDo = uicontrol('style','push','str','Do one block','unit','norm','pos',[.55 .25 .4 .15],...
    'BackgroundColor',[.8 .8 .8],'FontSize',16,'HorizontalAlignment','center','enable','off',...
    'call',['disp([char(10) ''Block '' BLOCK_No '':'']); clear(EXP_NAME); EyelinkFileIO(''open''); eval(EXP_NAME); EyelinkFileIO(''close''); ' next_block_str]);
hDAC = uicontrol('style','push','str','High DAC','unit','norm','pos',[.3 .05 .4 .15],...
    'BackgroundColor',[.8 .8 .8],'FontSize',14,'HorizontalAlignment','center',...
    'call','HighDAC');
if USE_EYELINK,
	set(hDAC, 'Enable', 'off');	% don't need this for Eyelink
end

% Store handles needed for callback in objects' UserData
set(hSubj,'userdata',[hCal hDo])
set([hCal hDo],'userdata',hBlockNo)

% prevent user from accidentally plotting over figure
set(hExpWin, 'HandleVisibility', 'callback');

% BlockNo = 0;
