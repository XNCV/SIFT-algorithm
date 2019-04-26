function varargout = GuideSIFT(varargin)
% GUIDESIFT MATLAB code for GuideSIFT.fig
%      GUIDESIFT, by itself, creates a new GUIDESIFT or raises the existing
%      singleton*.
%
%      H = GUIDESIFT returns the handle to a new GUIDESIFT or the handle to
%      the existing singleton*.
%
%      GUIDESIFT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDESIFT.M with the given input arguments.
%
%      GUIDESIFT('Property','Value',...) creates a new GUIDESIFT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuideSIFT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuideSIFT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help GuideSIFT
% Last Modified by GUIDE v2.5 22-Apr-2018 14:52:04
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuideSIFT_OpeningFcn, ...
                   'gui_OutputFcn',  @GuideSIFT_OutputFcn, ...
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


% --- Executes just before GuideSIFT is made visible.
function GuideSIFT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuideSIFT (see VARARGIN)

% Choose default command line output for GuideSIFT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuideSIFT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuideSIFT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in InputTestImage.
function InputTestImage_Callback(hObject, eventdata, handles)
% hObject    handle to InputTestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path
[path, user_cance] = imgetfile();
if user_cance
    msgbox(sprintf('Error'), 'Error', 'Error');
    return;
end
imtest=imread(path);
axes(handles.ImageTest);
imshow(imtest);


% --- Executes on button press in Training.
function Training_Callback(hObject, eventdata, handles)
% hObject    handle to Training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global database filename dname
sym compl
output = cell(300,1);
leng=length(database);
for count=1:1:leng
   databasename = fullfile(dname, database(count).name);
   [image, descrips, locs] = sift(databasename);
   output{count} = struct('image', image, 'descriptors',descrips ,'locs',locs, 'person', count);
   filename = 'X:\172\xla\project\sift\Training/data.mat';
   save (filename, 'output');
end



function Name_Callback(hObject, eventdata, handles)
% hObject    handle to Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Name as text
%        str2double(get(hObject,'String')) returns contents of Name as a double


% --- Executes during object creation, after setting all properties.
function Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Identify.
function Identify_Callback(hObject, eventdata, handles)
% hObject    handle to Identify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path database
distRatio = 0.6;
[im, des, locs] = sift(path);
out = load('X:\172\xla\project\sift\Training\data.mat');
leng = length(database);
for count=1:1:leng
  desc = out.output{count,1}.descriptors;
  dest = desc';
  for i = 1 : size(des,1)
    dotprods = des(i,:) * dest;
    [vals,indx] = sort(acos(dotprods));
    if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
    else
      match(i) = 0;
    end
  end
  Kpoint(1,count) = sum(match > 0);
end
[B,IX] = sort(Kpoint,'descend');
N = IX(1);
M = out.output{N,1}.person;
threshold = B(1)/size(des,1)*100;
if(threshold > 15)
  set(handles.Name,'String', database(M).name(1:end-5));
  axes(handles.MatchedImage);
  imshow(out.output{N,1}.image);
else
  set(handles.Name,'String', 'Not In Database');
  axes(handles.MatchedImage);
  imshow('X:\172\xla\project\sift\TestFile\no.bmp');
end



function Complete_Callback(hObject, eventdata, handles)
% hObject    handle to Complete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Complete as text
%        str2double(get(hObject,'String')) returns contents of Complete as a double


% --- Executes during object creation, after setting all properties.
function Complete_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Complete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in InputPathData.
function InputPathData_Callback(hObject, eventdata, handles)
% hObject    handle to InputPathData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global database dname
dname = uigetdir('X:\172\xla\project\sift\');
database=dir(strcat(dname,'\*1.bmp'));
