function laserDat = ReadLogxData(filename)
    %% Open file 
    fileID = fopen(filename);
    %% Initialize counters
    i=ones(1,4);
    %i_ant=zeros(1,4);
    
    %% Read Data
    while ~feof(fileID)
        tline = fgetl(fileID);
        %if(strcmp(tline,'40 HEADER TEST '))
        if(contains('40 HEADER TEST ',tline))
            tline = fgetl(fileID);
            temp=sscanf(tline,'41 %d %d %d %d %s   %d   %d   %d', 8);
            laserDat.tgta.name='A';
            laserDat.tgtb.name='B';
            laserDat.tgtc.name='C';
            switch temp(5)
                case 65
                    %disp('Target A detected');
                    while ~feof(fileID)
                        tline= fgetl(fileID);
                        if(strcmp(tline(1:2),'71'))
                            %disp(tline)
                            temp=sscanf(tline,'71 1 %d %d %d %d   %d   %d        %d      0      0',7);
                            laserDat.tgta.year(i(1))=temp(1);
                            laserDat.tgta.doy(i(1))=temp(2);
                            laserDat.tgta.sod(i(1))=temp(3);
                            if(mod(temp(4),10)~=0)
                                temp(4)=temp(4)+1;
                            end                            
                            laserDat.tgta.reed(i(1))=temp(4);
                            laserDat.tgta.azim(i(1))=temp(5)*1E-4;
                            laserDat.tgta.elev(i(1))=temp(6)*1E-4;
                            laserDat.tgta.time(i(1))=temp(7);
                            i(1)=i(1)+1;
                        elseif(strcmp(tline,'40 HEADER TEST '))
                            p=ftell(fileID);
                            fseek(fileID,p-16,'bof');
                            %i_ant(1)=i(1);
                            break;
                        end
                    end
                    %laserData.tgtA.disp('A')
                case 66
                    %disp('Target B detected');
                    while ~feof(fileID)
                        tline= fgetl(fileID);
                        if(strcmp(tline(1:2),'71'))
                            %disp(tline)
                            temp=sscanf(tline,'71 1 %d %d %d %d   %d   %d        %d      0      0',7);
                            laserDat.tgtb.year(i(2))=temp(1);
                            laserDat.tgtb.doy(i(2))=temp(2);
                            laserDat.tgtb.sod(i(2))=temp(3);
                            if(mod(temp(4),10)~=0)
                                temp(4)=temp(4)+1;
                            end
                            laserDat.tgtb.reed(i(2))=temp(4);
                            laserDat.tgtb.azim(i(2))=temp(5)*1E-4;
                            laserDat.tgtb.elev(i(2))=temp(6)*1E-4;
                            laserDat.tgtb.time(i(2))=temp(7);
                            i(2)=i(2)+1;
                        elseif(strcmp(tline,'40 HEADER TEST '))
                            p=ftell(fileID);
                            fseek(fileID,p-16,'bof');
                            %i()=1;
                            break;
                        end
                    end
                    %laserData.tgtA.disp('A')  
                case 67
                    %disp('Target C detected');
                    while ~feof(fileID)
                        tline= fgetl(fileID);
                        if(strcmp(tline(1:2),'71'))
                            %disp(tline)
                            temp=sscanf(tline,'71 1 %d %d %d %d   %d   %d        %d      0      0',7);
                            laserDat.tgtc.year(i(3))=temp(1);
                            laserDat.tgtc.doy(i(3))=temp(2);
                            laserDat.tgtc.sod(i(3))=temp(3);
                            if(mod(temp(4),10)~=0)
                                temp(4)=temp(4)+1;
                            end                            
                            laserDat.tgtc.reed(i(3))=temp(4);
                            laserDat.tgtc.azim(i(3))=temp(5)*1E-4;
                            laserDat.tgtc.elev(i(3))=temp(6)*1E-4;
                            laserDat.tgtc.time(i(3))=temp(7);
                            i(3)=i(3)+1;
                        elseif(strcmp(tline,'40 HEADER TEST '))
                            p=ftell(fileID);
                            fseek(fileID,p-16,'bof');
                            %i=1;
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