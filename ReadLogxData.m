function laserDat = ReadLogxData(filename)
    %% Open file 
    fileID = fopen(filename);
    %% Read Data
    i=1;
    while ~feof(fileID)
        tline = fgetl(fileID);
        %if(strcmp(tline,'40 HEADER TEST '))
        if(contains('40 HEADER TEST ',tline))
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
                            laserDat.tgta.azim(i)=temp(5)*1E-4;
                            laserDat.tgta.elev(i)=temp(6)*1E-4;
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
                            laserDat.tgtb.azim(i)=temp(5)*1E-4;
                            laserDat.tgtb.elev(i)=temp(6)*1E-4;
                            laserDat.tgtb.time(i)=temp(7);
                            i=i+1;
                        elseif(strcmp(tline,'40 HEADER TEST '))
                            p=ftell(fileID);
                            fseek(fileID,p-16,'bof');
                            i=1;
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
                            laserDat.tgtc.azim(i)=temp(5)*1E-4;
                            laserDat.tgtc.elev(i)=temp(6)*1E-4;
                            laserDat.tgtc.time(i)=temp(7);
                            i=i+1;
                        elseif(strcmp(tline,'40 HEADER TEST '))
                            p=ftell(fileID);
                            fseek(fileID,p-16,'bof');
                            i=1;
                            break;
                        end
                    end
                    %laserData.tgtA.disp('A')            
                otherwise
                    disp('Other target')
            end
        end
    end
    fclose(fileID);
end