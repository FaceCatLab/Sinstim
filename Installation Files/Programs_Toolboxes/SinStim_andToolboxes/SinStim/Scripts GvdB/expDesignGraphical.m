function varargout = expDesignGraphical(varargin)
% EXPDESIGNGRAPHICAL M-file for expDesignGraphical.fig
%      EXPDESIGNGRAPHICAL, by itself, creates a new EXPDESIGNGRAPHICAL or raises the existing
%      singleton*.
%
%      H = EXPDESIGNGRAPHICAL returns the handle to a new EXPDESIGNGRAPHICAL or the handle to
%      the existing singleton*.
%
%      EXPDESIGNGRAPHICAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPDESIGNGRAPHICAL.M with the given input arguments.
%
%      EXPDESIGNGRAPHICAL('Property','Value',...) creates a new EXPDESIGNGRAPHICAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before expDesignGraphical_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to expDesignGraphical_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help expDesignGraphical

% Last Modified by GUIDE v2.5 01-Dec-2011 10:01:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @expDesignGraphical_OpeningFcn, ...
    'gui_OutputFcn',  @expDesignGraphical_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before expDesignGraphical is made visible.
function expDesignGraphical_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to expDesignGraphical (see VARARGIN)

% Choose default command line output for expDesignGraphical
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes expDesignGraphical wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = expDesignGraphical_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function updateExpDesignGui(hObject, eventdata, handles)
trialList = get(handles.uitable1, 'Data');
% if numel(trialList{1}) == 0
set(handles.uitable1, 'Data', {});
% end
% if numel(get(handles.text2, 'String')) == 0 && numel(get(handles.text1, 'String')) >0
set(handles.text2, 'String', [char(get(handles.text1, 'String')),'\stimuli' ]);
% end
% if numel(get(handles.text6, 'String')) == 0 && numel(get(handles.text1, 'String')) >0
set(handles.text6, 'String', [char(get(handles.text1, 'String')),'\parameters' ]);
% end
% stimulus list
% if numel(get(handles.text2, 'String')) > 0
stimPath=get(handles.text2, 'String');
files=dir(stimPath);   %explore the directory specified
str={files.name}; %make a cell that contain the names that are in the directory
set(handles.listbox1, 'String', char(str(3:numel(str))));
% end

% param list
if numel(get(handles.text6, 'String')) > 0
    paramPath=get(handles.text6, 'String');
    files=dir(paramPath);   %explore the directory specified
    str={files.name}; %make a cell that contain the parameter files that are in the directory
    str2 = {};
    for lineNr = 1:numel(str)
        try
            fileNm = str{lineNr};
            if strcmp(fileNm(1:7), 'sinstim') && strcmp(fileNm(numel(fileNm)-1:numel(fileNm)), '.m')
                str2 = [str2; fileNm];
            end
        end
    end
    set(handles.listbox2, 'String', char(str2));
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
experimentPath = uigetdir ('C:\', 'Where is your experiment folder?');  % define the path of the files to use
set(handles.text1, 'String', char(experimentPath));
updateExpDesignGui(hObject, eventdata, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% stimPath=uigetdir (get(handles.text1, 'String'), 'Where are your stimulus folders?');  % define the path of the files to use
% set(handles.text2, 'String', char(stimPath));
% updateExpDesignGui(hObject, eventdata, handles);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% stimPath=uigetdir (get(handles.text1, 'String'), 'Where are your parameter files?');  % define the path of the files to use
% set(handles.text6, 'String', char(stimPath));
% updateExpDesignGui(hObject, eventdata, handles);


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% change pop-up menu of param files
if numel(get(handles.listbox2, 'Value')) > 0
    %     get(handles.listbox2, 'Value')
    entries = get(handles.listbox2, 'String');
    set(handles.text10, 'String', entries(get(handles.listbox2, 'Value'), :));
end

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton2, 'Value', 0);
% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton1, 'Value', 0);
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = get(handles.text1, 'String');
fileNm = get(handles.edit2, 'String');
extensionMatlab = '.mat';
fileName = [char(path), '\', char(fileNm), extensionMatlab];
trialList = get(handles.uitable1, 'Data');
tosort = cell2mat(trialList(:,3));
[sortedCol, newInd] = sort(tosort);
trialList = trialList(newInd, :);
if get(handles.radiobutton3, 'Value')
    randomizeOrder = 'Yes';
else
    randomizeOrder = 'No';
end
save(fileName, 'trialList', 'randomizeOrder');
warndlg('your file has been successfully saved!');


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trialList = get(handles.uitable1, 'Data');
if get(handles.popupmenu1,'Value') < 4
    tosort = trialList(:,get(handles.popupmenu1,'Value'));
else
    tosort = {randperm(numel(trialList(:,1)))};
end
try
    if isnumeric(cell2mat(tosort))
        tosort = cell2mat(tosort);
    end
end
[sortedCol, newInd] = sort(tosort);
trialList = trialList(newInd, :);
set(handles.uitable1, 'Data', trialList);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% create a cell with all values for stim folder, param file and trial
% number
allStim = get(handles.listbox1, 'String');
stimuli = allStim(get(handles.listbox1, 'Value'),:);
allParam = get(handles.listbox2, 'String');
parameters = allParam(get(handles.listbox2, 'Value'),:);

trialList = get(handles.uitable1, 'Data');

for paramNr = 1:size(parameters, 1)
    % param = cellstr(allParam(get(handles.listbox2, 'Value'),:));
    param = cellstr(strtrim(parameters(paramNr,:)));
    
    for stimFolderNr = 1:size(stimuli, 1)
        stim = cellstr(strtrim(stimuli(stimFolderNr,:)));
        line = [stim, param, 0];
        trialList = [trialList; line];
    end
end
set(handles.uitable1, 'Data', trialList);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles) % use current order
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trialList = get(handles.uitable1, 'Data');
trialList(:,3) = num2cell(1:numel(trialList(:,3)));
set(handles.uitable1, 'Data', trialList);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)  % question mark
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text11, 'Visible', 'on');
set(handles.pushbutton8, 'Visible', 'on');

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)  % ok for information
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text11, 'Visible', 'off');
set(handles.pushbutton8, 'Visible', 'off');



% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trialList = get(handles.uitable1, 'Data');
newtrialList = trialList;
for rep = 1:str2double(get(handles.edit1,'String'))
    if get(handles.popupmenu2,'Value') == 2
        tosort = randperm(numel(trialList(:,1)));
        [sortedCol, newInd] = sort(tosort);
        trialList = trialList(newInd, :);
        set(handles.uitable1, 'Data', trialList);
        trialList = get(handles.uitable1, 'Data');
    elseif get(handles.popupmenu2,'Value') == 3
        trialList = trialList(numel(trialList(:,1)):-1:1, :);
        set(handles.uitable1, 'Data', trialList);
        trialList = get(handles.uitable1, 'Data');
    end
    newtrialList = [newtrialList; trialList];
end
set(handles.uitable1, 'Data', newtrialList);
pushbutton6_Callback(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
trialList = get(handles.uitable1, 'Data');
selectedRows = zeros(size(trialList'));
for cellSelected = 1:size(eventdata.Indices,1)
    selectedRows(eventdata.Indices(cellSelected,2), eventdata.Indices(cellSelected,1)) =1;
end
selectedRows = max(selectedRows);
selRows = [];
for row = 1:numel(selectedRows)
    if selectedRows(row)
        selRows = [selRows, row];
    end
end
set(handles.uitable1,'UserData', selRows);


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function rClickTable_Callback(hObject, eventdata, handles)
% hObject    handle to rClickTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RandOrderSelection_Callback(hObject, eventdata, handles)
% hObject    handle to RandOrderSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trialList = get(handles.uitable1, 'Data');
selectedRows2 = get(handles.uitable1,'UserData');
selectedRows = zeros(1,size(trialList,1));
selectedRows(1,selectedRows2) = 1;
sortedPart = {};
for row = 1:size(trialList,1)
    if selectedRows(1,row)
        sortedPart = [sortedPart; trialList(row,:)];
    end
end
tosort = randperm(numel(sortedPart(:,1)));
[sortedCol, newInd] = sort(tosort);
sortedPart = sortedPart(newInd, :);

newTrialList = {};
sortedPartInd = 1;
for row = 1:size(trialList,1)
    if selectedRows(1,row)
        newTrialList = [newTrialList;sortedPart(sortedPartInd,:)];
        sortedPartInd = sortedPartInd +1;
    else
        newTrialList = [newTrialList;trialList(row,:)];
    end
end
set(handles.uitable1, 'Data', newTrialList);

% --------------------------------------------------------------------
function delSelTr_Callback(hObject, eventdata, handles)
% hObject    handle to delSelTr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectedRows = get(handles.uitable1,'UserData');
trialList = get(handles.uitable1, 'Data');
trialList(selectedRows,:) = [];
set(handles.uitable1, 'Data', trialList);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
