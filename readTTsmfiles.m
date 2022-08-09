function station = readTTsmfiles(filename)
    %% Open file 
    fileID = fopen(filename);
    
    %% Read Data
    while ~feof(fileID)    
        tline = fgetl(fileID);
        if(length(tline)>7)
            if (strcmp(tline(1:7),'STATION'))
                station.name = sscanf(tline,'STATION        = %s                          PAD ID         = 74031306', 1);
            elseif (strcmp(tline(1:8),'LATITUDE'))
                station.lla  = zeros(1,3);
                station.lla(1) = sscanf(tline,'LATITUDE       = %f', 1);
                tline = fgetl(fileID);
                station.lla(2) = sscanf(tline,'LONGITUDE      = %f', 1);
                tline = fgetl(fileID);
                station.lla(3) = sscanf(tline,'HEIGHT         = %f', 1);
            elseif (strcmp(tline(1:4),'   A'))
                temp=sscanf(tline,'   A       %f       %f     %f    DATABASE', [1,3]);
                station.targets.targetA.azimuth = temp(1)*pi/180;
                station.targets.targetA.elevation = temp(2)*pi/180;
                station.targets.targetA.range = temp(3);
                tline = fgetl(fileID);
                temp=sscanf(tline,'   B       %f       %f     %f    DATABASE', [1,3]);
                station.targets.targetB.azimuth = temp(1)*pi/180;
                station.targets.targetB.elevation = temp(2)*pi/180;
                station.targets.targetB.range = temp(3);
                tline = fgetl(fileID);
                temp=sscanf(tline,'   C       %f       %f     %f    DATABASE', [1,3]);
                station.targets.targetC.azimuth = temp(1)*pi/180;
                station.targets.targetC.elevation = temp(2)*pi/180;
                station.targets.targetC.range = temp(3);
            elseif (strcmp(tline(1:9),'SATELLITE'))
                temp=sscanf(tline,'SATELLITE  = ELSADTGT  / %d              MEAN  %f     %f  %f     ', [1,4]);
                station.temp.mean = temp(2);
                station.pressure.mean = temp(3);
                station.humid.mean = temp(4);
                tline = fgetl(fileID);
                temp=sscanf(tline,'DATE       = %s %d, %d = DOY %d           MIN   %f     %f  %f     ', [1,7]);
                station.date=strcat(char(temp(1:3)),char(32),num2str(temp(4),2),', ',num2str(temp(5)));
                station.doy=temp(6);
                station.temp.min = temp(7);
                station.pressure.min = temp(8);
                station.humid.min = temp(9);
                station.doy=temp(6);
                tline = fgetl(fileID);
                temp=sscanf(tline,'START TIME = %d:%d:%d                         MAX   %f     %f  %f     ', [1,6]);
                station.startTimeSod=temp(1)*3600+temp(2)*60+temp(3);
                station.temp.max = temp(4);
                station.pressure.max = temp(5);
                station.humid.max = temp(6);
                tline = fgetl(fileID);
                temp=sscanf(tline,'END TIME   = %d:%d:%d                         RMS    %f       %f   %f     ', [1,6]);
                station.stopTimeSod=temp(1)*3600+temp(2)*60+temp(3);
                station.temp.rms = temp(4);
                station.pressure.rms = temp(5);
                station.humid.rms = temp(6);
            elseif (strcmp(tline(1:14),'TARGET APPLIED'))
                station.appliedTarget = sscanf(tline,'TARGET APPLIED     = %s                        TRANS OPT PATH =  0.0000 M        ', 1);
                tline = fgetl(fileID);
                station.delay = sscanf(tline,'DELAY APPLIED      =      %f NS           ND OPT PATH    =  0.0015 M        ',1);
            elseif (strcmp(tline(1:3),'PRE'))
                temp = sscanf(tline,'PRE   %s   %d  %d     %d   %d     %f     %f                              ',[1 7]);
                station.obs = temp(2);
                station.aceptd = temp(3);
                station.rej = temp(4);
                station.itr = temp(5);
                station.rms = temp(6);
            end
        end
    end
    fclose(fileID);
end