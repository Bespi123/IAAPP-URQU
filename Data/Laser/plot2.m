clear 
clc
close all
laserData1=readmatrix('loge_y2021d268t101017');
laserData2=readmatrix('loge_y2021d268t103342');

%Initial variables
c = 299792458;      %Light velocity
dataTgtA = [];      %Data vector
dataTgtB = [];      %Data vector
dataTgtC = [];      %Data vector
rejTgtA = 0;        %Rejected observations
rejTgtB = 0;        %Rejected observations
rejTgtC = 0;       %Rejected observations

%Separe experiments acording to MimicoData
    for i=(1:1:length(laserData1))
        %Cut data that belongs to Target A
           %Remove rejected obs
           if ((laserData1(i,4)<4.511964231000000e+08)&&(laserData1(i,4)>2.786*10^(7)))
                   %distA = ((laserData1(i,4)*10^(-12) - 27865.413*10^(-9))*c)/2;
                   distA = ((laserData1(i,4)*10^(-12))*c)/2;
                   %distA = (laserData1(i,4));
                   dataTgtA = [dataTgtA; laserData1(i,:),distA];
           else
                   rejTgtA=rejTgtA+1;
           end
    end
    
    figure
    plot(dataTgtA(:,2)+dataTgtA(:,3)*10^(-12),dataTgtA(:,8),'r.')
    xlabel('Seconds of Days (s)')
    ylabel('Distance (m)')
    title("44")
    
    %Separe experiments acording to MimicoData
    for i=(1:1:length(laserData2))
        %Cut data that belongs to Target A
           %Remove rejected obs
           if ((laserData2(i,4)<4.511964231000000e+08)&&(laserData2(i,4)>2.7987e+7))
                   %distB = ((laserData1(i,4)*10^(-12) - 27865.413*10^(-9))*c)/2;
                   distB = ((laserData2(i,4)*10^(-12))*c)/2;
                   %distB = laserData2(i,4);
                   dataTgtB = [dataTgtB; laserData2(i,:),distB];
           else
                   rejTgtB=rejTgtB+1;
           end
    end
    figure
    plot(dataTgtB(:,2)+dataTgtB(:,3)*10^(-12),dataTgtB(:,8),'b.')
    xlabel('Seconds of Days (s)')
    ylabel('Distance (m)')

    [Omean1,Osdeviation1] = dataAnalitics(dataTgtA(:,8),1,1E5)
    [Omean2,Osdeviation2] = dataAnalitics(dataTgtB(:,8),1,1E5)