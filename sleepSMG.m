function varargout = sleepSMG(varargin)
%% Stephanie Greer and Jared Saletin
% Walker Lab, UC Berekeley 2011
%
% SLEEPSMG M-file for sleepSMG.fig
%      SLEEPSMG, by itself, creates a new SLEEPSMG or raises the existing
%      singleton*.
%
%      H = SLEEPSMG returns the handle to a new SLEEPSMG or the handle to
%      the existing singleton*.
%
%      SLEEPSMG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLEEPSMG.M with the given input arguments.
%
%      SLEEPSMG('Property','Value',...) creates a new SLEEPSMG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sleepSMG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sleepSMG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sleepSMG

% Last Modified by GUIDE v2.5 11-Jul-2012 23:34:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sleepSMG_OpeningFcn, ...
                   'gui_OutputFcn',  @sleepSMG_OutputFcn, ...
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


% --- Executes just before sleepSMG is made visible.
function sleepSMG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sleepSMG (see VARARGIN)
sleepPath = which('sleepSMG');
addpath(genpath(fileparts(sleepPath)));

% Set Montage List based on montage directory
montageNames = dir(fullfile(fileparts(sleepPath), 'montages'));
montages = {'sleep_Montage'};
for i = 1:length(montageNames)
    if(strfind(montageNames(i).name, '_Montage.m'))
        montages{length(montages) + 1} = montageNames(i).name(1:(end - 2));
    end
end
set(handles.plotSleepIN, 'String', montages)

% Set Notes list based on notes directory
noteNames = dir(fullfile(fileparts(sleepPath), 'noteReader'));
notes = {'Notes'};
for i = 1:length(noteNames)
    if(strfind(noteNames(i).name, '_LoadNotes.m'))
        notes{length(notes) + 1} = noteNames(i).name(1:(end - 2));
    end
end
set(handles.twinNotes, 'String', notes)

% Choose default command line output for sleepSMG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sleepSMG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sleepSMG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% Key Board short cuts for scoring + buttons

function figure1_KeyPressFcn(hObject, eventdata, handles)
cStr = get(hObject, 'CurrentCharacter');
c = str2num(cStr);
if(~isempty(c) && c >= 0 && c <=6)
    handles = updateStage(handles, c);
    guidata(hObject, handles);
    arrowRightB_Callback(handles.arrowRightB, [], handles);
elseif(strcmp(cStr, '.'))
    handles = updateStage(handles, 7);
    guidata(hObject, handles);
    arrowRightB_Callback(handles.arrowRightB, [], handles);
elseif(c == 7)
    arrowLeftB_Callback(handles.arrowLeftB, [], handles);
elseif(c == 9)
    arrowRightB_Callback(handles.arrowRightB, [], handles);
end

% --- Executes on button press in wakeB.
function wakeB_Callback(hObject, eventdata, handles)
% hObject    handle to wakeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = updateStage(handles, 0);
guidata(hObject, handles);
arrowRightB_Callback(handles.arrowRightB, [], handles);

% --- Executes on button press in stage1B.
function stage1B_Callback(hObject, eventdata, handles)
% hObject    handle to stage1B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = updateStage(handles, 1);
guidata(hObject, handles);
arrowRightB_Callback(handles.arrowRightB, [], handles);

% --- Executes on button press in stage2B.
function stage2B_Callback(hObject, eventdata, handles)
% hObject    handle to stage2B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = updateStage(handles, 2);
guidata(hObject, handles);
arrowRightB_Callback(handles.arrowRightB, [], handles);

% --- Executes on button press in stage3B.
function stage3B_Callback(hObject, eventdata, handles)
% hObject    handle to stage3B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = updateStage(handles, 3);
guidata(hObject, handles);
arrowRightB_Callback(handles.arrowRightB, [], handles);

% --- Executes on button press in stage4B.
function stage4B_Callback(hObject, eventdata, handles)
% hObject    handle to stage4B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = updateStage(handles, 4);
guidata(hObject, handles);
arrowRightB_Callback(handles.arrowRightB, [], handles);

% --- Executes on button press in remB.
function remB_Callback(hObject, eventdata, handles)
% hObject    handle to remB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = updateStage(handles, 5);
guidata(hObject, handles);
arrowRightB_Callback(handles.arrowRightB, [], handles);

% --- Executes on button press in mtB.
function mtB_Callback(hObject, eventdata, handles)
% hObject    handle to mtB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = updateStage(handles, 6);
guidata(hObject, handles);
arrowRightB_Callback(handles.arrowRightB, [], handles);

%% Navigation Buttons
    
function axes2_ButtonDownFcn(hObject, eventdata, handles)
pt = get(hObject, 'currentPoint');

winSize = str2num(get(handles.winIN, 'String'));
srate = handles.EEG.srate;
ptX = floor(pt(1)*(60/winSize))*winSize*srate;
jumpto(handles, ptX)

function jumpto(handles, ptX)
winSize = str2num(get(handles.winIN, 'String'));
srate = handles.EEG.srate;

newX = [ptX+1, ptX + winSize*srate];
range = newX(1):newX(2);
plotSleepData(handles, range)
updateStage(handles, []);


% --- Executes on button press in arrowLeftB.
function arrowLeftB_Callback(hObject, eventdata, handles)
% hObject    handle to arrowLeftB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winSize = str2num(get(handles.winIN, 'String'));
srate = handles.EEG.srate;
curX = xlim(handles.axes1);
newX = [curX(1) - winSize*srate, curX(1) - 1];

range = newX(1):newX(2);

plotSleepData(handles, range)
updateStage(handles, []);

% --- Executes on button press in arrowRightB.
function arrowRightB_Callback(hObject, eventdata, handles)
% hObject    handle to arrowRightB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winSize = str2num(get(handles.winIN, 'String'));
srate = handles.EEG.srate;
curX = xlim(handles.axes1);
newX = [curX(2) + 1, curX(2) + winSize*srate];
range = newX(1):newX(2);

plotSleepData(handles, range)
updateStage(handles, []);

%% 


function fileIN_Callback(hObject, eventdata, handles)
% hObject    handle to fileIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileIN as text
%        str2double(get(hObject,'String')) returns contents of fileIN as a
%        double

% --- Executes during object creation, after setting all properties.
function fileIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Load
% --- Executes on button press in loadB.
function loadB_Callback(hObject, eventdata, handles)
% hObject    handle to loadB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get EEG data
set(handles.sleepSetPan, 'Visible', 'off')
filename = get(handles.fileIN, 'String');

if(strcmp(filename((end - 3):end), '.mat'))
    load(filename);
elseif(strcmp(filename((end - 3):end), '.edf') || strcmp(filename((end - 3):end), '.EDF'))
    EEG = pop_biosig(filename);
elseif(strcmp(filename((end - 3):end), '.set'))
   EEG = pop_loadset(filename); 
else
    display('CAN NOT OPEN FILE: don''t recognise file ending')
end

handles.EEG = EEG;

%look for stage data
filename = get(handles.stageFileIN, 'String');
if(exist(filename))
    stageData = loadStaging(handles, filename);
else
    stageData = [];
    stageData.srate = EEG.srate;
end

if(strcmp(get(handles.twinNotesS, 'Enable'), 'on'))
    
    if(exist(get(handles.twinNotesS, 'String')))
        file = get(handles.twinNotesS, 'String');
        
        noteFCN = get(handles.twinNotes, 'String');
        boxInd = get(handles.twinNotes, 'Value');
        eval(['stageData = ', noteFCN{boxInd}, '(stageData, file);']);
        
        stageData = loadStaging(handles, stageData);
    else
        fprinf('Can''t use twin notes file because it doesn''t exist')
    end
end

set(handles.sleepSetPan, 'Visible', 'on')
handles.stageData = stageData;
guidata(hObject, handles)


% --- Executes on button press in startB.
function startB_Callback(hObject, eventdata, handles)
% hObject    handle to startB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.setupPan, 'Visible', 'off')
set(handles.sleepSetPan, 'Visible', 'off')
handles.hideChans = {};
handles.scaleChans = {'C3-A2'};
handles.curScale = 100;
handles.showComp = 0;
guidata(hObject, handles)

handles = initStaging(handles);
guidata(hObject, handles);
runPlot(handles)
updateStage(handles, []);



function stageData = loadStaging(handles, stageFile)
if(~isstruct(stageFile))
    load(stageFile)
else
    stageData = stageFile;
end
if(isfield(stageData, 'win'))
    set(handles.winIN, 'String', num2str(stageData.win))
    set(handles.winIN, 'Enable', 'off')
end
if(isfield(stageData, 'lightsON'))
    set(handles.lightsonIN, 'String', datestr(stageData.lightsON, 'HHMMSS.FFF'))
end
if(isfield(stageData, 'lightsOFF'))
    set(handles.lightsoffIN, 'String', datestr(stageData.lightsOFF, 'HHMMSS.FFF'))
end
if(isfield(stageData, 'recStart'))
    set(handles.recStartIN, 'String', datestr(stageData.recStart, 'HHMMSS.FFF'))
end
if(isfield(stageData, 'Notes'))
    set(handles.notesIN, 'String', stageData.Notes)
end


function runPlot(handles)
winSize = str2num(get(handles.winIN, 'String'));
srate = handles.EEG.srate;

range = 1:(winSize*srate);
plotSleepData(handles, range)


function handles = initStaging(handles)
winSize = str2num(get(handles.winIN, 'String'));
srate = handles.EEG.srate;

%set stage info to user input
handles.stageData.win = str2num(get(handles.winIN, 'String'));

handles.stageData.recStart = datenum(get(handles.recStartIN, 'String'), 'HHMMSS.FFF');
handles.stageData.lightsON = datenum(get(handles.lightsonIN, 'String'), 'HHMMSS.FFF');
%Add a day to the time if it looks like lights on happened before the
%record start.
if(~(handles.stageData.recStart < handles.stageData.lightsON))
    handles.stageData.lightsON = handles.stageData.lightsON + 1;
end
handles.stageData.lightsOFF = datenum(get(handles.lightsoffIN, 'String'), 'HHMMSS.FFF');
%Add a day to the time if it looks like lights on happened before the
%record start.
if(~(handles.stageData.recStart < handles.stageData.lightsOFF))
    handles.stageData.lightsOFF = handles.stageData.lightsOFF + 1;
end

handles.stageData.srate = srate;

if(~isfield(handles.stageData, 'stages'))
    handles.stageData.stages = ones(ceil(size(handles.EEG.data, 2)/(winSize*srate)), 1)*7;
    handles.stageData.onsets = zeros(ceil(size(handles.EEG.data, 2)/(winSize*srate)), 1);
    handles.stagePlot = zeros(ceil(size(handles.EEG.data, 2)/(winSize*srate)), 1);
else
    
    handles.stagePlot = zeros(size(handles.stageData.stages, 1), 1);
    for i = 1:size(handles.stageData.stages, 1)
        stageCode = handles.stageData.stages(i, 1);
    end
end
handles.stageData.stageTime = (0:(size(handles.stageData.stages, 1) - 1))./(60/winSize);

if(isfield(handles, 'compStage'))
    tmp = ones(size(handles.stageData.stages))*7;
    tmp(1:length(handles.compStage)) = handles.compStage;
    handles.compStage = tmp;
end


function handles = updateStage(handles, stageCode)
winSize = handles.stageData.win;
srate = handles.stageData.srate;

curWin = xlim(handles.axes1);
ind = floor(curWin(2)/(winSize*srate));

rstart = handles.stageData.recStart + (floor(curWin(1)/srate)/86400);
set(handles.timeS, 'String', sprintf('Time: %s Epoch: %d', datestr(rstart, 'HH:MM:SS'), ind));

onT = etime(datevec(handles.stageData.lightsON), datevec(handles.stageData.recStart))/60;
offT = etime(datevec(handles.stageData.lightsOFF), datevec(handles.stageData.recStart))/60;

if(~isempty(stageCode))
    handles.stageData.stages(ind, 1) = stageCode;
    handles.stageData.onsets(ind, 1) = curWin(1);
else
    stageCode = handles.stageData.stages(ind, 1);
    %stageCodeC = handles.stageData.stages(ind, 1);
end
stageCodeC = -1;

hold(handles.axes2, 'off')
curT = handles.stageData.stageTime(ind);
plot(handles.axes2, [curT, curT], [0, 7], 'k');
hold(handles.axes2, 'on')
plot(handles.axes2, [onT, onT], [0, 7], 'r', 'LineWidth', 2);
plot(handles.axes2, [offT, offT], [0, 7], 'g', 'LineWidth', 2);

plotmap = [7 4 3 2 1 5 6 0];
stageColors = [0 0 0; 102 255 255; 0 158 225; 102 102 255; 128 0 255; 255 0 0; 100 100 100; 0 0 0]./255;
stageNames = {'wake'; 'stage1'; 'stage2'; 'stage3'; 'stage4'; 'rem'; 'mt'};

for i = 0:7;
    curInds = find(handles.stageData.stages == i);
    plot(handles.axes2, handles.stageData.stageTime(curInds), ones(length(curInds), 1)*plotmap(i + 1), '.', 'MarkerSize', 20, 'Color', stageColors(i+1, :));
    if(isfield(handles, 'compStage') && handles.showComp)
        compInds = find(handles.compStage == i & handles.stageData.stages ~= 7);
        plot(handles.axes2, handles.stageData.stageTime(compInds), ones(length(compInds), 1)*plotmap(i + 1), 'o', 'MarkerSize', 7, 'Color', stageColors(i+1, :)*.5);
        stageCodeC = handles.compStage(ind, 1);
    end
    connectData(curInds) = plotmap(i + 1);
    if(i < 7)
        b = eval(['handles.', stageNames{i + 1}, 'B']);
        curX = xlim(handles.axes2);
        if(i == stageCode)
            set(b, 'BackgroundColor', stageColors(i + 1, :));
            plot(handles.axes2, 1, plotmap(i + 1), '<', 'Color', stageColors(i + 1, :), 'MarkerSize', 7, 'LineWidth', 3)
        else
            set(b, 'BackgroundColor', [1 1 1]);
        end
        if(i == stageCodeC && (stageCode < 7) && handles.showComp)
            %set(b, 'BackgroundColor', stageColors(i + 1, :)*.5);
            plot(handles.axes2, curX(2)/100, plotmap(i + 1), '<', 'Color', stageColors(i + 1, :), 'MarkerSize', 7, 'LineWidth', 3)
        end 
    end
end

plot(handles.axes2, handles.stageData.stageTime, connectData, 'k')
set(handles.axes2, 'Xlim', handles.stageData.stageTime([1, end]), 'Ylim', [0, 7], 'YTick', 0:7, 'YTickLabel', {'None'; 'Stage4'; 'Stage3'; 'Stage2'; 'Stage1'; 'REM'; 'TW'; 'Wake'})
set(handles.axes2, 'ButtonDownFcn', 'sleepSMG(''axes2_ButtonDownFcn'',gcbo,[],guidata(gcbo))')
guidata(handles.axes2, handles)


handles.stageData.Notes = get(handles.notesIN, 'String');
stageData = handles.stageData;
save(get(handles.stageFileIN, 'String'), 'stageData');



function stageFileIN_Callback(hObject, eventdata, handles)
% hObject    handle to stageFileIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stageFileIN as text
%        str2double(get(hObject,'String')) returns contents of stageFileIN as a double


% --- Executes during object creation, after setting all properties.
function stageFileIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stageFileIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% record info text inputs

function recStartIN_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function recStartIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recStartIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function lightsonIN_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function lightsonIN_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lightsoffIN_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.

function lightsoffIN_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function winIN_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function winIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to winIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% entering Notes


function notesIN_Callback(hObject, eventdata, handles)
% hObject    handle to notesIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notesIN as text
%        str2double(get(hObject,'String')) returns contents of notesIN as a double


% --- Executes during object creation, after setting all properties.
function notesIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notesIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in closeNotesB.
function closeNotesB_Callback(hObject, eventdata, handles)
% hObject    handle to closeNotesB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.notePan, 'Visible', 'off')
handles.stageData.Notes = get(handles.notesIN, 'String');

if(length(fields(handles.stageData)) >= 9)
    stageData = handles.stageData;
    save(get(handles.stageFileIN, 'String'), 'stageData');
end


%% Marking cursur

function txt = cursorInfoUpdate(empt, cursorData)
    chanScale = str2double(parseTag(get(cursorData.Target, 'Tag'), 'scale'));
    amp =  cursorData.Position(2) - chanScale;
    timeP =  cursorData.Position(1)/400;
    if(isnan(amp))
        txt = sprintf(get(cursorData.Target, 'Tag'));
    else
        txt = sprintf('Amp: %.1f\nT: %.3f', amp*-1, timeP);
    end

function markStr_Callback(hObject, eventdata, handles)
% hObject    handle to markStr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of markStr as text
%        str2double(get(hObject,'String')) returns contents of markStr as a double
%handles.cursor = datacursormode(gcf);



% --- Executes during object creation, after setting all properties.
function markStr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to markStr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setMark.
function setMark_Callback(hObject, eventdata, handles)
% hObject    handle to setMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cursorData = getCursorInfo(handles.cursor);
label = get(handles.markStr, 'String');
cursTag = str2double(parseTag(get(cursorData.Target, 'Tag'), 'scale'));


if(~isnan(cursTag))
    outData = [cursorData.Position(1), ...
        ceil(cursorData.Position(1)/handles.stageData.srate/handles.stageData.win), ...
        (cursorData.Position(2) - cursTag)*-1];

    if(isfield(handles.stageData, 'events'))
        if(isfield(handles.stageData.events, label))
            eval(['cur = handles.stageData.events.', label, ';']);
            cur = [cur; outData];
            eval(['handles.stageData.events.', label, '=cur;'])
        else
            eval(['handles.stageData.events.', label, '=outData;'])
        end
    else
        eval(['handles.stageData.events.', label, '=outData;'])
    end
    guidata(hObject, handles)
    if(length(fields(handles.stageData)) >= 9)
        stageData = handles.stageData;
        save(get(handles.stageFileIN, 'String'), 'stageData');
    end
    
    curX = xlim(handles.axes1);
    range = curX(1):curX(2);
    plotSleepData(handles, range);
end


% --- Executes on button press in delMark.
function delMark_Callback(hObject, eventdata, handles)
% hObject    handle to delMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cursorData = getCursorInfo(handles.cursor);
label = get(cursorData.Target, 'Tag');

if(isfield(handles.stageData.events, label))
    newData = eval(['handles.stageData.events.', label, ';']);
    newData(newData(:, 1) == cursorData.Position(1), :) = [];

    eval(['handles.stageData.events.', label, '= newData;']);

    guidata(hObject, handles)
    if(length(fields(handles.stageData)) >= 9)
        stageData = handles.stageData;
        save(get(handles.stageFileIN, 'String'), 'stageData');
    end

    curX = xlim(handles.axes1);
    range = curX(1):curX(2);
    plotSleepData(handles, range);
end

% --- Executes on button press in slopeB.
function slopeB_Callback(hObject, eventdata, handles)
% hObject    handle to slopeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cursorData = getCursorInfo(handles.cursor);
chan = str2double(parseTag(get(cursorData.Target, 'Tag'), 'chan'));
midPt = cursorData.Position(1);

slopeData = handles.EEG.data(chan, (midPt - 100):(midPt + 100));
xData = ((midPt - 100):(midPt + 100))/handles.EEG.srate;
slp = polyfit(xData', slopeData',1);

set(handles.optText, 'String', sprintf('%.2f', slp(1)))

%% Notes

function twinNotes_Callback(hObject, eventdata, handles)
items = get(hObject, 'String');
val = get(hObject, 'Value');

if(strcmp(items{val}, 'Notes'))
    set(handles.twinNotesS, 'enable', 'off')
    set(handles.browse_note_B, 'enable', 'off')
else
    set(handles.twinNotesS, 'enable', 'on')
    set(handles.browse_note_B, 'enable', 'on')
end


function twinNotesS_Callback(hObject, eventdata, handles)
% hObject    handle to twinNotesS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of twinNotesS as text
%        str2double(get(hObject,'String')) returns contents of twinNotesS as a double


% --- Executes during object creation, after setting all properties.
function twinNotesS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to twinNotesS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% browse files

% --- Executes on button press in browse_slp_B.
function browse_slp_B_Callback(hObject, eventdata, handles)
% hObject    handle to browse_slp_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName, filePath] = uigetfile({'*.mat','MAT-files (*.mat)'; '*.edf','edf-files (*.edf)'; '*.set', 'EEGLab (*.set)'; '*.*',  'All Files (*.*)'}, 'Sleep Data File');
set(handles.fileIN, 'String', fullfile(filePath,fileName));

% --- Executes on button press in browse_stg_B.
function browse_stg_B_Callback(hObject, eventdata, handles)
% hObject    handle to browse_stg_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName, filePath] = uigetfile({'*.mat','MAT-files (*.mat)'; '*.*',  'All Files (*.*)'}, 'Sleep Stage File');
set(handles.stageFileIN, 'String', fullfile(filePath,fileName));

% --- Executes on button press in browse_note_B.
function browse_note_B_Callback(hObject, eventdata, handles)
% hObject    handle to browse_note_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName, filePath] = uigetfile({'*.txt','text files (*.txt)'; '*.*',  'All Files (*.*)'}, 'Sleep Notes File');
set(handles.twinNotesS, 'String', fullfile(filePath,fileName));

%% Menu Items

% --------------------------------------------------------------------
function start_m_Callback(hObject, eventdata, handles)
% hObject    handle to start_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function chan_m_Callback(hObject, eventdata, handles)
% hObject    handle to chan_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function montage_m_Callback(hObject, eventdata, handles)
% hObject    handle to montage_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sleepStats_m_Callback(hObject, eventdata, handles)
% hObject    handle to sleepStats_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function mark_m_Callback(hObject, eventdata, handles)
% hObject    handle to mark_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function starMark_m_Callback(hObject, eventdata, handles)
% hObject    handle to starMark_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mark_t_ClickedCallback(handles.mark_t, eventdata, handles)


% --------------------------------------------------------------------
function clearEvents_m_Callback(hObject, eventdata, handles)
% hObject    handle to clearEvents_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in eventClear.
out = inputdlg('Enter something to replace (e.g. REM)');
if(~isempty(out))
    event = out{1};
else
    event = '';
end

if(isfield(handles.stageData, 'events') && ~isempty(event))
    if(isfield(handles.stageData.events, event))
        handles.stageData.events = rmfield(handles.stageData.events, event);
        guidata(hObject, handles)
        curX = xlim(handles.axes1);
        range = curX(1):curX(2);
        plotSleepData(handles, range);
        
        if(length(fields(handles.stageData)) >= 9)
            stageData = handles.stageData;
            save(get(handles.stageFileIN, 'String'), 'stageData');
        end
    else
        errordlg(['There are no evets called: ', event]);
    end
else
    errordlg('There are no events in this dataset');
end



% --------------------------------------------------------------------
function runStats_m_Callback(hObject, eventdata, handles)
% hObject    handle to runStats_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in statsB.
out = inputdlg('Name of statistics output files:', 'Stats Name', 1,{'stageStats'});
name = 'stageStats';
if(~isempty(out))
    name = out{1};
end
plotSleepStats(get(handles.stageFileIN, 'String'), name);

% --------------------------------------------------------------------
function hideChan_m_Callback(hObject, eventdata, handles)
% hObject    handle to hideChan_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
out = inputdlg('Enter the channel to hide (e.g. EMG1):');
if(~isempty(out))
    chan = out{1};
    handles.hideChans{end + 1} = chan;
    guidata(hObject, handles)
    curX = xlim(handles.axes1);
    range = curX(1):curX(2);
    plotSleepData(handles, range);
end


% --------------------------------------------------------------------
function showChan_m_Callback(hObject, eventdata, handles)
% hObject    handle to showChan_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
out = inputdlg('Enter the channel to show (e.g. EMG1):');
if(~isempty(out))
    chan = out{1};
    handles.hideChans(find(strcmp(handles.hideChans, chan))) = [];
    guidata(hObject, handles)
    curX = xlim(handles.axes1);
    range = curX(1):curX(2);
    plotSleepData(handles, range);
end


% --------------------------------------------------------------------
function setScale_m_Callback(hObject, eventdata, handles)
% hObject    handle to setScale_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
out = inputdlg('Enter the channel to set the scale on (e.g. C3):');
if(~isempty(out))
    chan = out{1};
    inds = find(strcmp(handles.scaleChans, chan));
    if(isempty(inds))
        handles.scaleChans{end + 1} = chan; 
    else
        handles.scaleChans(inds) = [];
    end
    guidata(hObject, handles)
    curX = xlim(handles.axes1);
    range = curX(1):curX(2);
    plotSleepData(handles, range);
end


% --------------------------------------------------------------------
function nweData_m_Callback(hObject, eventdata, handles)
% hObject    handle to nweData_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.setupPan, 'Visible', 'on')

% --------------------------------------------------------------------
function compScores_m_Callback(hObject, eventdata, handles)
% hObject    handle to compScores_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function loadComp_Callback(hObject, eventdata, handles)
% hObject    handle to loadComp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName, filePath] = uigetfile({'*.mat','MAT-files (*.mat)'; '*.*',  'All Files (*.*)'}, 'Sleep Stage File for Comparison');
compStage = load(fullfile(filePath,fileName));
compStages = compStage.stageData.stages;
if(length(compStages) < length(handles.stageData.stages))
    tmp = ones(size(handles.stageData.stages))*7;
    tmp(1:length(compStages)) = compStages;
    compStages = tmp;
elseif(length(compStages) > length(handles.stageData.stages))
    compStages = compStages(1:length(handles.stageData.stages));
end
handles.compStage = compStages;
handles.showComp = 1;
guidata(hObject, handles)

% --------------------------------------------------------------------
function showCompHyp_m_Callback(hObject, eventdata, handles)
% hObject    handle to showCompHyp_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isfield(handles, 'compStage'))
    loadComp_Callback(handles.loadComp, eventData, handles);
end
handles.showComp = 1;
guidata(hObject, handles)

% --------------------------------------------------------------------
function hideCompHyp_m_Callback(hObject, eventdata, handles)
% hObject    handle to hideCompHyp_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.showComp = 0;
guidata(hObject, handles)

% --------------------------------------------------------------------
function reliability_m_Callback(hObject, eventdata, handles)
% hObject    handle to reliability_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Reliability(handles.compStage, handles.stageData.stages);

%% Tool Bar Functions
% --------------------------------------------------------------------
function lightsOff_t_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to lightsOff_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winSize = str2num(get(handles.winIN, 'String'));
srate = handles.EEG.srate;
pt = etime(datevec(handles.stageData.lightsOFF), datevec(handles.stageData.recStart))/60;
ptX = floor(pt(1)*(60/winSize))*winSize*srate;
jumpto(handles, ptX)

% --------------------------------------------------------------------
function lightsOn_t_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to lightsOn_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winSize = str2num(get(handles.winIN, 'String'));
srate = handles.EEG.srate;
pt = etime(datevec(handles.stageData.lightsON), datevec(handles.stageData.recStart))/60;
ptX = floor(pt(1)*(60/winSize))*winSize*srate;
jumpto(handles, ptX)

% --------------------------------------------------------------------
function jumpTo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to jumpTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
out = inputdlg('Enter Epoch #:');
if(~isempty(out))
    epoch = out{1};
else
    epoch = '';
end
if(~isempty(epoch))
    winSize = str2num(get(handles.winIN, 'String'));
    srate = handles.EEG.srate;
    jumpto(handles, (str2double(epoch) - 1)*winSize*srate)
end

% --------------------------------------------------------------------
function scaleBigger_t_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to scaleBigger_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curScale = handles.curScale - 10;
guidata(hObject, handles);
curX = xlim(handles.axes1);
range = curX(1):curX(2);
plotSleepData(handles, range)


% --------------------------------------------------------------------
function scaleSmall_t_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to scaleSmall_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curScale = handles.curScale + 10;
guidata(hObject, handles);
curX = xlim(handles.axes1);
range = curX(1):curX(2);
plotSleepData(handles, range)

% --------------------------------------------------------------------
function resetScale_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to resetScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curScale = 100;
guidata(hObject, handles);
curX = xlim(handles.axes1);
range = curX(1):curX(2);
plotSleepData(handles, range)

% --------------------------------------------------------------------
function notes_t_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to notes_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(strcmp(get(handles.notePan, 'Visible'),'on'))
    set(handles.notePan, 'Visible', 'off')
else
    set(handles.notePan, 'Visible', 'on')
end


% --------------------------------------------------------------------
function mark_t_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to mark_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in markB.
if(strcmp(get(handles.markStr, 'Enable'), 'on'))
    set(handles.markStr, 'Enable', 'off')
    set(handles.setMark, 'Enable', 'off')
    set(handles.delMark, 'Enable', 'off')
    set(handles.slopeB, 'Enable', 'off')
else
    set(handles.markStr, 'Enable', 'on')
    set(handles.setMark, 'Enable', 'on')
    set(handles.delMark, 'Enable', 'on')
    set(handles.slopeB, 'Enable', 'on')
end
    
handles.cursor = datacursormode('toggle');
set(handles.cursor, 'UpdateFcn', @cursorInfoUpdate)
guidata(hObject, handles);


% --- Executes on selection change in plotSleepIN.
function plotSleepIN_Callback(hObject, eventdata, handles)
% hObject    handle to plotSleepIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns plotSleepIN contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotSleepIN
curX = xlim(handles.axes1);
range = curX(1):curX(2);
plotSleepData(handles, range)


% --- Executes during object creation, after setting all properties.
function plotSleepIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotSleepIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function info_m_Callback(hObject, eventdata, handles)
% hObject    handle to info_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function aInfo_m_Callback(hObject, eventdata, handles)
% hObject    handle to aInfo_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msg = sprintf(['Program Authors: Stephaing M. Greer & Jared M. Saletin \n\n',...
               'Sleep and Neuroimaging Laboratory (Matthew P. Walker)\n', ...
               'University of California Berkeley\n', ...
               'Helen Wills Neuroscience Institute\n', ...
               'Department of Psychology \n\n', ...
               'Contact: smgreer@berkeley.edu\n', ...
               'https://sourceforge.net/projects/sleepsmg']);
msgbox(msg, 'Author Info');


% --------------------------------------------------------------------
function hKeysInfo_m_Callback(hObject, eventdata, handles)
% hObject    handle to hKeysInfo_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msg = sprintf(['To use keyborad for scoring first click anywhere on the window that does not contain an object.\n\n',...
               'Short Cuts:\n', ...
               '0 - wake\n', ...
               '1 - stage 1 \n', ...
               '2 - stage 2\n', ...
               '3 - stage 3\n', ...
               '3 - stage 4\n', ...
               '5 - stage REM\n', ...
               '6 - Movement Time\n', ...
               '. - Mark epoch as unscored\n', ...
               '7 - scroll to the left\n', ...
               '9 - scroll to the right\n\n', ...
               '*The keyboard short cuts will not work when event marking mode is turned on.']);
msgbox(msg, 'Hot Keys');
