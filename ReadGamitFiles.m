function station = ReadGamitFiles(fileName)
%%This function read *.pos files from GMIT/GLOBK. As inputs, the file name 
%%must be provided and as output an object with station data is
%%returned.
%%Example:
% station=ReadGamitFiles('AREG.mit.final.igs14.pos');
%%Output:
% station.YYYYMMDD            --> Year, month, day for the given position epoch
% station.HHMMSS              --> Hour, minute, second for the given position epoch
% station.modifiedJulianDay   --> Modified Julian day for the given position epoch
% station.X                   --> X coordinate, Specified Reference Frame, meters
% station.Y                   --> Y coordinate, Specified Reference Frame, meters
% station.Z                   --> Z coordinate, Specified Reference Frame, meters
% station.Sx                  --> Standard deviation of the X position, meters
% station.Sy                  --> Standard deviation of the Y position, meters
% station.Sz                  --> Standard deviation of the Z position, meters
% station.Rxy                 --> Correlation of the X and Y position
% station.Rxz                 --> Correlation of the X and Z position
% station.Ryz                 --> Correlation of the Y and Z position
% station.Nlat                --> North latitude, WGS-84 ellipsoid, decimal degrees
% station.Elong               --> East longitude, WGS-84 ellipsoid, decimal degrees
% station.HeightUp            --> Height relative to WGS-84 ellipsoid, m
% station.dN                  --> Difference in North component from NEU reference position, meters
% station.dE                  --> Difference in East component from NEU reference position, meters
% station.du                  --> Difference in vertical component from NEU reference position, meters
% station.Sn                  --> Standard deviation of dN, meters
% station.Se                  --> Standard deviation of dE, meters
% station.Su                  --> Standard deviation of dU, meters
% station.Rne                 --> Correlation of dN and dE
% station.Rnu                 --> Correlation of dN and dU
% station.Reu                 --> Correlation of dE and dU
% station.name                --> Station name
% station.firstEpoch          --> First epoch of data
% station.lastEpoch           --> Last epoch of data
% station.releaseDate         --> Reelase data
% station.xyzReferencePosition  --> Reference position of ENU coordinates
% station.ReferencePositionRef  --> Reference position frame
% station.neuReferencePosition  --> Reference position of ENU coordinates
% station.neuReferencePositionRef --> ENU reference position frame
% 
% developed by bespi123

%% Data Containers
station.YYYYMMDD=[];          %Year, month, day for the given position epoch
station.HHMMSS=[];            %Hour, minute, second for the given position epoch
station.modifiedJulianDay=[]; %Modified Julian day for the given position epoch
station.X=[];                 %X coordinate, Specified Reference Frame, meters
station.Y=[];                 %Y coordinate, Specified Reference Frame, meters
station.Z=[];             %Z coordinate, Specified Reference Frame, meters
station.Sx=[];            %Standard deviation of the X position, meters
station.Sy=[];            %Standard deviation of the Y position, meters
station.Sz=[];            %Standard deviation of the Z position, meters
station.Rxy=[];           %Correlation of the X and Y position
station.Rxz=[];           %Correlation of the X and Z position
station.Ryz=[];           %Correlation of the Y and Z position
station.Nlat=[];          %North latitude, WGS-84 ellipsoid, decimal degrees
station.Elong=[];         %East longitude, WGS-84 ellipsoid, decimal degrees
station.HeightUp=[];      %Height relative to WGS-84 ellipsoid, m
station.dN =[];           %Difference in North component from NEU reference position, meters
station.dE =[];           %Difference in East component from NEU reference position, meters
station.du =[];           %Difference in vertical component from NEU reference position, meters
station.Sn =[];           %Standard deviation of dN, meters
station.Se =[];           %Standard deviation of dE, meters
station.Su =[];           %Standard deviation of dU, meters
station.Rne=[];           %Correlation of dN and dE
station.Rnu=[];           %Correlation of dN and dU
station.Reu=[];           %Correlation of dEand dU

%% Open file
fileID = fopen(fileName);
%% Read whole document
while ~feof(fileID)
   tline = fgetl(fileID);
   if (strcmp(tline(1:11),'4-character'))
        station.name = sscanf(tline,'4-character ID: %s', 1);
   elseif (strcmp(tline(1:11),'First Epoch'))
        station.firstEpoch = sscanf(tline,'First Epoch   : %d %d', [1 2]);
        tline = fgetl(fileID);
        station.lastEpoch = sscanf(tline,'Last Epoch    : %d %d', [1 2]);
        tline = fgetl(fileID);
        station.releaseDate = sscanf(tline,'Release Date  : %d %d', [1 2]);
        tline = fgetl(fileID);
        temp = sscanf(tline,'XYZ Reference position :   %f %f %f (%s)', [1 4]);
        station.xyzReferencePosition = temp(1:3); 
        station.xyzReferencePositionRef =char(temp(4:end-1));
        tline = fgetl(fileID);
        temp = sscanf(tline,'NEU Reference position :   %f %f %f (%s)', [1 4]);
        station.neuReferencePosition = temp(1:3); 
        station.neuReferencePositionRef =char(temp(4:end-1));
   elseif (strcmp(tline(end-4:end),'orbit')||strcmp(tline(end-4:end),'final'))
        temp = sscanf(tline,[' %d %d %f  %f %f %f  %f  %f  %f %f %f  %f' ...
            '     %f  %f %f     %f   %f  %f    %f  %f  %f  %f %f  %f orbit'], [1 24]);
        station.YYYYMMDD=[station.YYYYMMDD;temp(1)]; 
        station.HHMMSS=[station.HHMMSS;temp(2)];
        station.modifiedJulianDay = [station.modifiedJulianDay ;temp(3)];
        station.X=[station.X;temp(4)];
        station.Y=[station.Y;temp(5)];        
        station.Z=[station.Z;temp(6)];         
        station.Sx=[station.Sx;temp(7)];
        station.Sy=[station.Sy;temp(8)]; 
        station.Sz=[station.Sz;temp(9)];
        station.Rxy=[station.Rxy;temp(10)];
        station.Rxz=[station.Rxz;temp(11)];
        station.Ryz=[station.Ryz;temp(12)];
        station.Nlat=[station.Nlat;temp(13)];
        station.Elong=[station.Elong;temp(14)];       %East longitude, WGS-84 ellipsoid, decimal degrees
        station.HeightUp=[station.HeightUp;temp(15)]; %Height relative to WGS-84 ellipsoid, m
        station.dN =[station.dN;temp(16)];            %Difference in North component from NEU reference position, meters
        station.dE =[station.dE;temp(17)];            %Difference in East component from NEU reference position, meters
        station.du =[station.du;temp(18)];            %Difference in vertical component from NEU reference position, meters
        station.Sn =[station.Sn;temp(19)];            %Standard deviation of dN, meters
        station.Se =[station.Se;temp(20)];            %Standard deviation of dE, meters
        station.Su =[station.Su;temp(21)];            %Standard deviation of dU, meters
        station.Rne=[station.Rne;temp(22)];           %Correlation of dN and dE
        station.Rnu=[station.Rnu;temp(23)];           %Correlation of dN and dU
        station.Reu=[station.Reu;temp(24)];           %Correlation of dEand dU
   end
end
%% Close file
fclose(fileID);
end