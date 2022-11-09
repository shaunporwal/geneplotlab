function varargout = SDGUI(varargin)
% SDGUI MATLAB code for SDGUI.fig
%      SDGUI, by itself, creates a new SDGUI or raises the existing
%      singleton*.
%
%      H = SDGUI returns the handle to a new SDGUI or the handle to
%      the existing singleton*.
%
%      SDGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SDGUI.M with the given input arguments.
%
%      SDGUI('Property','Value',...) creates a new SDGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SDGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SDGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help SDGUI
% Last Modified by GUIDE v2.5 28-Apr-2019 00:43:11
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SDGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SDGUI_OutputFcn, ...
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
end
% --- Executes just before SDGUI is made visible.
function SDGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SDGUI (see VARARGIN)
% Choose default command line output for SDGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes SDGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.radiobutton9,'Value',0);
set(handles.radiobutton10,'Value',0);
set(handles.radiobutton11,'Value',0);
set(handles.radiobutton12,'Value',0);
set(handles.radiobutton14,'Value',0);

end
% --- Outputs from this function are returned to the command line.
function varargout = SDGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
end
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)     
%% Prep, get data from matrix, try/catch
cla(handles.Clusters,'reset');
MatrixName = get(handles.edit9,'String'); %number of clusters
MatrixName = char(MatrixName);
try
    DataMatrix = csvread(MatrixName,1,0);
catch
    set(handles.text12,'string','Please Enter Valid File name');
    set(handles.edit9,'BackgroundColor',[0.9 0 0]);
    cla(handles.Clusters,'reset');
    axes(handles.Clusters);
    matlabImage = imread('Error.jpg');
    image(matlabImage);
    axis off;
    axis image;
end
setMatrixGlobal(DataMatrix);
%% get values entered by user into GUI
ClusterNum = str2double(get(handles.edit4,'String')); %number of clusters
IterNum = str2double(get(handles.edit7,'String')); %number of iterations
%% Check For Error in values
er3=isnan(ClusterNum);
er6=isnan(IterNum);
switch ~(ischar(MatrixName))
    case 1
        set(handles.text12,'string','Please Enter Valid Text');
        set(handles.edit9,'BackgroundColor',[0.9 0 0]);
end      
switch er3 | ~(isnumeric(ClusterNum)) 
    case 1
        set(handles.text12,'string','Please Enter Valid Values');
        set(handles.edit4,'BackgroundColor',[0.9 0 0]);
end
switch er6 | ~(isnumeric(IterNum))
    case 1
        set(handles.text12,'string','Please Enter Valid Values');
        set(handles.edit7,'BackgroundColor',[0.9 0 0]);
end
%% If Errors, tell user there's an error, else do KMEANS,PLOTTING,CORRELATION
if er3...
        | er6|~(ischar(MatrixName))|~(isnumeric(DataMatrix))...
        |~(isnumeric(ClusterNum))|...
        ~(isnumeric(IterNum))   
cla(handles.Clusters,'reset');
axes(handles.Clusters);
matlabImage = imread('Error.jpg');
image(matlabImage);
axis off;
axis image;
else
%% K-means-pythag, show data on gui 

 [ClusterAssignment, Iterations, GeneNum, Timepoints, AntiCorrValue,AntiClusterAssignment] =...
     Kmeans(DataMatrix,ClusterNum,IterNum);
 setTimepointsGlobal(Timepoints);
setGeneNumGlobal(GeneNum);
setAssignmentGlobal(ClusterAssignment); %make ClusterAssignment global so slider can
% use it too
% display(length(ClusterAssignment));
% display('line143'); 
% ClusterAssignment

setAntiClusGlobal(AntiClusterAssignment);

set(handles.edit15,'String', Iterations);
e20=str2double(get(handles.edit4,'string'));
set(handles.slider1,'Value',1);
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',e20);
set(handles.slider1,'SliderStep', [1/(ClusterNum-1) 10/(ClusterNum-1)]);
set(handles.edit16,'String',1); %Set Current Cluster Value to 1
set(handles.text12,'string','Yo');
%% Plotting First Cluster + listbox 
grid on;
hold on;
set(gca,'FontSize',7)
    for j = 1:DataMatrix(:,1)
        if ClusterAssignment(j) == 1
            plot(handles.Clusters,1:Timepoints,DataMatrix(j,:),'b')
            hold on;
            set(gca,'xtick',1:Timepoints);
            xlim([1,Timepoints]);
        end
    end
hold off; 

totclus = [1:str2double(get(handles.edit4,'String'))]'; %setting left listbox
% as clusters from 1 to NumOfClusters
set(handles.listbox2,'String',totclus);

gn = get(handles.edit20,'String'); %gn = gene names

if gn~=""
            gn = importdata(gn);
            ca = getAssignmentGlobal;% ca = cluster assignment
            ca = ca';  
        c = 0;
        b = strings(length(gn),1);%preallocating array of strings
        for i = 1:(length(ca)) % I ONLY CHANGED THIS LINE FROM GN TO CA
            if (ca(i)==1)
                c=c+1;
                b(c) = string(gn(i));
            end
        end
        b = b';
        set(handles.listbox3,'String',b);
end


%     a = get(handles.edit20,'String');
%     a = importdata(a);
%     curclusgenes = getAssignmentGlobal;
%     curclusgenes = curclusgenes';  
% c = 0;
% b = strings(length(a),1);%preallocating array of strings
% for i = 1:(length(a))
%     if (curclusgenes(i)==1)
%         c=c+1;
%         b(c) = string(a(i));
%     end
% end
% b = b';
% set(handles.listbox3,'String',b);
%% Correlation
ClusNum = 1; 
[x,y,z]=ClusCorr(GeneNum,ClusterAssignment,ClusNum,DataMatrix);
% current cluster profile= cc, = to all gene profiles in current cluster
% setCurClusGlobal(ccp);
% plot(handles.Clusters,1:5,z);
setCCGeneNumGlobal(y);
x = num2str(x);
y = num2str(y);
set(handles.edit18,'String',x); 
set(handles.edit19,'String',y);
end
end
function edit4_Callback(hObject, eventdata, handles)
end
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit7_Callback(hObject, eventdata, handles)
end
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit9_Callback(hObject, eventdata, handles)
end
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit15_Callback(hObject, eventdata, handles)
end
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit16_Callback(hObject, eventdata, handles)
end
function edit16_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.radiobutton9,'Value',0);
set(handles.radiobutton10,'Value',0);
set(handles.radiobutton11,'Value',0);
set(handles.radiobutton12,'Value',0);
set(handles.radiobutton14,'Value',0);

v = get(handles.slider1,'Value');
set(handles.edit16,'String', num2str(round(v)));
gatherAndUpdate(handles)
% set(handles.edit18,'String',num2str(getCorrGlobal));
% set(handles.edit19,'String',num2str(getCorrCounGlobal));
end
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit9,'BackgroundColor','white');
set(handles.edit4,'BackgroundColor','white');
set(handles.edit7,'BackgroundColor','white');
set(handles.edit9,'string','convertcsv.csv');
set(handles.edit20,'string','GeneNames.txt');
set(handles.edit4,'string','20');
set(handles.edit7,'string','50');
set(handles.text12,'string','Ready');
end
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text12,'string','Please Set Your Desired Values');
axes(handles.Clusters)
cla(handles.Clusters,'reset');
set(handles.Clusters,'Visible','off');
axis off;
cla(handles.Clusters,'reset');
axes(handles.GeneExpressionProfiles)
cla(handles.GeneExpressionProfiles,'reset');
set(handles.GeneExpressionProfiles,'Visible','off');
axis off;
cla(handles.GeneExpressionProfiles,'reset');


set(handles.edit4,'BackgroundColor','white');
set(handles.edit4,'string','');
set(handles.edit7,'BackgroundColor','white');
set(handles.edit7,'string','');
set(handles.edit9,'BackgroundColor','white');
set(handles.edit9,'string','FileName');
set(handles.edit15,'String','#iterations');
set(handles.edit16,'String','CurrentCluster');
set(handles.edit18,'String','Correlation%');
set(handles.edit19,'String','GenesInCluster');
set(handles.edit20,'string','FileName');
set(handles.edit21,'String','Resolution');
set(handles.edit22,'String','NameOfGene');
set(handles.edit23,'String','ClusNum');
set(handles.edit32,'String','EnterFileName');
set(handles.edit34,'String','EnterFileName');
set(handles.edit35,'String','Clus#');

set(handles.text39,'String','');

set(handles.radiobutton9,'Value',0);
set(handles.radiobutton10,'Value',0);
set(handles.radiobutton11,'Value',0);
set(handles.radiobutton12,'Value',0);
set(handles.radiobutton14,'Value',0);

set(handles.listbox2,'Value',1);
set(handles.listbox2,'String','Clusters');
set(handles.listbox3,'String','Genes');
set(handles.listbox4,'String','Genes');
end
function gatherAndUpdate(handles)
gatheredClusterNumData = gatherClusterNumData(handles);
% gatheredCorrData = gatherCorrData(handles);
updateAxes(handles.Clusters,gatheredClusterNumData);
updateCorrCoun(handles.edit18,handles.edit19,gatheredClusterNumData); 
end
function gatheredClusterNumData = gatherClusterNumData(handles)
gatheredClusterNumData.clusNum = get(handles.edit16,'String');
gatheredClusterNumData.clusNum = str2double(gatheredClusterNumData.clusNum);
end
function updateAxes(axesToUse, gd)
axes(axesToUse)
cla reset;
gd = struct2cell(gd);
gd = cell2mat(gd);
DataMatrix = getMatrixGlobal;
ClusterAssignment = getAssignmentGlobal;
Timepoints = getTimepointsGlobal;
grid on;
set(gca,'FontSize',7)
    for j = 1:length(ClusterAssignment);
        if ClusterAssignment(j) == gd;
            plot(1:Timepoints,DataMatrix(j,:),'b')
            hold on;
            set(gca,'xtick',1:Timepoints);
            xlim([1,Timepoints]);
        end
    end
end
function updateCorrCoun(editCorr,editCoun, gd)
gd = struct2cell(gd);
gd = cell2mat(gd);

ClusNum = gd; 
DataMatrix = getMatrixGlobal;

ClusterAssignment = getAssignmentGlobal;
GeneNum = getMatrixGlobal;
GeneNum = length(GeneNum(:,1));

[x,y,cAve]=ClusCorr(GeneNum,ClusterAssignment,ClusNum,DataMatrix);
% current cluster profile= cc, = to all gene profiles in current cluster
% setCurClusGlobal(ccp);
setClusAveGlobal(cAve);
% display(cAve);
% display(getClusAveGlobal);
% setCCGeneNumGlobal(y);
x = num2str(x);
y = num2str(y);
set(editCorr,'String',x); 
set(editCoun,'String',y);
end
function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double
end
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double
end
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.Clusters,'reset');
MatrixName = get(handles.edit9,'String'); %number of clusters
MatrixName = char(MatrixName);
try
    DataMatrix = csvread(MatrixName);
catch
    set(handles.text12,'string','Please Enter Valid File name');
    set(handles.edit9,'BackgroundColor',[0.9 0 0]);
    cla(handles.Clusters,'reset');
    axes(handles.Clusters);
    matlabImage = imread('Error.jpg');
    image(matlabImage);
    axis off;
    axis image;
end
setMatrixGlobal(DataMatrix);
%% get values entered by user into GUI
ClusterNum = str2double(get(handles.edit4,'String')); %number of clusters
IterNum = str2double(get(handles.edit7,'String')); %number of iterations
%% Check For Error in values
er3=isnan(ClusterNum);
er6=isnan(IterNum);
switch ~(ischar(MatrixName))
    case 1
        set(handles.text12,'string','Please Enter Valid Text');
        set(handles.edit9,'BackgroundColor',[0.9 0 0]);
end      
switch er3 | ~(isnumeric(ClusterNum)) 
    case 1
        set(handles.text12,'string','Please Enter Valid Values');
        set(handles.edit4,'BackgroundColor',[0.9 0 0]);
end
switch er6 | ~(isnumeric(IterNum))
    case 1
        set(handles.text12,'string','Please Enter Valid Values');
        set(handles.edit7,'BackgroundColor',[0.9 0 0]);
end
%% If Errors, tell user there's an error, else do KMEANS,PLOTTING,CORRELATION
if er3...
        | er6|~(ischar(MatrixName))|~(isnumeric(DataMatrix))...
        |~(isnumeric(ClusterNum))|...
        ~(isnumeric(IterNum))   
cla(handles.Clusters,'reset');
axes(handles.Clusters);
matlabImage = imread('Error.jpg');
image(matlabImage);
axis off;
axis image;
else
%% K-means, show data on gui 
[ClusterAssignment, Iterations, GeneNum, Timepoints, AntiCorrValue,AntiClusterAssignment] =...
     KmeansChiSquare(DataMatrix,ClusterNum,IterNum);
setTimepointsGlobal(Timepoints);

setGeneNumGlobal(GeneNum);
setAssignmentGlobal(ClusterAssignment); %make ClusterAssignment global so slider can
% use it too
 %display(length(ClusterAssignment));
  
setAntiClusGlobal(AntiClusterAssignment); 
 
set(handles.edit15,'String', Iterations);
e20=str2double(get(handles.edit4,'string'));
set(handles.slider1,'Value',1);
set(handles.slider1,'Min',1);
set(handles.slider1,'Max',e20);
set(handles.slider1,'SliderStep', [1/(ClusterNum-1) 10/(ClusterNum-1)]);
set(handles.edit16,'String',1); %Set Current Cluster Value to 1
set(handles.text12,'string','Move Slider To See Other Clusters');
%% Plotting First Cluster + set left listbox values
grid on;
set(gca,'FontSize',7)
    for j = 1:GeneNum
        if ClusterAssignment(j) == 1
            plot(handles.Clusters,1:Timepoints,DataMatrix(j,:),'b');
            hold on;
            set(gca,'xtick',1:Timepoints);
            xlim([1,Timepoints]);
        end
    end
    
totclus = [1:str2double(get(handles.edit4,'String'))]'; %setting left listbox
% as clusters from 1 to NumOfClusters
set(handles.listbox2,'String',totclus);
    gn = get(handles.edit20,'String'); %gn = gene names
    
    
    % if you need to make # of gene names fit the # of genes (in case it
    % doesn't match automatically, possibly due to wanting to test out the
    % smaller test csv data with arbitrary gene names and displaying in the
    % listbox(es), then make it so that length of a and length of curclus
    % genes are equal. 
    
    % length of a is length of gene names file, and curclusgenes is total
    % cluster assignment 
    
    
    if gn~=""
            gn = importdata(gn);
            ca = getAssignmentGlobal;% ca = cluster assignment
            ca = ca';  
        c = 0;
        b = strings(length(gn),1);%preallocating array of strings
        for i = 1:(length(ca)) % I ONLY CHANGED THIS LINE FROM GN TO CA
            if (ca(i)==1)
                c=c+1;
                b(c) = string(gn(i));
            end
        end
        b = b';
        set(handles.listbox3,'String',b);
    end
%% Correlation
ClusNum = 1; 
[x,y,cAve]=ClusCorr(GeneNum, ClusterAssignment,ClusNum,DataMatrix);
% current cluster profile= cc, = to all gene profiles in current cluster
% setClusAveGlobal(cAve);
setCCGeneNumGlobal(y);
x = num2str(x);
y = num2str(y);
set(handles.edit18,'String',x); 
set(handles.edit19,'String',y);
end
end
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)     
%% Prep, get data from matrix, try/catch
cla(handles.GeneExpressionProfiles,'reset');
MatrixName = get(handles.edit9,'String'); %number of clusters
MatrixName = char(MatrixName);

try
    DataMatrix = csvread(MatrixName);
catch
    set(handles.text12,'string','Please Enter Valid File name');
    set(handles.edit9,'BackgroundColor',[0.9 0 0]);
    cla(handles.Clusters,'reset');
    axes(handles.Clusters);
    matlabImage = imread('Error.jpg');
    image(matlabImage);
    axis off;
    axis image;
    
    set(handles.text12,'string','Please Enter Valid File name');
    set(handles.edit9,'BackgroundColor',[0.9 0 0]);
    cla(handles.GeneExpressionProfiles,'reset');
    axes(handles.GeneExpressionProfiles);
    matlabImage = imread('Error.jpg');
    image(matlabImage);
    axis off;
    axis image;
end

setMatrixGlobal(DataMatrix);
GeneNum = length(DataMatrix(:,1));
Timepoints = length(DataMatrix(1,:));
%% get values entered by user into GUI
ClusterNum = str2double(get(handles.edit4,'String')); %number of clusters
IterNum = str2double(get(handles.edit7,'String')); %number of iterations
%% Check For Error in values
er3=isnan(ClusterNum);
er6=isnan(IterNum);
switch ~(ischar(MatrixName))
    case 1
        set(handles.text12,'string','Please Enter Valid Text');
        set(handles.edit9,'BackgroundColor',[0.9 0 0]);
end      
switch er3 | ~(isnumeric(ClusterNum)) 
    case 1
        set(handles.text12,'string','Please Enter Valid Values');
        set(handles.edit4,'BackgroundColor',[0.9 0 0]);
end
switch er6 | ~(isnumeric(IterNum))
    case 1
        set(handles.text12,'string','Please Enter Valid Values');
        set(handles.edit7,'BackgroundColor',[0.9 0 0]);
end
%% If Errors, tell user there's an error, else do KMEANS,PLOTTING,CORRELATION
if er3...
        | er6|~(ischar(MatrixName))|~(isnumeric(DataMatrix))...
        |~(isnumeric(ClusterNum))|...
        ~(isnumeric(IterNum))   
cla(handles.GeneExpressionProfiles,'reset');
axes(handles.GeneExpressionProfiles);
matlabImage = imread('Error.jpg');
image(matlabImage);
axis off;
axis image;
else   
%% Plotting complete profile in upper axes
    
    axes(handles.GeneExpressionProfiles)
    cla(handles.GeneExpressionProfiles,'reset');
    set(handles.GeneExpressionProfiles,'Visible','off');
    axis off;
    cla(handles.GeneExpressionProfiles,'reset');
    axes(handles.GeneExpressionProfiles)
 
     grid on;
     hold on;
     set(gca,'FontSize',7)
     set(gca,'xtick',1:Timepoints);
            xlim([1,Timepoints]);
    for j = 1:GeneNum
            plot(handles.GeneExpressionProfiles,1:Timepoints,DataMatrix(j,:))
    end
end
end
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

curclus = get(hObject,'Value');
gn = get(handles.edit20,'String');
gn = importdata(gn);
ca = getAssignmentGlobal;
ca = ca'; 
ccprof = [];
dm = getMatrixGlobal;
if gn~=""
c = 0;
b = strings(length(gn),1);%preallocating array of strings
for i = 1:(length(ca)) %% ONLY CHANGED GN TO CA FOR TESTING
    if (ca(i)==curclus)
        c=c+1;
        b(c) = string(gn(i));
        ccprof = [ccprof;dm(i,:)];
    end
end
  
clusAve = (sum(ccprof))./length(ccprof(:,1)); %cluster average
setClusAveGlobal(clusAve);

b = b';
set(handles.listbox3,'String',b);
set(handles.text12,'String',num2str(c));
end
end
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3

end
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double

end
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9

ov = get(hObject,'Value');
cag = getClusAveGlobal; %get clus ave global
% display(cag);
if ov==1
    %setClusAveCol(1);
    plot(handles.Clusters,1:5,cag,'color','g','MarkerSize',50);
    hold on;
% else 
%     plot(handles.Clusters,1:5,cag,'color','w');
end
end

% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
rv = get(hObject, 'Value');
cag = getClusAveGlobal;
ptsto = []; %point store
for i = 2:(length(cag(:)))
    tpma = (cag(i)+cag(i-1))/2;%2 point moving average
    ptsto = [ptsto tpma]; 
end

    if rv == 1
    plot(handles.Clusters,2:(length(cag)),ptsto,'Color','c');
    else
    plot(handles.Clusters,2:(length(cag)),ptsto,'Color','w');
    end
end
% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11
rv = get(hObject, 'Value');
cag = getClusAveGlobal;
ptsto = []; %point store
for i = 3:(length(cag(:)))
    tpma = (cag(i)+cag(i-1)+cag(i-2))/3;%2 point moving average
    ptsto = [ptsto tpma]; 
end

    if rv == 1
    plot(handles.Clusters,3:(length(cag)),ptsto,'Color','m');
    else
    plot(handles.Clusters,3:(length(cag)),ptsto,'Color','w');
    end



end

% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12

rv = get(hObject, 'Value');
cag = getClusAveGlobal;
ptsto = []; %point store
for i = 4:(length(cag(:)))
    tpma = (cag(i)+cag(i-1)+cag(i-2)+cag(i-3))/4;%2 point moving average
    ptsto = [ptsto tpma]; 
end

    if rv == 1
    plot(handles.Clusters,4:(length(cag)),ptsto,'Color','k');
    else
    plot(handles.Clusters,4:(length(cag)),ptsto,'Color','w');
    end

end
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dm = getMatrixGlobal;
ca = getAssignmentGlobal;
ca = ca';
ccval = get(handles.listbox2,'Value');% current cluster on listbox2
ccprof = []; %current cluster profiles

grid on;
set(gca,'FontSize',7)
    for j = 1:length(ca)
        if ca(j) == ccval
            plot(handles.Clusters,1:length(dm(1,:)),dm(j,:),'r');
            hold on;
            set(gca,'xtick',1:length(dm(1,:)));
            xlim([1,length(dm(1,:))]);
            ccprof = [ccprof;dm(j,:)];
        end
    end
    clusAve = (sum(ccprof))./length(ccprof(:,1)); %cluster average
    setClusAveGlobal(clusAve);
end
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.Clusters)
cla(handles.Clusters,'reset');

set(handles.radiobutton9,'Value',0);
set(handles.radiobutton10,'Value',0);
set(handles.radiobutton11,'Value',0);
set(handles.radiobutton12,'Value',0);
set(handles.radiobutton14,'Value',0);
end
% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
rbval = get(hObject,'value'); %radiobutton value
dm = getMatrixGlobal; %data matrix
tp = 1:(length(dm(1,:)));
cag = getClusAveGlobal; % cluster average global
[interprof,xvals] = Interpol(tp,cag,str2double(get(handles.edit21,'String')));
if rbval == 1
    hold on;
    plot(xvals,interprof,'b--');
    plot(handles.Clusters,1:length(dm(1,:)),cag,'ro');
else
    plot(xvals,interprof,'w');
    hold on;
    plot(handles.Clusters,1:length(dm(1,:)),cag,'wo');
end

end

function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double

end
% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag = 0;
gn = get(handles.edit22,'String'); % gene name
ag = get(handles.listbox4,'String'); % all genes
cag = getAssignmentGlobal;
gn = string(gn);
ag = string(ag);

    for i = 1:length(ag)
        if(gn == ag(i))
            flag = 1; 
            ca = cag(i); %cluster assignment of searched gene
        end
    end

    if flag==1
        set(handles.edit23,'String',string(ca));
        cag
    else
        set(handles.edit23,'String','Not Found');
    end

end
% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4
end
% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double
end
% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double
end

% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GeneNames = get(handles.listbox3,'String');
GeneNames = string(GeneNames);
fName = string(get(handles.edit32,'String'));

fid = fopen(fName,'w');
fprintf(fid,'%s\n',GeneNames);
fclose(fid);
end

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% showing all genes in listbox 4
gn = get(handles.edit20,'String'); %gn = gene names
if gn~=""
    gn = importdata(gn);
    set(handles.listbox4,'String',gn);
end
end
function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double
end

% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double
end
% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ca = getAssignmentGlobal;
fName = string(get(handles.edit34,'String'));
fid = fopen(fName,'wt');
fprintf(fid,'%d\n',ca);
fclose(fid);
end
function pushbutton4_Callback(hObject, eventdata, handles) %AntiClustering button
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cval = str2double(get(handles.edit35,'String')); %cluster value
acg = getAntiClusGlobal; %anticlusglobal

for i = 1:length(acg)
   if acg(i) == cval
       set(handles.text39,'String',i);
   end
end
end
function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double

end
% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
%% GETTERS&SETTERS
function setAntiClusGlobal(a)
global acg;
acg = a; 
end
function AntiClus = getAntiClusGlobal
global acg;
AntiClus = acg; 
end
function setCCGeneNumGlobal(a)
global ccgn;
ccgn = a; 
end
function ccGeneNum = getCCGeneNumGlobal(a)
global ccgnsto;
ccGeneNum = ccgnsto;
end
function setClusAveGlobal(b)
global o;
o = b;
end
function ClusAve = getClusAveGlobal
global o;
ClusAve = o;
end
function setAssignmentGlobal(t)
global x;
x = t;
end
function setGeneNumGlobal(t)
global x;
x = t;
end
function ClusterAssignment = getAssignmentGlobal
global x;
ClusterAssignment = x;
end
function setMatrixGlobal(t)
global y;
y = t;
end
function DataMatrix = getMatrixGlobal
global y;
DataMatrix = y;
end
function setTimepointsGlobal(t)
global z;
z=t;
end
function Timepoints = getTimepointsGlobal
global z;
Timepoints = z;
end
