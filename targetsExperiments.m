%Clear and close files
clear, clc, close all

%% Estation Eccentricity
% https://cddis.nasa.gov/archive/slr/slrocc/ecc_une.snx
 offset.ecc_une = [2.6790,0.0140,-0.0020];

%% Read TRACK files
%%%Read files for minico test
% taraGEOD = readTrack('TRAK2040GEODtaraLC.csv');
% tarbGEOD = readTrack('TRAK2040GEODtarbLC.csv');
 tarcGEOD = readTrack('TRAK2040GEODtarcLC.csv');
% %aregGEOD = readTrack('TRAK2040GEODAREGLC.csv');
%taraNEU = readTrack('TRAK2040NEUtaraLC.csv');
%tarbNEU = readTrack('TRAK2040NEUtarbLC.csv');
%tarcNEU = readTrack('TRAK2040NEUtarcLC.csv');

%% Read Gamit files
tara = ReadGamitFiles('TARA.iaa.orbit_igs14.pos');
tarb = ReadGamitFiles('TARB.iaa.orbit_igs14.pos');

%% Read Laser files
%Read .sm files
smFiles = dir('Data/Laser/*.sm');
cpFiles = dir('Data/Laser/*.cp');
for i=1:length(smFiles)
    minico(i)=readTTsmfiles(smFiles(i).name);
    cpData(i)=readCpFiles(cpFiles(i).name);
end
%Read Raw data
 laserRawData=readLaserData('loge_y2021d215t171131');
%Read Proseced data
 laserDat = ReadLogxData('logx_y2021d215t1714');
%Combined Laser
laserData = readLaser(laserDat,laserRawData,cpData,minico);
clear laserRawData laserDat cpData i cpFiles smFiles
%% Calculus
%%%%Convert to Arel reference frame
gnssData.tara.ENU=lla2enu([tara.Nlat,tara.Elong-360,tara.HeightUp], ...
    [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
gnssData.tarb.ENU=lla2enu([tarb.Nlat,tarb.Elong-360,tarb.HeightUp], ...
    [minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
%%%%Calculate gnss range.
gnssData.tara.range=norm(mean(gnssData.tara.ENU));
gnssData.tarb.range=norm(mean(gnssData.tarb.ENU));
%%%%Display Data
disp('Target A')
fprintf('GNSS range: %f, SLR range: %f, Total Error: %f \n', ...
    gnssData.tara.range,laserData.tgta.range,gnssData.tara.range-laserData.tgta.range);
fprintf('GNSS dE: %f, SLR dE: %f, dE Error: %f \n', ...
    mean(gnssData.tara.ENU(:,1)),mean(laserData.tgta.dE),mean(gnssData.tara.ENU(:,1))-mean(laserData.tgta.dE));
fprintf('GNSS dU: %f, SLR dU: %f, dU Error: %f \n', ...
    mean(gnssData.tara.ENU(:,3)),mean(laserData.tgta.dU),mean(gnssData.tara.ENU(:,3))-mean(laserData.tgta.dU));
fprintf('GNSS dN: %f, SLR dN: %f, dN Error: %f \n', ...
    mean(gnssData.tara.ENU(:,2)),mean(laserData.tgta.dN),mean(gnssData.tara.ENU(:,2))-mean(laserData.tgta.dN));

disp('Target A')
fprintf('GNSS range: %f, SLR range: %f, Total Error: %f \n', ...
    gnssData.tara.range,laserData.tgta.range,gnssData.tara.range-laserData.tgta.range);
fprintf('GNSS dE: %f, SLR dE: %f, dE Error: %f \n', ...
    mean(gnssData.tara.ENU(:,1)),mean(laserData.tgta.dE),mean(gnssData.tara.ENU(:,1))-mean(laserData.tgta.dE));
fprintf('GNSS dU: %f, SLR dU: %f, dU Error: %f \n', ...
    mean(gnssData.tara.ENU(:,3)),mean(laserData.tgta.dU),mean(gnssData.tara.ENU(:,3))-mean(laserData.tgta.dU));
fprintf('GNSS dN: %f, SLR dN: %f, dN Error: %f \n', ...
    mean(gnssData.tara.ENU(:,2)),mean(laserData.tgta.dN),mean(gnssData.tara.ENU(:,2))-mean(laserData.tgta.dN));

%% Plots
%%%%Plot Raw data 
figure()
    x= [laserData.tgta.sod(1:5E3)'+laserData.tgta.reed(1:5E3)'*1E-12, ...
        laserData.tgtb.sod(1:5E3)'+laserData.tgtb.reed(1:5E3)'*1E-12, ...
        laserData.tgtc.sod(1:5E3)'+laserData.tgtc.reed(1:5E3)'*1E-12, ...
        ];
    y=[laserData.tgta.time(1:5E3)',laserData.tgtb.time(1:5E3)',laserData.tgtc.time(1:5E3)'];
    breakplot(x,y,0.7463e6,2.8634e6,0.7459e6,2.8637e6,'RPatch',50E3);
    grid on
    title('Minico Test: Raw Laser Data (TLRS-3)');
    xlabel('SOD')
    ylabel('Measured Flight time (ps)')
    legend('Target A','Target B','Target C','Location','northwest','FontSize',10)
    grid on

%%%%Plot System delay
figure()
    dE=subplot(3,1,1);
        p1=plot((laserData.tgta.sod'+laserData.tgta.reed'*1E-12)*1E0,laserData.tgta.delay,'b.');
        grid on
        title('Minico Test: Corrected Flight time (TLRS-3)');
        ylabel('System delay (ns)');
        
    dN=subplot(3,1,2);
        p2=plot((laserData.tgtb.sod'+laserData.tgtb.reed'*1E-12)*1E0,laserData.tgtb.delay,'r.');
        grid on
        ylabel('System delay (ns)');

    dU=subplot(3,1,3);
        p3=plot((laserData.tgtc.sod'+laserData.tgtc.reed'*1E-12)*1E0,laserData.tgtc.delay,'.','Color','#EDB120');
        grid on
        ylabel('System delay (ns)');
        xlabel('SOD');
    linkaxes([dE,dN,dU],'x');
    legend([p1,p2,p3],{'Target A','Target B','Target C'},'FontSize',10)

%%%%Plot Raw data - System delay
figure()
    dE=subplot(3,1,1);
        p1=plot((laserData.tgta.sod'+laserData.tgta.reed'*1E-12)*1E0,laserData.tgta.finalTime*1E6,'b.');
        grid on
        title('Minico Test: Corrected Flight time (TLRS-3)');
        ylabel('Flight time (\mus)');
        
    dN=subplot(3,1,2);
        p2=plot((laserData.tgtb.sod'+laserData.tgtb.reed'*1E-12)*1E0,laserData.tgtb.finalTime*1E6,'r.');
        grid on
        ylabel('Flight time (\mus)');

    dU=subplot(3,1,3);
        p3=plot((laserData.tgtc.sod'+laserData.tgtc.reed'*1E-12)*1E0,laserData.tgtc.finalTime*1E6,'.','Color','#EDB120');
        grid on
        ylabel('Flight time (\mus)');
        xlabel('SOD');
    linkaxes([dE,dN,dU],'x');
    legend([p1,p2,p3],{'Target A','Target B','Target C'},'FontSize',10)

%%%Plot Measured distance
figure()
    dE=subplot(3,1,1);
        p1=plot((laserData.tgta.sod'+laserData.tgta.reed'*1E-12)*1E0,laserData.tgta.rawRange,'b.');
        grid on
        title('Minico Test: Measured distances  (TLRS-3)');
        ylabel('Distance (m)');
    dN=subplot(3,1,2);
        p2=plot((laserData.tgtb.sod'+laserData.tgtb.reed'*1E-12)*1E0,laserData.tgtb.rawRange,'r.');
        grid on
        ylabel('Distance (m)');
    dU=subplot(3,1,3);
        p3=plot((laserData.tgtc.sod'+laserData.tgtc.reed'*1E-12)*1E0,laserData.tgtc.rawRange,'.','Color','#EDB120');
        grid on
        ylabel('Distance (m)');
        xlabel('SOD');
    linkaxes([dE,dN,dU],'x');
    legend([p1,p2,p3],{'Target A','Target B','Target C'},'FontSize',10)

% %%%Plot Target A NEU
% figure()
%     dE=subplot(3,1,1);
%         p1=plot((laserData.tgta.sod'+laserData.tgta.reed'*1E-12)*1E0,laserData.tgta.dN,'b.');
%         grid on
%         title('Minico Test: Measured distances  (TLRS-3)');
%         ylabel('Distance (m)');
%     dN=subplot(3,1,2);
%         p2=plot((laserData.tgtb.sod'+laserData.tgtb.reed'*1E-12)*1E0,laserData.tgtb.dE,'r.');
%         grid on
%         ylabel('Distance (m)');
%     dU=subplot(3,1,3);
%         p3=plot((laserData.tgtc.sod'+laserData.tgtc.reed'*1E-12)*1E0,laserData.tgtc.dU,'.','Color','#EDB120');
%         grid on
%         ylabel('Distance (m)');
%         xlabel('SOD');
%     linkaxes([dE,dN,dU],'x');
%     legend([p1,p2,p3],{'Target A','Target B','Target C'},'FontSize',10)
% 
% %%%Plot Target B NEU
% 
% 
% %%%Plot Target C NEU
% 
%%%Plot Map
figure()
geoplot([laserData.tgta.lat,laserData.tgtb.lat,laserData.tgtc.lat],[laserData.tgta.lon+360,laserData.tgtb.lon+360,laserData.tgtc.lon+360],'ro')
geobasemap satellite
hold on
geoplot([mean(tara.Nlat),mean(tarb.Nlat),mean(tarcGEOD.latitude)],...
    [mean(tara.Elong),mean(tarb.Elong),mean(tarcGEOD.longitude)],...
    'b*');






%% Uses defined Functions
 function laserData = readLaser(laserDat,laserRawData,cpData,minico) 
    %Combine data
    laserData.tgta = combine(laserDat.tgta,laserRawData,cpData,minico);
    laserData.tgtb = combine(laserDat.tgtb,laserRawData,cpData,minico);
    laserData.tgtc = combine(laserDat.tgtc,laserRawData,cpData,minico);
 end

 function dat = combine(laserDat,laserRawData,cpData,minico)
    a=zeros(1,length(laserDat.sod));
    j=1;
    c = 299792458;      %Light velocity (m/s)
    wgs84 = wgs84Ellipsoid;

    for i=1:length(laserDat.sod)
        w=(laserDat.sod(i)==laserRawData.sod(1:end)&laserDat.reed(i)==floor(laserRawData.reedswithc(1:end)/1e11)*1E8);
        for k=1:length(cpData)
            if(cpData(k).precalTarget==laserDat.name)
               w1=(laserDat.sod(i)==cpData(k).secnd(1:end)&laserDat.reed(i)==floor(cpData(k).secFrac(1:end)/1e6)*1E8);
               if(find(w1)~=0)
                 b=find(w1);
                 laserDat.delay(i)=cpData(k).delay(b);
                 laserDat.temp(i)=cpData(k).tmp(b);
                 laserDat.press(i)=cpData(k).press(b);
                 laserDat.OAMopticalPath = cpData(k).OAMopticalPath;
                 laserDat.miscOpticalPath = cpData(k).miscOpticalPath;
                 laserDat.range = cpData(k).range;
                 laserDat.refractionIndex = cpData(k).refractionIndex;
               end
            end
        end
        if(find(w)~=0)
            a(j)=find(w);
            j=j+1;
        end
    end
    laserDat.reed = laserRawData.reedswithc(a)';
    laserDat.time = laserRawData.time(a)'; 
    laserDat.finalTime = laserDat.time*1E-12-laserDat.delay*1E-9;
    laserDat.rawRange = (c*laserDat.finalTime/2)/laserDat.refractionIndex;
    laserDat.azim=laserDat.azim*pi/180;
    laserDat.elev=laserDat.elev*pi/180;
    laserDat.dN = laserDat.rawRange.*cos(laserDat.elev).*cos(laserDat.azim);
    laserDat.dE = laserDat.rawRange.*cos(laserDat.elev).*sin(laserDat.azim);
    laserDat.dU = laserDat.rawRange.*sin(laserDat.elev);
    [laserDat.lat,laserDat.lon,laserDat.h] = enu2geodetic(mean(laserDat.dE),mean(laserDat.dN),mean(laserDat.dU), ...
        minico(1).lla(1),minico(1).lla(2)-360,minico(1).lla(3),wgs84);

    %%  output
    dat=laserDat;
  end

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
