%Clear and close files
clear, clc, close all

%% Read TRACK files
%%%Read files for minico test
taraGEOD = readTrack('TRAK2040GEODtaraLC.csv');
tarbGEOD = readTrack('TRAK2040GEODtarbLC.csv');
tarcGEOD = readTrack('TRAK2040GEODtarcLC.csv');
aregGEOD = readTrack('TRAK2040GEODAREGLC.csv');
taraNEU = readTrack('TRAK2040NEUtaraLC.csv');
tarbNEU = readTrack('TRAK2040NEUtarbLC.csv');
tarcNEU = readTrack('TRAK2040NEUtarcLC.csv');

%% Read Gamit files
tara = ReadGamitFiles('TARA.iaa.orbit_igs14.pos');
tarb = ReadGamitFiles('TARB.iaa.orbit_igs14.pos');

%% Read Laser files
%Read .sm files
smFiles = dir('Data/Laser/*.sm');
for i=1:length(smFiles)
    minico(i)=readTTsmfiles(smFiles(i).name);
end


%Read Laser data
 laserData=readLaserData('loge_y2021d215t171131');

 %% Processing parameters
% Angles offset [az,elev]
 %offset.offanglesTarA = [1.2812,0.428]*pi/180; %rad
 %offset.offanglesTarA = [1.2812,6.9543]*pi/180; %rad
 offset.offanglesTarA = [1.3117, 2.3533]*pi/180; %rad  (for Gamit)
 %offset.offanglesTarA = [1.2911,1.8125]*pi/180; %rad (for Track)
 %offset.offanglesTarB = [-0.0570,1.2452]*pi/180; %rad  1.2646
 %offset.offanglesTarB = [-0.1416,2.5480]*pi/180; %rad (for Gamit)
 %offset.offanglesTarB = [-0.0840,1.2646]*pi/180; %rad (for Track)
 offset.offanglesTarB = [-0.1413,2.5332]*pi/180; %rad  
 %offset.offanglesTarC = [1.3630, 1.1306]*pi/180; %rad
 %offset.offanglesTarC = [1.3630, 0]*pi/180; %rad
 %offset.offanglesTarC = [1.3373, 1.7699]*pi/180; %rad
 %offset.offanglesTarC = [1.3373, 0.7291]*pi/180; %rad
 offset.offanglesTarC = [1.3373, 0.7291]*pi/180; %rad


% Height offset (Teorically must be diference between GNSS and SLR)
 %offset.hOffsetTarA = 166.0939*1E-2; %m (Trimble NETR9)
 %offset.hOffsetTarB = 174.8902*1E-2; %m (SEP POLAR X5, LEIAR20)
 offset.hOffsetTarA = 2.2500; %m (Trimble NETR9)
 %offset.hOffsetTarB = 2.0500; %m (Trimble NETR9)
 %offset.hOffsetTarA = 0; %m (Trimble NETR9)
 offset.hOffsetTarB = 2.0500; %m (Trimble NETR9)
 offset.hOffsetTarC = 2.2500; %m (LEICA GR50, LEIAR20) 
% Estation Eccentricity
% https://cddis.nasa.gov/archive/slr/slrocc/ecc_une.snx
 %offset.ecc_une = [2.6790,0.0140,-0.0020];
 offset.ecc_une = [2.6790,0.000,0.000];
%Phisical parameters 
 wgs84 = wgs84Ellipsoid;

%% Get minico results
[datatgtA,datatgtB,datatgtC] = minicoResults(minico,offset,laserData,0.20,0);
%% Change reference Frame from AREG to AREL
% % Track results
% arelRef.track.ENUtaraArel=lla2enu([taraGEOD.latitude,taraGEOD.longitude-360,taraGEOD.height], ...
%     [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
% arelRef.track.ENUtarbArel=lla2enu([tarbGEOD.latitude,tarbGEOD.longitude-360,tarbGEOD.height], ...
%     [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
% arelRef.track.ENUtarcArel=lla2enu([tarcGEOD.latitude,tarcGEOD.longitude-360,tarcGEOD.height], ...
%     [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
% % GAMIT results
arelRef.track.ENUtaraArel=lla2enu([tara.Nlat,tara.Elong-360,tara.HeightUp], ...
    [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
arelRef.track.ENUtarbArel=lla2enu([tarb.Nlat,tarb.Elong-360,tarb.HeightUp], ...
    [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
arelRef.track.ENUtarcArel=lla2enu([tarcGEOD.latitude,tarcGEOD.longitude-360,tarcGEOD.height], ...
    [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
% Add offsets
% arelRef.track.ENUtaraArel(:,3)=-(arelRef.track.ENUtaraArel(:,3)+offset.hOffsetTarA)+offset.ecc_une(1);
% arelRef.track.ENUtarbArel(:,3)=-(arelRef.track.ENUtarbArel(:,3)+offset.hOffsetTarB)+offset.ecc_une(1);
% arelRef.track.ENUtarcArel(:,3)=-(arelRef.track.ENUtarcArel(:,3)+offset.hOffsetTarC)+offset.ecc_une(1);
% arelRef.track.ENUtaraArel(:,1)=-arelRef.track.ENUtaraArel(:,1)+offset.ecc_une(3);
% arelRef.track.ENUtarbArel(:,1)=-arelRef.track.ENUtarbArel(:,1)+offset.ecc_une(3);
% arelRef.track.ENUtarcArel(:,1)=-arelRef.track.ENUtarcArel(:,1)+offset.ecc_une(3);
% arelRef.track.ENUtaraArel(:,2)=-arelRef.track.ENUtaraArel(:,2)+offset.ecc_une(2);
% arelRef.track.ENUtarbArel(:,2)=-arelRef.track.ENUtarbArel(:,2)+offset.ecc_une(2);
% arelRef.track.ENUtarcArel(:,2)=-arelRef.track.ENUtarcArel(:,2)+offset.ecc_une(2);
 arelRef.track.ENUtaraArel(:,3)=(arelRef.track.ENUtaraArel(:,3)+offset.hOffsetTarA)+offset.ecc_une(1);
 arelRef.track.ENUtarbArel(:,3)=(arelRef.track.ENUtarbArel(:,3)+offset.hOffsetTarB)+offset.ecc_une(1);
 arelRef.track.ENUtarcArel(:,3)=(arelRef.track.ENUtarcArel(:,3)+offset.hOffsetTarC)+offset.ecc_une(1);
 arelRef.track.ENUtaraArel(:,1)=arelRef.track.ENUtaraArel(:,1)+offset.ecc_une(3);
 arelRef.track.ENUtarbArel(:,1)=arelRef.track.ENUtarbArel(:,1)+offset.ecc_une(3);
 arelRef.track.ENUtarcArel(:,1)=arelRef.track.ENUtarcArel(:,1)+offset.ecc_une(3);
 arelRef.track.ENUtaraArel(:,2)=arelRef.track.ENUtaraArel(:,2)+offset.ecc_une(2);
 arelRef.track.ENUtarbArel(:,2)=arelRef.track.ENUtarbArel(:,2)+offset.ecc_une(2);
 arelRef.track.ENUtarcArel(:,2)=arelRef.track.ENUtarcArel(:,2)+offset.ecc_une(2);

% Gamit results
arelRef.gamit.ENUtaraArel=lla2enu([tara.Nlat,tara.Elong-360,tara.HeightUp], ...
    [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
arelRef.gamit.ENUtarbArel=lla2enu([tarb.Nlat,tarb.Elong-360,tarb.HeightUp], ...
    [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
% Calculate distances
disp('Target A distance:');
disp(norm(mean(arelRef.gamit.ENUtaraArel)));
disp('Target B distance:');
disp(norm(mean(arelRef.gamit.ENUtarbArel)));

%% Get geodetic coordinates from AREL measurements
[datatgtA.lat,datatgtA.lon,datatgtA.h] = enu2geodetic(mean(datatgtA.dE),mean(datatgtA.dN),mean(datatgtA.dU), ...
    minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3),wgs84);
[datatgtB.lat,datatgtB.lon,datatgtB.h] = enu2geodetic(mean(datatgtB.dE),mean(datatgtB.dN),mean(datatgtB.dU), ...
    minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3),wgs84);
[datatgtC.lat,datatgtC.lon,datatgtC.h] = enu2geodetic(mean(datatgtC.dE),mean(datatgtC.dN),mean(datatgtC.dU), ...
    minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3),wgs84);

%% Calculus
rg=mean((arelRef.track.ENUtaraArel(:,1).^2+arelRef.track.ENUtaraArel(:,2).^2+arelRef.track.ENUtaraArel(:,3).^2).^(1/2));
rl=mean(datatgtA.distFilt);
thetag=mean(asin(arelRef.track.ENUtaraArel(:,3)/rg));
%thetal=acos(rg/rl*cos(thetag))*180/pi
%thetal=asin(rg/rl*sin(thetag))*180/pi
thetal=asin(180*1E-2/rl+rg/rl*sin(thetag))*180/pi;
%theta11=acos(r2/r1*cos(anglesTarA(2)))*180/pi
%Calculate offset
off=thetal-minico(1).targets.targetA.elevation*180/pi
off2=minico(1).targets.targetA.elevation*180/pi-off

%% Plots
% Plot minico Test data 
figure()
    x= [datatgtA.sod(1:5073)+datatgtA.reedswithc(1:5073)*1E-12, ...
        datatgtB.sod(1:5073)+datatgtB.reedswithc(1:5073)*1E-12, ...
        datatgtC.sod(1:5073)+datatgtC.reedswithc(1:5073)*1E-12, ...
        ];
    y=[datatgtA.dist(1:5073),datatgtB.dist(1:5073),datatgtC.dist(1:5073)];
    breakplot(x,y,106.02,423.356,105.955,423.41,'RPatch',20E4);
    title('Minico Test: Laser Data (TLRS-3)');
    xlabel('Seconds of Day(s)')
    ylabel('Distance (m)')
    legend('Target A','Target B','Target C','Location','northwest','FontSize',12)
    legend(strcat('TargetA: (mean:',num2str(datatgtA.mean,'%.3f'),'m, RMS:',num2str(datatgtA.Sr*1E3,'%.1f'),'mm)'), ...
     strcat('TargetB: (mean:',num2str(datatgtB.mean,'%.3f'),'m, RMS:',num2str(datatgtB.Sr*1E3,'%.1f'),'mm)'), ...
     strcat('TargetC: (mean:',num2str(datatgtC.mean,'%.3f'),'m, RMS:',num2str(datatgtC.Sr*1E3,'%.1f'),'mm)'),...
     'Location','northwest','FontSize',12,'NumColumns',3);
    grid on

%Comparisson between GNSS and Laser measurements
%%%Target A
figure()
diffN=mean(arelRef.track.ENUtaraArel(:,2))-mean(datatgtA.dN);
diffE=mean(arelRef.track.ENUtaraArel(:,1))-mean(datatgtA.dE);
diffU=mean(arelRef.track.ENUtaraArel(:,3))-mean(datatgtA.dU);
dR_a=norm([diffN,diffE,diffU]);

dN=subplot(3,1,1);
    p1=plot(arelRef.track.ENUtaraArel(:,2),'r.');
    hold on
    p2=plot(datatgtA.dN(1:length(arelRef.track.ENUtaraArel(:,2))),'b.');
    a = strcat('Target A; Reference:-16.46572, 288.50704, 2489.5050; Error: ',num2str(dR_a*1E2),' cm', ...
        '; Length Error: ',num2str((mean(datatgtA.distFilt)-norm(arelRef.track.ENUtaraArel(1,:)))*1E2),'cm');
    b = strcat('Samples; Error: ', num2str(diffN*1E2),' cm');
    title(a);
    ylabel('Nort Component (m)')
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
dE=subplot(3,1,2);
    p1=plot(arelRef.track.ENUtaraArel(:,1),'r.');
    hold on
    p2=plot(datatgtA.dE(1:length(arelRef.track.ENUtaraArel(:,1))),'b.');
    b = strcat('Samples; Error: ', num2str(diffE*1E2),' cm');
    ylabel('East Component (m)')
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
dU=subplot(3,1,3);
    p1=plot(arelRef.track.ENUtaraArel(:,3),'r.');
    hold on
    p2=plot(datatgtA.dU(1:length(arelRef.track.ENUtaraArel(:,3))),'b.');
    b = strcat('Samples; Error: ', num2str(diffU*1E2),' cm');
    ylabel('Up Component (m)') 
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
 linkaxes([dE,dN,dU],'x');
%%%Target B
figure()
diffN=mean(arelRef.track.ENUtarbArel(:,2))-mean(datatgtB.dN);
diffE=mean(arelRef.track.ENUtarbArel(:,1))-mean(datatgtB.dE);
diffU=mean(arelRef.track.ENUtarbArel(:,3))-mean(datatgtB.dU);
dR_a=norm([diffN,diffE,diffU]);
dN=subplot(3,1,1);
    p1=plot(arelRef.track.ENUtarbArel(:,2),'r.');
    hold on
    p2=plot(datatgtB.dN(1:length(arelRef.track.ENUtarbArel(:,2))),'b.');
    a = strcat('Target B; Reference:-16.46572, 288.50704, 2489.5050; Error: ',num2str(dR_a*1E2),' cm');
    b = strcat('Samples; Error: ', num2str(diffN*1E2),' cm');
    title(a);
    ylabel('Nort Component (m)')
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
dE=subplot(3,1,2);
    p1=plot(arelRef.track.ENUtarbArel(:,1),'r.');
    hold on
    p2=plot(datatgtB.dE(1:length(arelRef.track.ENUtarbArel(:,1))),'b.');
    b = strcat('Samples; Error: ', num2str(diffE*1E2),' cm');
    ylabel('East Component (m)')
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
dU=subplot(3,1,3);
    p1=plot(arelRef.track.ENUtarbArel(:,3),'r.');
    hold on
    p2=plot(datatgtB.dU(1:length(arelRef.track.ENUtarbArel(:,3))),'b.');
    b = strcat('Samples; Error: ', num2str(diffU*1E2),' cm');
    ylabel('Up Component (m)') 
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
 linkaxes([dE,dN,dU],'x');
%%%Target C
figure()
diffN=mean(arelRef.track.ENUtarcArel(:,2))-mean(datatgtC.dN);
diffE=mean(arelRef.track.ENUtarcArel(:,1))-mean(datatgtC.dE);
diffU=mean(arelRef.track.ENUtarcArel(:,3))-mean(datatgtC.dU);
dR_a=norm([diffN,diffE,diffU]);
dN=subplot(3,1,1);
    p1=plot(arelRef.track.ENUtarcArel(:,2),'r.');
    hold on
    p2=plot(datatgtC.dN(1:length(arelRef.track.ENUtarcArel(:,2))),'b.');
    a = strcat('Target C; Reference:-16.46572, 288.50704, 2489.5050; Error: ',num2str(dR_a*1E2),' cm');
    b = strcat('Samples; Error: ', num2str(diffN*1E2),' cm');
    title(a);
    ylabel('Nort Component (m)')
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
dE=subplot(3,1,2);
    p1=plot(arelRef.track.ENUtarcArel(:,1),'r.');
    hold on
    p2=plot(datatgtC.dE(1:length(arelRef.track.ENUtarcArel(:,1))),'b.');
    b = strcat('Samples; Error: ', num2str(diffE*1E2),' cm');
    ylabel('East Component (m)')
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
dU=subplot(3,1,3);
    p1=plot(arelRef.track.ENUtarcArel(:,3),'r.');
    hold on
    p2=plot(datatgtC.dU(1:length(arelRef.track.ENUtarcArel(:,3))),'b.');
    b = strcat('Samples; Error: ', num2str(diffU*1E2),' cm');
    ylabel('Up Component (m)') 
    xlabel(b);
    legend([p1,p2],{'GNSS','Laser'});
    grid on
 linkaxes([dE,dN,dU],'x');


figure()
geoplot([mean(taraGEOD.latitude),mean(tarbGEOD.latitude),mean(tarcGEOD.latitude)],...
    [mean(taraGEOD.longitude),mean(tarbGEOD.longitude),mean(tarcGEOD.longitude)],...
    'g.');
geobasemap satellite
hold on
geoplot([datatgtA.lat,datatgtB.lat,datatgtC.lat],[datatgtA.lon+360,datatgtB.lon+360,datatgtC.lon+360],'ro')
geoplot([mean(tara.Nlat),mean(tarb.Nlat)],...
    [mean(tara.Elong),mean(tarb.Elong)],...
    'b*');

function site = readTrack(file)
    data = readmatrix(file);
    [a,b] = size(data);
    if (b==18)
        %disp('GEOD data detected');
        site.year=data(:,1);
        site.doy=data(:,2);
        site.seconds=data(:,3);
        site.latitude=data(:,4);
        site.longitude=data(:,5);
        site.height=data(:,6);
        site.sigN=data(:,7);
        site.sigN=data(:,8);
        site.sigE=data(:,9);
        site.sigH=data(:,10);
        site.michi=data(:,11);
        site.atm=data(:,12);
        site.sigAtm=data(:,13);
        site.FracDoy=data(:,14);
        site.Epoch=data(:,15);
        site.BF=data(:,16);
        site.Not=data(:,17);
    elseif (b==22)
        %disp('NEU data detected');
        site.year=data(:,1);
        site.month=data(:,2);
        site.day=data(:,3);
        site.hour=data(:,4);
        site.min=data(:,5);
        site.secconds=data(:,6);
        site.dN=data(:,7);
        site.sigN=data(:,8);
        site.dE=data(:,9);
        site.sigE=data(:,10);
        site.dU=data(:,11);
        site.sigU=data(:,12);
        site.RMS=data(:,13);
        site.michi=data(:,14);
        site.atm=data(:,15);
        site.sigAtm=data(:,16);
        site.fracDoy=data(:,17);
        site.epoch=data(:,18);
        site.michiB=data(:,19);
        site.no=data(:,20);
        site.tF=data(:,21);
        site.Rho_UA=data(:,22);
    else
        disp('No track data detected');
        site='Error';
    end
end

function site = readLaserData(fileName)
   data = readmatrix(fileName);
   site.doy = data(:,1);
   site.sod = data(:,2);
   site.reedswithc = data(:,3);
   site.time = data(:,4);
end

function [datatgtA,datatgtB,datatgtC] = minicoResults(minico,offset,laserData,Srange,plotStadistics)
    for i = 1:length(minico)
        switch mod(i,3)
            case 1
                tgt='A';
            case 2
                tgt='B';
            case 0
                tgt='C';
            otherwise
                break;
        end
        a(i)= processData(laserData,minico(i).targets,Srange,minico(i).delay, ...
            minico(i).startTimeSod,minico(i).stopTimeSod,tgt); 
    end
    %Combine Readed data
    tgtA=[];
    tgtB=[];
    tgtC=[];
    for i=1:length(a)
        b=struct2table(a(i));
        switch mod(i,3)
            case 1
                tgtA=[tgtA;b];
            case 2
                tgtB=[tgtB;b];
            case 0
                tgtC=[tgtC;b];
            otherwise
                break;
        end
    end
    %Transform to struct again
    datatgtA = table2struct(tgtA,"ToScalar",true);
    datatgtB = table2struct(tgtB,"ToScalar",true);
    datatgtC = table2struct(tgtC,"ToScalar",true);
    %Perform stadistical Analisys;
    [datatgtA.mean,datatgtA.Sr] = dataAnalitics(datatgtA.dist,plotStadistics,1000);
    [datatgtB.mean,datatgtB.Sr] = dataAnalitics(datatgtB.dist,plotStadistics,1000);
    [datatgtC.mean,datatgtC.Sr] = dataAnalitics(datatgtC.dist,plotStadistics,1000);
    
    %Filter data each 10 measures
    samples = 10;
    coeff = ones(1,samples)/samples;
    datatgtA.distFilt = filter(coeff, 1, datatgtA.dist);
    datatgtB.distFilt = filter(coeff, 1, datatgtB.dist);
    datatgtC.distFilt = filter(coeff, 1, datatgtC.dist);
    
    %Get ENU coordinates
    datatgtA.dN = datatgtA.distFilt(10:end)*cos(minico(1).targets.targetA.elevation+offset.offanglesTarA(2))...
        *cos(minico(1).targets.targetA.azimuth+offset.offanglesTarA(1));
    datatgtA.dE = datatgtA.distFilt(10:end)*cos(minico(1).targets.targetA.elevation+offset.offanglesTarA(2))...
        *sin(minico(1).targets.targetA.azimuth+offset.offanglesTarA(1));
    datatgtA.dU = datatgtA.distFilt(10:end)*sin(minico(1).targets.targetA.elevation+offset.offanglesTarA(2));
    datatgtB.dN = datatgtB.distFilt(10:end)*cos(minico(1).targets.targetB.elevation+offset.offanglesTarB(2))...
        *cos(minico(1).targets.targetB.azimuth+offset.offanglesTarB(1));
    datatgtB.dE = datatgtB.distFilt(10:end)*cos(minico(1).targets.targetB.elevation+offset.offanglesTarB(2))...
        *sin(minico(1).targets.targetB.azimuth+offset.offanglesTarB(1));
    datatgtB.dU = datatgtB.distFilt(10:end)*sin(minico(1).targets.targetB.elevation+offset.offanglesTarB(2));
    datatgtC.dN = datatgtC.distFilt(10:end)*cos(minico(1).targets.targetC.elevation+offset.offanglesTarC(2))...
        *cos(minico(1).targets.targetC.azimuth+offset.offanglesTarC(1));
    datatgtC.dE = datatgtC.distFilt(10:end)*cos(minico(1).targets.targetC.elevation+offset.offanglesTarC(2))...
        *sin(minico(1).targets.targetC.azimuth+offset.offanglesTarC(1));
    datatgtC.dU = datatgtC.distFilt(10:end)*sin(minico(1).targets.targetC.elevation+offset.offanglesTarC(2));
end
