
%Read data from csv files
laserData=readmatrix('loge_y2021d215t171131.csv');
MimicoDat=readmatrix('MimicoDat.csv');
a=size(MimicoDat);
%Initial variables
dataTgtA = [];      %Data vector
dataTgtB = [];      %Data vector
dataTgtC = [];      %Data vector
rejTgtA = 0;        %Rejected observations
rejTgtB = 0;        %Rejected observations
rejTgtC = 0;       %Rejected observations

%Separe experiments acording to MimicoData
for j=1:1:a(1)
    if (MimicoDat(j,3)==1)
        for i=(1:1:length(laserData))
            %Cut data that belongs to Target A
            if((MimicoDat(j,4) <= laserData(i,2))&&(MimicoDat(j,5) >= laserData(i,2)))
               %Remove rejected obs
               if ((laserData(i,4)<3*10^(6))&&(laserData(i,4)>7.459*10^(5)))
                   distA = ((laserData(i,4)*10^(-12) - MimicoDat(j,13)*10^(-9))*c)/2;
                   dataTgtA = [dataTgtA; [laserData(i,:),distA]];
               else
                   rejTgtA=rejTgtA+1;
               end
            end
        end
    end
    if (MimicoDat(j,3)==2)
        for i=1:1:length(laserData)
            if(MimicoDat(j,4)<=laserData(i,2)&&MimicoDat(j,5)>=laserData(i,2))
               %Remove rejected obs
               if ((laserData(i,4)<3*10^(6))&&(laserData(i,4)>7.459*10^(5)))
                   distB = ((laserData(i,4)*10^(-12) - MimicoDat(j,13)*10^(-9))*c)/2;
                   dataTgtB = [dataTgtB; [laserData(i,:),distB]];
               else
                   rejTgtB=rejTgtB+1;
               end
            end
        end
    end
    if (MimicoDat(j,3)==3)
        for i=1:1:length(laserData)
            if(MimicoDat(j,4)<=laserData(i,2)&&MimicoDat(j,5)>=laserData(i,2))
                %Remove rejected obs
               if ((laserData(i,4)<3*10^(6))&&(laserData(i,4)>2.862*10^(6)))
                   distC = ((laserData(i,4)*10^(-12) - MimicoDat(j,13)*10^(-9))*c)/2;
                   dataTgtC = [dataTgtC; [laserData(i,:),distC]];
               else
                   rejTgtC=rejTgtC+1;
               end
            end
        end
    end
end

%Decompose measures in NEU coordinates
 %Angles [AZIMUTH    ELEVATION]
 %anglesTarA = [10.230,-1.810]*pi/180; %rad
 %anglesTarA = [11.511181484321838,-0.907]*pi/180; %rad -0.900
 %anglesTarA = [11.511, 0.0489]*pi/180; %rad
 anglesTarA = [11.511181484321838,-1.076]*pi/180; %rad
 %anglesTarB = [48.167,-1.265]*pi/180; %rad
 anglesTarB = [48.110,0.800]*pi/180; %rad
 %anglesTarC = [132.063,0.818]*pi/180; %rad
 anglesTarC = [133.426, 1.962]*pi/180; %rad
  
%ADD NEU coordinates
dataTgtA = [dataTgtA,dataTgtA(:,8)*cos(anglesTarA(2))*cos(anglesTarA(1))...
    dataTgtA(:,8)*cos(anglesTarA(2))*sin(anglesTarA(1)),...
    dataTgtA(:,8)*sin(anglesTarA(2))];
dataTgtB = [dataTgtB,dataTgtB(:,8)*cos(anglesTarB(2))*cos(anglesTarB(1))...
    dataTgtB(:,8)*cos(anglesTarB(2))*sin(anglesTarB(1)),...
    dataTgtB(:,8)*sin(anglesTarB(2))];
dataTgtC = [dataTgtC,dataTgtC(:,8)*cos(anglesTarC(2))*cos(anglesTarC(1))...
    dataTgtC(:,8)*cos(anglesTarC(2))*sin(anglesTarC(1)),...
    dataTgtC(:,8)*sin(anglesTarC(2))];


figure()
plot(dataTgtA(:,2)+dataTgtA(:,3)*10^(-12),dataTgtA(:,4),'r.');
hold on
plot(dataTgtB(:,2)+dataTgtB(:,3)*10^(-12),dataTgtB(:,4),'g.');
plot(dataTgtC(:,2)+dataTgtC(:,3)*10^(-12),dataTgtC(:,4),'b.');
title('Laser Data (TLRS-3)');
xlabel('Seconds of Day(s)')
ylabel('Time diference(ps)')
grid on

figure()
plot(dataTgtA(:,2)+dataTgtA(:,3)*10^(-12),dataTgtA(:,8),'r.');
hold on
plot(dataTgtB(:,2)+dataTgtB(:,3)*10^(-12),dataTgtB(:,8),'g.');
plot(dataTgtC(:,2)+dataTgtC(:,3)*10^(-12),dataTgtC(:,8),'b.');
title('Laser Measurements (TLRS-3)');
xlabel('Seconds of Day(s)')
ylabel('Distance (m)')
grid on

figure()
subplot(3,1,1)
plot(dataTgtA(:,2)+dataTgtA(:,3)*10^(-12),dataTgtA(:,9),'r.');
title('Target A                Reference:-16.46572, 288.50704, 2489.5050');
ylabel('Nort Component (m)')
grid on
subplot(3,1,2)
plot(dataTgtA(:,2)+dataTgtA(:,3)*10^(-12),dataTgtA(:,10),'r.');
ylabel('East Component (m)')
grid on
subplot(3,1,3)
plot(dataTgtA(:,2)+dataTgtA(:,3)*10^(-12),dataTgtA(:,11),'r.');
ylabel('Up Component (m)') 
xlabel('Seconds of Day(s)')
grid on

figure()
subplot(3,1,1)
plot(dataTgtB(:,2)+dataTgtB(:,3)*10^(-12),dataTgtB(:,9),'r.');
title('Target B                Reference:-16.46572, 288.50704, 2489.5050');
ylabel('Nort Component (m)')
grid on
subplot(3,1,2)
plot(dataTgtB(:,2)+dataTgtB(:,3)*10^(-12),dataTgtB(:,10),'r.');
ylabel('East Component (m)')
grid on
subplot(3,1,3)
plot(dataTgtB(:,2)+dataTgtB(:,3)*10^(-12),dataTgtB(:,11),'r.');
ylabel('Up Component (m)') 
xlabel('Seconds of Day(s)')
grid on

figure()
subplot(3,1,1)
plot(dataTgtC(:,2)+dataTgtC(:,3)*10^(-12),dataTgtC(:,9),'r.');
title('Target C                Reference:-16.46572, 288.50704, 2489.5050');
ylabel('Nort Component (m)')
grid on
subplot(3,1,2)
plot(dataTgtC(:,2)+dataTgtC(:,3)*10^(-12),dataTgtC(:,10),'r.');
ylabel('East Component (m)')
grid on
subplot(3,1,3)
plot(dataTgtC(:,2)+dataTgtC(:,3)*10^(-12),dataTgtC(:,11),'r.');
ylabel('Up Component (m)') 
xlabel('Seconds of Day(s)')
grid on


