function varargout = searchGUI(varargin)
% SEARCHGUI MATLAB code for searchGUI.fig
%      SEARCHGUI, by itself, creates a new SEARCHGUI or raises the existing
%      singleton*.
%
%      H = SEARCHGUI returns the handle to a new SEARCHGUI or the handle to
%      the existing singleton*.
%
%      SEARCHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEARCHGUI.M with the given input arguments.
%
%      SEARCHGUI('Property','Value',...) creates a new SEARCHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before searchGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to searchGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help searchGUI

% Last Modified by GUIDE v2.5 01-Apr-2018 15:30:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @searchGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @searchGUI_OutputFcn, ...
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


% --- Executes just before searchGUI is made visible.
function searchGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to searchGUI (see VARARGIN)

% Choose default command line output for searchGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes searchGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = searchGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)’

for i = 10:29
    textTag = eval(strcat('handles.text', num2str(i)));
    set (textTag,'Visible','on');
end

sketchName = get(handles.edit1,'String');
fileList = fopen('realSketch.txt','r');
nline = 0;
while ~feof(fileList) % 判断是否为文件末尾
    tline = fgetl(fileList); % 从文件读行
    tlist = strsplit(tline, ' ');
    nline = nline+1;
    if strcmp(tlist{1}, sketchName)
        testLabel = tlist{2};
        num = nline;
        break;
    end
end
fclose(fileList);

t0=cputime;
load('feature_190.mat');
test_LDA = test_LDA(num, :);

% load('transMatrix.mat');
% load('cycleok_1194.mat');
% load('realok_294.mat');
% realFeature = realFea(num, :);
% test_PCA = realFeature * PCA_trans;
% test_LDA = test_PCA * LDA_trans; %1*newDim
% train_PCA  = cycleFea * PCA_trans; %num*newDim
% train_LDA  = train_PCA * LDA_trans; %num*newDim

dist = pdist2(test_LDA, train_LDA, 'cosine') ;
[sortedDist, index] = sort(dist);
dispNum = 5;
detectLabel = cycleLabel(index(1:dispNum));
% detectLabel = cyclelabel(index);
if str2num(testLabel)==detectLabel(1)
    fprintf('%s detect right.\n', sketchName);
else
    fprintf('%s detect wrong.\n', sketchName);
end
fprintf('real label: %d, detected label: %d  %d  %d  %d  %d.\n', str2num(testLabel), detectLabel);

[sketchName, sketchLabel] = textread('fakeSketch.txt', '%s %d');
[photoName, photoLabel] = textread('realPhoto.txt', '%s %d');
fprintf('Photo name: ');
for i = 1:dispNum
    simiTag = eval(strcat('handles.text', num2str(i+14)));
    set(simiTag, 'String', (1-sortedDist(i)/2)^(1/0.8));
    skInd = find(sketchLabel==detectLabel(i));
    if ~isempty(skInd)
        axeTag = eval(strcat('handles.axes', num2str(i+6)));
        axes(axeTag);
        imshow(imread(strcat('fakeSketch/', sketchName{skInd})));
    end
    phInd = find(photoLabel==detectLabel(i));
    if ~isempty(phInd)
        axeTag = eval(strcat('handles.axes', num2str(i+1)));
        axes(axeTag);
        imshow(imread(strcat('realPhoto/', photoName{phInd})));
        fprintf('%s ', photoName{phInd});
    end
end
fprintf('\n ');

TimeCost=cputime-t0;
disp(TimeCost);



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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[pname,adrname]=uigetfile('realSketch/*.jpg', 'Choose a sketch');
if exist(strcat(adrname,pname))
    img=imread(strcat(adrname,pname));
    set(handles.edit1, 'String', pname);
    axes(handles.axes1);
    imshow(img);
else 
       return;
end;
