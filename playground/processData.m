function [data] = processData(laserData,targetsData,Srange,delay,startTime,stopTime,tgt)
    %% Get Target Data
    switch tgt
        case 'A'
            range = targetsData.targetA.range;
        case 'B'
            range = targetsData.targetB.range;
        case 'C'
            range = targetsData.targetC.range;
        otherwise
            range = tgt;
    end
    %% Calculate ranges
    c = 299792458;      %Light velocity (m/s)
    minRange = (2*(range-Srange)/c+(delay*1E-9))*1E12; %s 
    maxRange = (2*(range+Srange)/c+(delay*1E-9))*1E12; %s
    %% Create Containers
    doy = [];
    sod = [];
    reedswithc = [];
    distarr = [];
    %% Separate data
    for i=(1:1:length(laserData.doy))
        %Get data between startTime and stopTime
        if((startTime <= laserData.sod(i))&&(stopTime >= laserData.sod(i)))
           %Remove rejected obs
           if ((laserData.time(i) < maxRange)&&(laserData.time(i) > minRange))
               %Calculate Distance
               dist = (((laserData.time(i)*1E-12) - (delay*1E-9))*c)/2;
               doy = [doy;laserData.doy(i)];
               sod = [sod;laserData.sod(i)];
               reedswithc = [reedswithc;laserData.reedswithc(i)];
               distarr = [distarr;dist];
           end
        end
    end   
    %% Get final Array
    data.doy=doy;
    data.sod=sod;
    data.reedswithc=reedswithc;
    data.dist=distarr;
end