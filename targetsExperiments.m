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
cpFiles = dir('Data/Laser/*.cp');
for i=1:length(smFiles)
    minico(i)=readTTsmfiles(smFiles(i).name);
    cpData(i)=readCpFiles(cpFiles(i).name);
end

%Read Raw data
 laserRawData=readLaserData('loge_y2021d215t171131');
%Read Proseced data
 laserDat = ReadLogxData('logx_y2021d215t1714');


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
