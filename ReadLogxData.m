clear, clc

%% Open file 
    fileID = fopen('logx_y2021d215t1714');
    %% Read Data
    i=1;
    while ~feof(fileID)
        tline = fgetl(fileID);
        if(strcmp(tline,'40 HEADER TEST '))
            tline = fgetl(fileID);
            temp=sscanf(tline,'41 %d %d %d %d %s   %d   %d   %d', 8);
            switch temp(5)
                case 65
                    disp('Target A detected');
                    while ~feof(fileID)
                        tline= fgetl(fileID);
                        if(strcmp(tline(1:2),'71'))
                            %disp(tline)
                            temp=sscanf(tline,'71 1 %d %d %d %d   %d   %d        %d      0      0',7);
                            laserDat.tgta.year(i)=temp(1);
                            laserDat.tgta.doy(i)=temp(2);
                            laserDat.tgta.sod(i)=temp(3);
                            laserDat.tgta.reed(i)=temp(4);
                            laserDat.tgta.azim(i)=temp(5)/1E-4;
                            laserDat.tgta.elev(i)=temp(6)/1E-4;
                            laserDat.tgta.time(i)=temp(7);
                            i=i+1;
                        elseif(strcmp(tline,'40 HEADER TEST '))
                            p=ftell(fileID);
                            fseek(fileID,p-16,'bof');
                            i=1;
                            break;
                        end
                    end
                    %laserData.tgtA.disp('A')
                case 66
                    disp('Target B detected');
                    while ~feof(fileID)
                        tline= fgetl(fileID);
                        if(strcmp(tline(1:2),'71'))
                            %disp(tline)
                            temp=sscanf(tline,'71 1 %d %d %d %d   %d   %d        %d      0      0',7);
                            laserDat.tgtb.year(i)=temp(1);
                            laserDat.tgtb.doy(i)=temp(2);
                            laserDat.tgtb.sod(i)=temp(3);
                            laserDat.tgtb.reed(i)=temp(4);
                            laserDat.tgtb.azim(i)=temp(5)/1E-4;
                            laserDat.tgtb.elev(i)=temp(6)/1E-4;
                            laserDat.tgtb.time(i)=temp(7);
                            i=i+1;
                        elseif(strcmp(tline,'40 HEADER TEST '))
                            p=ftell(fileID);
                            fseek(fileID,p-16,'bof');
                            break;
                        end
                    end
                    %laserData.tgtA.disp('A')  
                case 67
                    disp('Target C detected');
                    while ~feof(fileID)
                        tline= fgetl(fileID);
                        if(strcmp(tline(1:2),'71'))
                            %disp(tline)
                            temp=sscanf(tline,'71 1 %d %d %d %d   %d   %d        %d      0      0',7);
                            laserDat.tgtc.year(i)=temp(1);
                            laserDat.tgtc.doy(i)=temp(2);
                            laserDat.tgtc.sod(i)=temp(3);
                            laserDat.tgtc.reed(i)=temp(4);
                            laserDat.tgtc.azim(i)=temp(5)/1E-4;
                            laserDat.tgtc.elev(i)=temp(6)/1E-4;
                            laserDat.tgtc.time(i)=temp(7);
                            i=i+1;
                        elseif(strcmp(tline,'40 HEADER TEST '))
                            p=ftell(fileID);
                            fseek(fileID,p-16,'bof');
                            break;
                        end
                    end
                    %laserData.tgtA.disp('A')            
                otherwise
                    disp('Other target')
            end
        end
    end
   
%     fseek(fileID,281,'bof');
%     tline = fgetl(fileID);
%     station.name = sscanf(tline,'STATION        = %s                          PAD ID         = 74031306', 1);
%     fseek(fileID,424,'bof');
%     tline = fgetl(fileID);
%     station.lla  = zeros(1,3);
%     station.lla(1) = sscanf(tline,'LATITUDE       = %f', 1);
%     tline = fgetl(fileID);
%     station.lla(2) = sscanf(tline,'LONGITUDE      = %f', 1);
%     tline = fgetl(fileID);
%     station.lla(3) = sscanf(tline,'HEIGHT         = %f', 1);
%     fseek(fileID,604,'bof');
%     tline = fgetl(fileID);
%     temp=sscanf(tline,'   A       %f       %f     %f    DATABASE', [1,3]);
%     station.targets.targetA.azimuth = temp(1)*pi/180;
%     station.targets.targetA.elevation = temp(2)*pi/180;
%     station.targets.targetA.range = temp(3);
%     tline = fgetl(fileID);
%     temp=sscanf(tline,'   B       %f       %f     %f    DATABASE', [1,3]);
%     station.targets.targetB.azimuth = temp(1)*pi/180;
%     station.targets.targetB.elevation = temp(2)*pi/180;
%     station.targets.targetB.range = temp(3);
%     tline = fgetl(fileID);
%     temp=sscanf(tline,'   C       %f       %f     %f    DATABASE', [1,3]);
%     station.targets.targetC.azimuth = temp(1)*pi/180;
%     station.targets.targetC.elevation = temp(2)*pi/180;
%     station.targets.targetC.range = temp(3);
%     fseek(fileID,1126,'bof');
%     tline = fgetl(fileID);
%     temp=sscanf(tline,'SATELLITE  = ELSADTGT  / %d              MEAN  %f     %f  %f     ', [1,4]);
%     station.temp.mean = temp(2);
%     station.pressure.mean = temp(3);
%     station.humid.mean = temp(4);
%     tline = fgetl(fileID);
%     temp=sscanf(tline,'DATE       = %s %d, %d = DOY %d           MIN   %f     %f  %f     ', [1,7]);
%     station.date=strcat(char(temp(1:3)),char(32),num2str(temp(4),2),', ',num2str(temp(5)));
%     station.doy=temp(6);
%     station.temp.min = temp(7);
%     station.pressure.min = temp(8);
%     station.humid.min = temp(9);
%     station.doy=temp(6);
%     tline = fgetl(fileID);
%     temp=sscanf(tline,'START TIME = %d:%d:%d                         MAX   %f     %f  %f     ', [1,6]);
%     station.startTimeSod=temp(1)*3600+temp(2)*60+temp(3);
%     station.temp.max = temp(4);
%     station.pressure.max = temp(5);
%     station.humid.max = temp(6);
%     tline = fgetl(fileID);
%     temp=sscanf(tline,'END TIME   = %d:%d:%d                         RMS    %f       %f   %f     ', [1,6]);
%     station.stopTimeSod=temp(1)*3600+temp(2)*60+temp(3);
%     station.temp.rms = temp(4);
%     station.pressure.rms = temp(5);
%     station.humid.rms = temp(6);
%     fseek(fileID,1612,'bof');
%     tline = fgetl(fileID);
%     station.appliedTarget = sscanf(tline,'TARGET APPLIED     = %s                        TRANS OPT PATH =  0.0000 M        ', 1);
%     tline = fgetl(fileID);
%     station.delay = sscanf(tline,'DELAY APPLIED      =      %f NS           ND OPT PATH    =  0.0015 M        ',1);
%     fseek(fileID,2017,'bof');
%     tline = fgetl(fileID);
%     temp = sscanf(tline,'PRE   %s   %d  %d     %d   %d     %f     %f                              ',[1 7]);
%     station.obs = temp(2);
%     station.aceptd = temp(3);
%     station.rej = temp(4);
%     station.itr = temp(5);
%     station.rms = temp(6);
%     fclose(fileID);