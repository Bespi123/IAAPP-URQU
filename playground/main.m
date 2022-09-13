%Clear and close files
clear, clc, close all

%% Read TRACK files
%%%Read files for minico test
taraGEOD = readmatrix('TRAK2040GEODtaraLC.csv');
tarbGEOD = readmatrix('TRAK2040GEODtarbLC.csv');
tarcGEOD = readmatrix('TRAK2040GEODtarcLC.csv');
aregGEOD = readmatrix('TRAK2040GEODAREGLC.csv');
taraNEU = readmatrix('TRAK2040NEUtaraLC.csv');
tarbNEU = readmatrix('TRAK2040NEUtarbLC.csv');
tarcNEU = readmatrix('TRAK2040NEUtarcLC.csv');

%% Processing parameters
%Height offset
hOffsetTarA = -1.77; %m (Trimble NETR9)
hOffsetTarB = -1.75; %m (SEP POLAR X5, LEIAR20)
hOffsetTarC = -7.80; %m (LEICA GR50, LEIAR20)
%AREL Coordinates
arellat = -16.46572;
arellong  = 288.50704;
arelalt  = 2489.5050;
% Read Laser Files
LaserPlots;
wgs84 = wgs84Ellipsoid;

%% Change GEOD to NEU coordinates with reference AREL
%%% Convert Track Data
[xNorthA,yEastA,zDownA] = geodetic2ned(taraGEOD(:,4),taraGEOD(:,5),...
    (taraGEOD(:,6)-hOffsetTarA),arellat,arellong,arelalt,wgs84);
[xNorthB,yEastB,zDownB] = geodetic2ned(tarbGEOD(:,4),tarbGEOD(:,5),...
    (tarbGEOD(:,6)-hOffsetTarB),arellat,arellong,arelalt,wgs84);
[xNorthC,yEastC,zDownC] = geodetic2ned(tarcGEOD(:,4),tarcGEOD(:,5),...
    (tarcGEOD(:,6)-hOffsetTarC),arellat,arellong,arelalt,wgs84);
%%% Convert Gammit Data
[xNorthAgam,yEastAgam,zDownAgam] = geodetic2ned(TARA_2021(:,13),TARA_2021(:,14),...
    (TARA_2021(:,15)-hOffsetTarA),arellat,arellong,arelalt,wgs84);
[xNorthBgam,yEastBgam,zDownBgam] = geodetic2ned(TARB_2021(:,13),TARB_2021(:,14),...
    (TARB_2021(:,15)-hOffsetTarA),arellat,arellong,arelalt,wgs84);
% To use gamit Data
%xNorthA=xNorthAgam;
%yEastA=yEastAgam;
%zDownA=zDownAgam;

% Calculate diferences in both methods
distA_gnss=(mean(xNorthA)^2+mean(yEastA)^2+mean(zDownA)^2)^(1/2);
distA_laser=mean(dataTgtA(:,8));
dR_a=distA_gnss-distA_laser;

distB_gnss=(mean(xNorthB)^2+mean(yEastB)^2+mean(zDownB)^2)^(1/2);
distB_laser=mean(dataTgtB(:,8));
dR_b=distB_gnss-distB_laser;

distC_gnss=(mean(xNorthC)^2+mean(yEastC)^2+mean(zDownC)^2)^(1/2);
distC_laser=mean(dataTgtC(:,8));
dR_c=distC_gnss-distC_laser;

figure()
diffN=mean(xNorthA)-mean(dataTgtA(:,9));
diffE=mean(yEastA)-mean(dataTgtA(:,10));
diffU=mean(-1*zDownA)-mean(dataTgtA(:,11));
aa=mean(xNorthAgam)*ones(1,181);
ab=mean(yEastAgam)*ones(1,181);
ac=mean(-1*zDownA)*ones(1,181);
subplot(3,1,1)
plot([xNorthA(1:181),dataTgtA(1:181,9),aa'],'.');
a = strcat('Target A; Reference:-16.46572, 288.50704, 2489.5050; Error: ',num2str(dR_a*1E2),' cm');
b = strcat('Samples; Error: ', num2str(diffN*1E2),' cm');
title(a);
ylabel('Nort Component (m)')
xlabel(b);
legend('GNSS','Laser','GAMIT')
grid on
subplot(3,1,2)
plot([yEastA(1:181),dataTgtA(1:181,10),ab'],'.');
b = strcat('Samples; Error: ', num2str(diffE*1E2),' cm');
ylabel('East Component (m)')
xlabel(b);
legend('GNSS','Laser')
grid on
subplot(3,1,3)
plot([-1*zDownA(1:181),dataTgtA(1:181,11),ac'],'.');
b = strcat('Samples; Error: ', num2str(diffU*1E2),' cm');
ylabel('Up Component (m)') 
xlabel(b);
legend('GNSS','Laser')
grid on

figure()
diffN=mean(xNorthB)-mean(dataTgtB(:,9));
diffE=mean(yEastB)-mean(dataTgtB(:,10));
diffU=mean(-1*zDownB)-mean(dataTgtB(:,11));
subplot(3,1,1)
plot([xNorthB(1:176),dataTgtB(1:176,9)],'.');
a = strcat('Target B; Reference:-16.46572, 288.50704, 2489.5050; Error: ',num2str(dR_b*1E2),' cm');
b = strcat('Samples; Error: ', num2str(diffN*1E2),' cm');
xlabel(b);
title(a);
ylabel('Nort Component (m)')
legend('GNSS','Laser')
grid on
subplot(3,1,2)
plot([yEastB(1:176),dataTgtB(1:176,10)],'.');
b = strcat('Samples; Error: ', num2str(diffE*1E2),' cm');
xlabel(b);
ylabel('East Component (m)')
legend('GNSS','Laser')
grid on
subplot(3,1,3)
plot([-1*zDownB(1:176),dataTgtB(1:176,11)],'.');
ylabel('Up Component (m)')
legend('GNSS','Laser')
b = strcat('Samples; Error: ', num2str(diffU*1E2),' cm');
xlabel(b);
grid on

figure()
diffN=mean(xNorthC)-mean(dataTgtC(:,9));
diffE=mean(yEastC)-mean(dataTgtC(:,10));
diffU=mean(-1*zDownC)-mean(dataTgtC(:,11));
subplot(3,1,1)
plot([xNorthC(1:181),dataTgtC(1:181,9)],'.');
a = strcat('Target C; Reference:-16.46572, 288.50704, 2489.5050; Error: ',num2str(dR_c*1E2),' cm');
title(a);
b = strcat('Samples; Error: ', num2str(diffN*1E2),' cm');
xlabel(b);
ylabel('Nort Component (m)')
legend('GNSS','Laser')
grid on
subplot(3,1,2)
plot([yEastC(1:181),dataTgtC(1:181,10)],'.');
ylabel('East Component (m)')
b = strcat('Samples; Error: ', num2str(diffE*1E2),' cm');
xlabel(b);
legend('GNSS','Laser')
grid on
subplot(3,1,3)
plot([-1*zDownC(1:181),dataTgtC(1:181,11)],'.');
b = strcat('Samples; Error: ', num2str(diffU*1E2),' cm');
xlabel(b);
ylabel('Up Component (m)')
legend('GNSS','Laser')
grid on

disp('HOla')
aa = (mean(dataTgtC(:,9))^2+mean(dataTgtC(:,10))^2+mean(dataTgtC(:,11))^2)^(1/2)
dg=mean(dataTgtC(:,8))
ss= (diffN^2+diffE^2+diffU^2)^(1/2)

[latTarA,lonTarA,hTarA] = ned2geodetic(mean(dataTgtA(:,9)),mean(dataTgtA(:,10)),-1*mean(dataTgtA(:,9)),-16.46572,288.50704,2489.5050,wgs84);
[latTarB,lonTarB,hTarB] = ned2geodetic(mean(dataTgtB(:,9)),mean(dataTgtB(:,10)),-1*mean(dataTgtB(:,9)),-16.46572,288.50704,2489.5050,wgs84);
[latTarC,lonTarC,hTarC] = ned2geodetic(mean(dataTgtC(:,9)),mean(dataTgtC(:,10)),-1*mean(dataTgtC(:,9)),-16.46572,288.50704,2489.5050,wgs84);

figure()
geoplot([mean(taraGEOD(:,4)),mean(tarbGEOD(:,4)),mean(tarcGEOD(:,4))],...
    [mean(taraGEOD(1:176,5)),mean(tarbGEOD(1:176,5)),mean(tarcGEOD(1:176,5)),],...
    'g.');
geobasemap satellite
hold on
geoplot([latTarA,latTarB,latTarC],[lonTarA+360,lonTarB+360,lonTarC+360],'ro')

rg=mean((xNorthC.^2+yEastC.^2+zDownC.^2).^(1/2))
rl=mean(dataTgtC(:,8))
thetag=mean(asin(-1*zDownC/rg))
%thetal=acos(rg/rl*cos(thetag))*180/pi
thetal=asin(rg/rl*sin(thetag))*180/pi
%thetal=asin(18E-2/rl+rg/rl*sin(thetag))*180/pi
%theta11=acos(r2/r1*cos(anglesTarA(2)))*180/pi

% % Perform data Analitics
% % Analize 2001 data
% [mean,Sdeviation] = dataAnalitics(AREQ_2001(:,18),1,1000);
% plotNEU(AREQ_2001,132,0,0,'AREQ');
% plotNEU(AREQ_2001,132,1,0.003,'AREQ');
% 
% % % Analize 2021 data
%  plotNEU(MTPI_2021_att6,70,0,0,'MTPI');
%  plotNEU(AREQ_2021_att6,70,0,0,'AREQ');
%  plotNEU(AREG_2021_att6,70,0,0,'AREG');
%  plotNEU(LPGS_2021_att6,70,1,0.008,'LPGS');
%  plotNEU(BOGT_2021_att6,70,0,0,'BOGT');
%  plotNEU(BRAZ_2021_att6,70,0,0,'BRAZ');
% % plotNEU(MTPI_2021_att3,70,1,0.03);
% 
% plotNEU(MTPI_2021_att2,70,0,0);
% plotNEU(MTPI_2021_att2,70,1,0.03);
% plotNEU(MTPI_2021_att1,70,0,0);

% plotNEU(MTPI_2021_att4,70,0,0); 
% 
% plotNEU(TARA_2021,70,0,0);
% plotNEU(TARB_2021,70,0,0);
% 
% % Analize Track data
% % [mean,Sdeviation] = dataAnalitics(taraNEU(:,7),1,100);
% plotNEU(taraNEU,0,0,0,'Tar A');
% plotNEU(tarbNEU,0,0,0);
% plotNEU(tarcNEU,0,0,0);
% 
% %[mean,Sdeviation] = dataAnalitics(MTPI_2021(:,15),1,1000)
%Calculus