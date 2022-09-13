function data = readCpFiles(filename)
    %% Open file 
    fileID = fopen(filename);
    
    %% Data containers
    data.yr=[];
    data.doy=[];
    data.secnd=[];
    data.secFrac=[];
    data.tmp=[];
    data.press=[];
    data.delay=[];

    %% Read Data
    while ~feof(fileID)    
        tline = fgetl(fileID);
        if(length(tline)>10)
            if (strcmp(tline(1:13),'      Station'))
                temp = sscanf(tline,'      Station = %s       Satellite = %s  ', 2);
                data.station=temp(1:4);
                data.satellite=temp(5:end);
            elseif (strcmp(tline(1:13),'      OAM Opt'))
                data.OAMopticalPath = sscanf(tline,'      OAM Optical Path        =   %f meters', 1);
            elseif (strcmp(tline(1:13),'      Misc. O'))
                data.miscOpticalPath = sscanf(tline,'      Misc. Optical Path      =   %f meters', 1);
            elseif (strcmp(tline(1:13),'      Target '))
                data.range=sscanf(tline,'      Target Range =  %f', 1);
                tline = fgetl(fileID);
                data.refractionIndex=sscanf(tline,'      Index of Refraction =  %f', 1);
            elseif (strcmp(tline(1:13),'     Pre Cali'))
                data.precalTarget = sscanf(tline,'     Pre Calibration     Target = %s', 1);
            elseif (strcmp(tline(1:11),'     RECORD'))
                tline = fgetl(fileID);
                tline = fgetl(fileID);
                while ~feof(fileID)
                    temp = sscanf(tline,'          %d   %d %d %d %d    %f   %f              %f',[1 8]);
                    data.yr=[data.yr,temp(2)];
                    data.doy=[data.doy,temp(3)];
                    data.secnd=[data.secnd,temp(4)];
                    data.secFrac=[data.secFrac,temp(5)];
                    data.tmp=[data.tmp,temp(6)];
                    data.press=[data.press,temp(7)];
                    data.delay=[data.delay,temp(8)];
                    tline = fgetl(fileID);
                    if(strcmp(tline(2:10),'     Pass'))
                        break
                    end
                end
            end
        end
    end
    fclose(fileID);
end