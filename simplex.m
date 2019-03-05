%**************************************************************************
%**************************************************************************
%                       HETEROGENEOUS-AWARE DATA PLACEMENT               **
%                                                                        ** 
%                             STUDENT: JACK MARQUEZ                      **
%**************************************************************************
%**************************************************************************

close all
clear all
clc

%% GENERACION DE LOS COEFICIENTES DE LA FUNCION OBJETIVO (matrizTiempos)
tiposAlm=3; 
velocidades=[2800 319 124];
espacioLimite=[200000 512000 512000];
load('15barchivos.mat')
ctdadArchivos=size(archivos,1);
matrizTiempos=archivos./velocidades;

%% PROCESO PARA ENCONTRAR SOLUCION USANDO intlinprog
coef=matrizTiempos';
coef= coef(:);
%Coeficientes de la funcion objetivo para 15 archivos y 3 tipos de
%almacenamiento
f=coef';
%se definen que todos son binarios
intcon=1:ctdadArchivos;

%% restricciones de desigualdad
%3 filas, una por cada tipo de almacenamiento
asign=zeros(3,45);%le coloco 30 de mas para tener las mismas 45 que la f
asign(1,1:15)=archivos';
asign(2,1:15)=archivos';
asign(3,1:15)=archivos';
%asign= [archivos' ;archivos'; archivos'];  


A=asign; 
b=espacioLimite';

%% restricciones de igualdad
%15 archivos en 3 tipos de almacenamiento
%%%Sera que se deben poner tambien 45 filas??
%%%%Si se ponen 45 columnas sale un error de: Root LP problem is unbounded
Aeq=ones(15,45);
beq=ones(15,1); 

%% limites de las variables enteras
% se restringen a ceros y unos por lo que son binarias.
lb = zeros(15,1);
ub = ones(15,1); % Enforces x is binary


%% Ejecucion de la solucion
%Call intlinprog.
x = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);



