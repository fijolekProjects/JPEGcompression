function varargout = jpeg_GUI(varargin)
% JPEG_GUI MATLAB code for jpeg_GUI.fig
%      JPEG_GUI, by itself, creates a new JPEG_GUI or raises the existing
%      singleton*.
%
%      H = JPEG_GUI returns the handle to a new JPEG_GUI or the handle to
%      the existing singleton*.
%
%      JPEG_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in JPEG_GUI.M with the given input arguments.
%
%      JPEG_GUI('Property','Value',...) creates a new JPEG_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before jpeg_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to jpeg_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help jpeg_GUI

% Last Modified by GUIDE v2.5 22-Dec-2012 16:22:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @jpeg_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @jpeg_GUI_OutputFcn, ...
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


% --- Executes just before jpeg_GUI is made visible.
function jpeg_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to jpeg_GUI (see VARARGIN)

% Choose default command line output for jpeg_GUI
handles.output = hObject;

set(handles.axes1, 'visible', 'off')
set(handles.axes2, 'visible', 'off')
% Update handles structure
assignin('base','quality',1)


guidata(hObject, handles);

% UIWAIT makes jpeg_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = jpeg_GUI_OutputFcn(hObject, eventdata, handles) 
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
% handles    structure with handles and user data (see GUIDATA)
evalin('base','jpeg_main');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;

axes(handles.axes1);
IN = imread('original.tif');
imshow(IN);
title({'Original TIF Image'; ['Filesize: ' evalin('base', 'originalFilesizeInKB') 'KB']})

axes(handles.axes2);
OUT = imread('afterJPEG.jpeg');
imshow(OUT);
title({'Image after JPEG compression'; ['Filesize: ' evalin('base', 'afterJPEGFilesizeInKB') 'KB']})
guidata(hObject, handles);


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
quality = get(hObject,'Value');
set(handles.qualityValue, 'String', ['quality = ' num2str(quality)]);
assignin('base','quality',quality)
% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
