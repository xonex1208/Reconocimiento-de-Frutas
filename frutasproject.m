function varargout = frutasproject(varargin)
%FRUTASPROJECT MATLAB code file for frutasproject.fig
%      FRUTASPROJECT, by itself, creates a new FRUTASPROJECT or raises the existing
%      singleton*.
%
%      H = FRUTASPROJECT returns the handle to a new FRUTASPROJECT or the handle to
%      the existing singleton*.
%
%      FRUTASPROJECT('Property','Value',...) creates a new FRUTASPROJECT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to frutasproject_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FRUTASPROJECT('CALLBACK') and FRUTASPROJECT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FRUTASPROJECT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help frutasproject

% Last Modified by GUIDE v2.5 17-Apr-2019 18:29:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frutasproject_OpeningFcn, ...
                   'gui_OutputFcn',  @frutasproject_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before frutasproject is made visible.
function frutasproject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for frutasproject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes frutasproject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = frutasproject_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Variables globales usadas
%carga Para saber si la imagen ya fue cargada o no
%imagen Se almacena la imagen tomada en esta variable
%imagenOriginal Se guarda la imagen original
%vid Se almacena el video en tiempo real
%camOn Para saber si la camara ya fue activada o no
%url Se guarda la url del dispositivo android
%camDroid para saber si la camara android fue activada o no
%recortada Se sabe si la imagen ya fue recortada

% --- Executes on button press in activate_camera.
function activate_camera_Callback(hObject, eventdata, handles)
% hObject    handle to activate_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
global camOn;
camOn=1;
%Probar camaras
%imaqtool
%imaqhwinfo
%imaqhwinfo('winvideo')
%imaqhwinfo('winvideo',1)
%vid=videoinput('winvideo',1,'YUY2_640X480');
%Se hace uso de un try catch para que no falle al seleccionar la camara del
%equipo
try
    vid=videoinput('winvideo',1,'RGB24_640X480');
    handles.output=hObject;
    axes(handles.axes1);
    rc=getselectedsource(vid);
    vid.FramesPerTrigger=1;
    vid.ReturnedColorspace='rgb';
    hImage=image(zeros(480,640,3),'Parent',handles.axes1);
    preview(vid,hImage);
    guidata(hObject,handles);
catch
    msgbox('A ocurrido un error inesperado','Error','error');
end


% --- Executes on button press in activate_droid_camera.
function activate_droid_camera_Callback(hObject, eventdata, handles)
% hObject    handle to activate_droid_camera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global url
global camDroid
try
    camDroid=1;
    %Se coloca la direccion de Android
    url = 'http://192.168.0.3:8080/shot.jpg';
    ss  = imread(url);
    fh = image(ss,'Parent',handles.axes1);
    guidata(hObject, handles);
    while(camDroid)
        %Con el if evitamos el error del ciclo infinito
        if ~isvalid(fh); break; end
        ss  = imread(url);
        set(fh,'CData',ss);
        drawnow;
    end
catch
    msgbox("A ocurrido un error al activar la camara",'Error','error');
end

% --- Executes on button press in take_shot.
function take_shot_Callback(hObject, eventdata, handles)
% hObject    handle to take_shot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global vid
global carga
global camOn
if camOn==1
    carga=1;
    %Se toma la foto a partir de la variable vid
    foto=getsnapshot(vid);
    stoppreview(vid);
    imwrite(foto,'foto2.jpg');
    imagen=imread('foto2.jpg');
    set(handles.texto,'String',"foto2.jpg");
    handles.filename=filename;
    x=imagen;
    subplot (handles.axes2), imshow(x);
    camOn=0;
else
    msgbox('Primero debe activar la camara','Error','error');
end

% --- Executes on button press in cut_image.
%Recortar imagen de cargar imagen o de tomar foto
function cut_image_Callback(hObject, eventdata, handles)
% hObject    handle to cut_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global vid
global carga
global camOn
global recortada
if camOn==1
    foto=getsnapshot(vid);
    stoppreview(vid);
    imwrite(foto,'foto2.jpg');
    imagen=imread('foto2.jpg');
    x=imagen;
    %subplot (handles.axes2), imshow(x);
    camOn=0;
    %subplot(1,2,1);
    %Specify the crop rectangle as a four-element position vector, [xmin ymin width height].
    %Aplicamos un recorte automatico con la funcion imcrop
    %El primer valor es para X y el segundo para Y, el 3 y 4to valor son el
    %tamaño de la imagen, entre mas pequeño el recorte mas grande se vera la
    %imagen, ya que el recorte se hace de afuera para adentro
    rec=imcrop(x,[200,20,640,480]); %Selecciona con el mouse la region a recortar
    imagen=rec;
    subplot(handles.axes2), imshow(rec);
    recortada=1;
elseif carga==1
    x=imagen;
    rec=imcrop(x,[410,100,2448,3264]); %Selecciona con el mouse la region a recortar
    imagen=rec;
    imagen=uint8(imagen);
    subplot(handles.axes2), imshow(rec);
    carga=0;
    recortada=1;
else
    msgbox('Primero debe activar la camara, o cargar una iamgen','Error','error');
end


% --- Executes on button press in load_image.
%Funcion para cargar una imagen desde la computadora
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global carga
[filename,pathname]=uigetfile('*.jpg','Seleccion de Imagen');
if isequal(filename,0)||isequal(pathname,0)
    disp('Usuario presiono cancelar')
else
    %carga se vuelve verdadera: 1
    carga=1;
    disp(['Usuario selecciono',fullfile(pathname,filename)])
    %Se concatena la ruta del archivo mas en nombre del archivo
    todo=strcat(pathname,filename)
    %Se lee la imagen desde la ruta antes concatenada en la variable todo
    imagen=imread(todo);
    %%Se coloca en nombre de la imagen en una etiqueta llamada texto
    set(handles.texto,'String',filename);
    handles.filename=filename;
    %imagen=uint8(imagen);
    %Muestra la imagen en el axes1, mas el titulo de Imagen original
    subplot (handles.axes1), imshow(imagen), title("Imagen Original");
end


% --- Executes on button press in take_image_droid.
%Tomar foto del dispositivo android
function take_image_droid_Callback(hObject, eventdata, handles)
% hObject    handle to take_image_droid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global carga
global imagen
global url
global camDroid
%Se guarda la foto de la variable URL
ss  = imread(url);
fh = image(ss);
ss  = imread(url);
set(fh,'CData',ss);
drawnow
%Se Guarda en la raiz del projecto
imwrite(ss,'foto2.jpg');
imagen=imread('foto2.jpg');
carga=1;
camDroid=0;

%Fase 1 Toma de colores RGB
% --- Executes on button press in r_button.
%Extracción color R
function r_button_Callback(hObject, eventdata, handles)
% hObject    handle to r_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global carga
global recortada
global r
global imagenNueva
%Se evalua que la imagen este recortada o no
%Se pone primero la carga, y si esta pasa ya no evalua la recortada
if carga  | recortada
    rgbImage=imagen;
    %Se obtiene el color R con 1
    redChannel = rgbImage(:, :, 1);
    %Se decodifica el color R
    z = zeros(size(rgbImage), class(rgbImage));
    redImage = z; redImage(:,:,1) = redChannel;
    subplot (handles.axes2), imshow(redImage), title("Filtro R");
    r=1;
    %Se guarda sobre otra imagen para no afectar el resultado de la primera
    imagenNueva=redImage;
else
    msgbox('No se ha detectado ninguna imagen1','Error','error')
end

% --- Executes on button press in g_button.
%Extraccion color G
function g_button_Callback(hObject, eventdata, handles)
% hObject    handle to g_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global carga
global recortada
global g
global imagenNueva
if carga  | recortada
    rgbImage=imagen;
    greenChannel = rgbImage(:, :, 2);
    %Se decodifica el color G
    z = zeros(size(rgbImage), class(rgbImage));
    greenImage = z; greenImage(:,:,2) = greenChannel;
    subplot (handles.axes2), imshow(greenImage), title("Filtro G");
    g=1;
    %Se guarda sobre otra imagen para no afectar el resultado de la primera
    imagenNueva=greenImage;
else
   msgbox('No se ha detectado ninguna imagen','Error','error')
end

% --- Executes on button press in b_button.
%Estraccion color B
function b_button_Callback(hObject, eventdata, handles)
% hObject    handle to b_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global carga
global recortada
global b
global imagenNueva
if carga | recortada
    rgbImage=imagen;
    blueChannel = rgbImage(:, :, 3);
    %Se decodifica el color B
    z = zeros(size(rgbImage), class(rgbImage));
    blueImage = z; blueImage(:,:,3) = blueChannel;
    subplot (handles.axes2), imshow(blueImage), title("Filtro B");
    b=1;
    %Se guarda sobre otra imagen para no afectar el resultado de la primera
    imagenNueva=blueImage;
else
   msgbox('No se ha detectado ninguna imagen','Error','error')
end


% --- Executes on button press in segmented_image.
function segmented_image_Callback(hObject, eventdata, handles)
% hObject    handle to segmented_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global imagenNueva
global carga
global recortada
if carga | recortada
    a=rgb2gray(imagenNueva);
    c=255-a;
    d=imfill(c,'holes');
    subplot (handles.axes2), imshow(d), title('Segmentación en escala de grises');
    imagenNueva=d;
else
    msgbox('No se ha detectado ninguna imagen','Error','error');
end

% --- Executes on button press in identify_fruit.
function identify_fruit_Callback(hObject, eventdata, handles)
% hObject    handle to identify_fruit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imagen
global imagenNueva
global carga
global recortada
if carga | recortada  
    Im=imagenNueva;
    %Im=im2double(Im);
    [r ,c ,p]=size(Im);
    %%Extracción de planos individuales de RGB de la imagen
    imR=squeeze (imagenNueva(:,:,1));
    imG=squeeze (imagenNueva(:,:,2));
    imB=squeeze (imagenNueva(:,:,3));

    %%Identificación de objetos
    imBinaryR = im2bw(imR, graythresh(imR));
    imBinaryG = im2bw(imG, graythresh(imG));
    imBinaryB = im2bw(imB, graythresh(imB));
    imBinary=imcomplement(imBinaryR&imBinaryG&imBinaryB);
    imshow(imBinary);

    %%Mofological Open
    se = strel('disk', 7);
    imClean = imopen(imBinary, se);

    %%Rellenar los huecos y limpiar los bordes
    imClean=imfill(imClean, 'holes');
    imClean=imclearborder(imClean);
    imshow(imClean);

    %%segmentar la imagen en niveles gris

    [labels, numLabels]=bwlabel(imClean);
    disp(['Numero de objetos detectados : ', num2str(numLabels)]);

    %%Inicializacion de matrices
    rLabel=zeros(r,c);
    gLabel=zeros(r,c);
    bLabel=zeros(r,c);

    %%color por region de cada label
    for i =1:numLabels
        rLabel(labels==i)=median(imR(labels==i));
        gLabel(labels==i)=median(imG(labels==i));
        bLabel(labels==i)=median(imB(labels==i));
    end

    imLabel = cat(3,rLabel, gLabel, bLabel);
    imshow(imLabel);
else
    msgbox('No se ha detectado ninguna imagen','Error','error')
end
