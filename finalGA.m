close all
clear all
clc
%% variables de ambiente
limiteArchivos=200000;
ctdadArchivos=50;
ctdadPoblacion=10;
probCross=0.9;

%% matrizz de tiempos
velocidades=[6600 2320 267 120];
espacioLimite=[256000 1000000 4000000 6000000];
limiteEspacio= sum(espacioLimite);
espacioTotal=20000000;
while(espacioTotal>limiteEspacio)
    archivos = randperm(limiteArchivos,ctdadArchivos);
    archivos=archivos';
    espacioTotal=sum(archivos);
end
matrizTiempos=archivos./velocidades;

%% CREACION DE LA POBLACION


poblacion=zeros(ctdadPoblacion,ctdadArchivos*4);

for i=1:ctdadPoblacion
    for j=1:ctdadArchivos
        a=4*j-3;
        b=3; 
        %va desde a hasta la suma de a + b
        asignacion=round(b*rand+a);
        poblacion(i,asignacion)=1;
    end
end

generacion=1;

%while(generacion<=200)
    %% EVALUACION DEL CROMOSOMA

    for i=1:ctdadPoblacion
            cromosoma=vec2mat(poblacion(i,:),4);
            objectiv(i)=sum(sum(matrizTiempos.*cromosoma)); 
    end

    %% crossover
    %plot(objectiv);
    if(rand <= probCross)
        minimo=min(objectiv);
        posMejor1=find(objectiv==minimo(1));
        valorMejor1=min(objectiv);
        %guardando el mejor de cada generacion
        mejores(generacion)=valorMejor1;
        objectiv(1,posMejor1)=valorMejor1*2;%Definir un valor grande para que no sea tomado en cuenta
        posMejor2=find(objectiv==(min(objectiv)));

        padre1=poblacion(posMejor1,:);
        padre2=poblacion(posMejor2,:);

        %Crossover
        %1 Punto
        correcto=0;
        while(correcto==0)        
            xcruce=floor((ctdadArchivos*4)*rand+1);
            xcruce1=floor((ctdadArchivos*4)*rand+1);
            if(xcruce<xcruce1)
                if(mod(xcruce,4)==1 && mod(xcruce1,4)==0) 
                    poblacion(posMejor1(1),xcruce:xcruce1) = poblacion(posMejor2(1),xcruce:xcruce1);
                    poblacion(posMejor2(1),xcruce:xcruce1) = padre1(xcruce:xcruce1);
                    correcto=1;
                end
            else
                if(mod(xcruce1,4)==1 && mod(xcruce,4)==0) 
                    poblacion(posMejor1(1),xcruce1:xcruce) = poblacion(posMejor2(1),xcruce1:xcruce);
                    poblacion(posMejor2(1),xcruce1:xcruce) = padre1(xcruce1:xcruce);
                    correcto=1;
                end
             end
        end
    end


    %% mutacion
    if(rand <= 0.1)
        xMutacion=floor((ctdadArchivos*4)*rand+1);
            if(poblacion(posMejor1,xMutacion)==0)
                %quitar el otro 1 del rango
                j=(xMutacion+3)/4;
                a=4*j-3;
                b=j*4;                
                poblacion(posMejor1,a:b)=0;               
                poblacion(posMejor1,xMutacion) = 1;
             else
                poblacion(posMejor1,xMutacion) = 0;
            end

            xMutacion=floor((ctdadArchivos*4)*rand+1);
            if(poblacion(posMejor2,xMutacion)==0)
                %quitar el otro 1 del rango de 4
                j=(xMutacion+3)/4;
                a=4*j-3;
                b=j*4;
                poblacion(posMejor2,a:b)=0;
                poblacion(posMejor2,xMutacion) = 1;
            else
                poblacion(posMejor2,xMutacion) = 0;
            end        
    end

    generacion=generacion+1;

%end
plot(mejores);


