%% MISTI MONITORING PLOTS
%%% Description:
% This program reads and plots serial times for coordinates obtained from
% .pos Gamit files. Aditionally, this program is capable to calculate
% baselines between to stations in order to calculate volcanic deformation.
%%% Dependencies:
% This program uses the fuctions:
% *ReadGAmitFiles -- >  ReadGamitFiles.m
% *CalculateBaseline --> Local Function
% *plotGamitNEU --> Local Function
% *comparison --> Local Function
%%%% Developed by Bespi123 


%% Clear and close variables 
clear, clc
close all;

%% READ DATA 
%%% Read GAMIT.pos data Files 
areg=ReadGamitFiles('AREG.mit.final.igs14.pos');
areq=ReadGamitFiles('AREQ.mit.final.igs14.pos');
mtpi=ReadGamitFiles('MTPI.mit.final.igs14.pos');
mtpi_ingemmet = ReadGamitFiles('MTPI.ovi.orbit_sam14.pos');
%%% Read Data donwlodaded from
%%% http://geodesy.unr.edu/NGLStationPages/stations/AREQ.sta
areq_nevada = readmatrix('AREQ.Geoff.txt');

%% Calculate Baselines
CalculateBaseline(areq,areg)
CalculateBaseline(mtpi,areq)
CalculateBaseline(mtpi,areg)

%% Plot areqxyzENUfigures
plotGamitNEU(areg,'01-01-2021','05-31-2022',6);
plotGamitNEU(areq,'01-01-2021','05-31-2022',6);
plotGamitNEU(mtpi,'01-01-2021','05-31-2022',6);

%% COMPARE ingemmet and IAAPP processing, and IAAPP with nevada Processing
comparison(mtpi_ingemmet,mtpi,areq_nevada,areq,'01-02-2021','01-01-2022',6);


%% User defined Fucntions

%%% General Plot function for GAMIT Files
function plotGamitNEU(site,initialDate,finalDate,ticksnum)
% This fuction plots serial times from objects readede by the function 
% ReadGAmitFiles.
% INPUTS:
% site--> station object readed by ReadGAmitFiles.m
% initialDate --> Initial data to start to plot in format 'mm-dd-yyyy'.
% finalDate --> Final date to stop to plot in format 'mm-dd-yyyy'.
% ticksnum --> Number of date ticks in y axis.

%% Create new figure
    figure();
    dN=subplot(3,1,1);
        %%% Plot coordinates with error bars
        errorbar(site.modifiedJulianDay+678942,site.dN*1E3,site.Sn*1E3,'.','MarkerEdgeColor','red')
        grid on
        %%% Create time vector
        time = linspace(datenum(initialDate),datenum(finalDate),ticksnum);
        xticks(time);
        %%% Turn numeric tick into string
        xticklabels(cellstr(datestr(time,2)));
        %%% Set initial and final range
        xlim([datenum(initialDate) datenum(finalDate)]);  
        %%% Add subtitle, title, and y label
        subtit=strcat('Difference in North component (dN), Reference latitude: ' ...
            ,num2str(site.neuReferencePosition(1),9),'°N, RMS =', num2str(mean((site.Sn)*1E3),2),'mm');
        title(site.name,subtit);
        ylabel('North (mm)')        

    dE=subplot(3,1,2);
        %%% Plot coordinates with error bars
        errorbar(site.modifiedJulianDay+678942,site.dE*1E3,site.Se*1E3,'.','MarkerEdgeColor','red')
        grid on
        %%% Create time vector
        time = linspace(datenum(initialDate),datenum(finalDate),ticksnum);
        xticks(time);
        %%% Turn numeric tick into string        
        xticklabels(cellstr(datestr(time,2)));
        %%% Set initial and final range
        xlim([datenum(initialDate) datenum(finalDate)]);
        %%% Add subtitle, title, and y label
        subtit=strcat('Difference in East component(dE), Reference longitude: ' ...
            ,num2str(site.neuReferencePosition(2),9),'°E, RMS =', num2str(mean((site.Se)*1E3),2),'mm');
        subtitle(subtit);
        ylabel('East (mm)')

    dU=subplot(3,1,3);
        %%% Plot coordinates with error bars
        errorbar(site.modifiedJulianDay+678942,site.du,site.Su,'.','MarkerEdgeColor','red')
        grid on
        %%% Create time vector
        time = linspace(datenum(initialDate),datenum(finalDate),ticksnum);
        xticks(time);
        %%% Turn numeric tick into string       
        xticklabels(cellstr(datestr(time,2)));
        %%% Set initial and final range
        xlim([datenum(initialDate) datenum(finalDate)]);
        %%% Add subtitle, title, and y label
        subtit=strcat('Difference in Vertical component(dU), Reference height: ' ...
            ,num2str(site.neuReferencePosition(3),9),'m, RMS =', num2str(mean((site.Su)*1E3),2),'mm');
        subtitle(subtit);
        ylabel('Up (mm)')

    %%%Link all axis    
    linkaxes([dE,dN,dU],'x');
end

%% Baseline Calculation
function CalculateBaseline(site1,site2)
% This fuction calculate the baseline between two near stations and plots
% the baseline's time series.
% INPUTS:
% site1--> station object readed by ReadGAmitFiles.m
% site2--> station object readed by ReadGAmitFiles.m

   %%% Calculate intersection between site1 and site2
   [time,is1,is2]=intersect(site1.modifiedJulianDay,site2.modifiedJulianDay);

   %%% Transform site2 to site1 NEU reference frame for comparisson
    xyzENU=lla2enu([site2.Nlat,site2.Elong-360,site2.HeightUp] ...
     ,[site1.neuReferencePosition(1),site1.neuReferencePosition(2)-360,site1.neuReferencePosition(3)],"ellipsoid");
   %%% Substract site1-site2    
   dxE=site1.dE(is1(1):is1(1)+length(is1)-1)-xyzENU(is2(1):is2(1)+length(is2)-1,1);
   dyN=site1.dN(is1(1):is1(1)+length(is1)-1)-xyzENU(is2(1):is2(1)+length(is2)-1,2);
   dzU=site1.du(is1(1):is1(1)+length(is1)-1)-xyzENU(is2(1):is2(1)+length(is2)-1,3);
   %%% Calculate mean values
   dxE_mean=mean(dxE)*ones(1,length(is1));
   dyN_mean=mean(dyN)*ones(1,length(is1));
   dzU_mean=mean(dzU)*ones(1,length(is1));
   
   %%% Plot baselines 
    figure()
    dE=subplot(3,1,1);
        %%% Calculate measurement error and plot error bars
        Se=site1.Se(is1(1):is1(1)+length(is1)-1)+site2.Se(is2(1):is2(1)+length(is2)-1);
        p1=errorbar(time+678942,dxE,Se,'.','MarkerEdgeColor','red');
        hold on
        %%% Plot flat tendency
        p2=plot(time+678942,dxE_mean,'g--','LineWidth',3);
        grid on
        %%% Turn x axis ticks int format 'dd/mm/yy'
        datetick('x','dd/mm/yy');
        %%% Add title, subtitle and ylabel
        tit=strcat(site1.name,'-',site2.name);
        subtit=strcat('Difference in North component (dN), Reference latitude: ' ...
            ,num2str(site1.neuReferencePosition(1),9),'°N, RMS =', num2str(mean((Se)*1E3),2),'mm');
        title(tit,subtit);
        ylabel('North (m)')
        %%% Add legend
        leg=strcat('Mean: ', num2str(mean(dxE)),'m');
        legend([p1,p2],{'Baseline',leg})
    
    dN=subplot(3,1,2);
        %%% Calculate measurement error and plot error bars
        Sn=site1.Sn(is1(1):is1(1)+length(is1)-1)+site2.Sn(is2(1):is2(1)+length(is2)-1);
        p1=errorbar(time+678942,dyN,Sn,'.','MarkerEdgeColor','red');
        hold on
        %%% Plot flat tendency
        p2=plot(time+678942,dyN_mean,'g--','LineWidth',3);
        grid on
        %%% Turn x axis ticks int format 'dd/mm/yy'
        datetick('x','dd/mm/yy');
        %%% Add title, subtitle and ylabel
        subtit=strcat('Difference in East component (dE), Reference longitude: ' ...
            ,num2str(site1.neuReferencePosition(2),9),'°E, RMS =', num2str(mean((Sn)*1E3),2),'mm');
        subtitle(subtit);
        ylabel('East (m)')
        %%% Add legend
        leg=strcat('Mean: ', num2str(mean(dyN)),'m');
        legend([p1,p2],{'Baseline',leg})

    dU=subplot(3,1,3);
        %%% Calculate measurement error and plot error bars
        Su=site1.Su(is1(1):is1(1)+length(is1)-1)+site2.Su(is2(1):is2(1)+length(is2)-1);
        p1=errorbar(time+678942,dzU,Su,'.','MarkerEdgeColor','red');
        hold on
        %%% Plot flat tendency
        p2=plot(time+678942,dzU_mean,'g--','LineWidth',3);
        grid on
        %%% Turn x axis ticks int format 'dd/mm/yy'
        datetick('x','dd/mm/yy');
        %%% Add title, subtitle and ylabel
        subtit=strcat('Difference in Vertical component (dU), Reference altitude: ' ...
            ,num2str(site1.neuReferencePosition(3),9),'m, RMS =', num2str(mean((Su)*1E3),2),'mm');
        subtitle(subtit);   
        xlabel('Date')
        ylabel('Up (m)')
        %%% Add legend
        leg=strcat('Mean: ', num2str(mean(dzU)),'m');
        legend([p1,p2],{'Baseline',leg})

    %%%Link all axis    
    linkaxes([dE,dN,dU],'x');
end

function comparison(mtpi_ingemmet,mtpi,areq_nevada,areq,inicialDate,finalDate,ticksnum)
% This fuction compare the MTPI's mtpi_ingemmet and IAAPP process results. Also compare the 
% AREQ's results made by the IAAPP and the nevada processing. The results are plot in 
% time series.
% INPUTS:
% site1--> station object readed by ReadGAmitFiles.m
% site2--> station object readed by ReadGAmitFiles.m

    %%%Transform Ingemmet processing to IAAPP processing NEU reference frame for
    %%%comparisson
    mtpixyzENU=lla2enu([mtpi_ingemmet.Nlat,mtpi_ingemmet.Elong-360,mtpi_ingemmet.HeightUp] ...
    ,[mtpi.neuReferencePosition(1),mtpi.neuReferencePosition(2)-360,mtpi.neuReferencePosition(3)],"ellipsoid");    
    %%Transform nevada processing to IAAPP processing NEU reference frame for
    %%comparisson
    areqxyzENU=lla2enu(areq_nevada(:,21:23),[areq.neuReferencePosition(1), ...
        areq.neuReferencePosition(2)-360,areq.neuReferencePosition(3)],"ellipsoid");
   
    %%Plot Ingemmet and MTPI comparisson
    figure()
    dE=subplot(3,1,1);
        p1=errorbar(mtpi_ingemmet.modifiedJulianDay+678942,mtpixyzENU(:,1)*1E3,mtpi_ingemmet.Se*1E3, ...
            'b.','MarkerEdgeColor','red');
        hold on
        p2=errorbar(mtpi.modifiedJulianDay+678942,mtpi.dE*1E3,mtpi.Se*1E3,'r.', ...
            'MarkerEdgeColor','red');
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'INGEMMET','IAAPP'})
        ylabel('East (mm)');
        subtit=strcat('Difference in East component (dE), Reference longitude: ' ...
            ,num2str(mtpi.neuReferencePosition(2),9),'°E, Difference =', num2str((mean(mtpixyzENU(2:end,1))-mean(mtpi.dE))*1E3,2),'mm');
        title('MTPI Final results Comparison',subtit);

    dN=subplot(3,1,2);
        p1=errorbar(mtpi_ingemmet.modifiedJulianDay+678942,mtpixyzENU(:,2)*1E2,mtpi_ingemmet.Sn*1E2, ...
            '.','MarkerEdgeColor','red');
        hold on
        p2=errorbar(mtpi.modifiedJulianDay+678942,mtpi.dN*1E2,mtpi.Sn*1E2,'r.', ...
            'MarkerEdgeColor','red');
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'INGEMMET','IAAPP'})
        ylabel('North (cm)');
        subtit=strcat('Difference in North component (dN), Reference latitude: ' ...
            ,num2str(mtpi.neuReferencePosition(1),9),'°N, Difference =', num2str((mean(mtpixyzENU(2:end,2))-mean(mtpi.dN))*1E2,2),'cm');
        subtitle(subtit);
    dU=subplot(3,1,3);
        p1=errorbar(mtpi_ingemmet.modifiedJulianDay+678942,mtpixyzENU(:,3)*1E3,mtpi_ingemmet.Su*1E3, ...
            '.','MarkerEdgeColor','red');
        hold on
        p2=errorbar(mtpi.modifiedJulianDay+678942,mtpi.du*1E2,mtpi.Su*1E3,'r.', ...
            'MarkerEdgeColor','red');
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'INGEMMET','IAAPP'})
        ylabel('Up (mm)');
        subtit=strcat('Difference in Vertical component (dU), Reference altitude: ' ...
            ,num2str(mtpi.neuReferencePosition(3),9),'m, Difference =', num2str((mean(mtpixyzENU(2:end,3))-mean(mtpi.du))*1E3,2),'mm');
        subtitle(subtit);
        xlabel('Date')
linkaxes([dE,dN,dU],'x');

figure()
    dE=subplot(3,1,1);
        p1=errorbar(mtpi_ingemmet.modifiedJulianDay+678942,mtpixyzENU(:,1)*1E3-(mean(mtpixyzENU(2:end,1))-mean(mtpi.dE))*1E3,mtpi_ingemmet.Se*1E3, ...
            'b.','MarkerSize',15,'MarkerEdgeColor','blue');
        hold on
        p2=errorbar(mtpi.modifiedJulianDay+678942,mtpi.dE*1E3,mtpi.Se*1E3,'r.', ...
            'MarkerEdgeColor','red','MarkerSize',15);
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'INGEMMET','IAAPP'})
        ylabel('East (mm)');
        subtit=strcat('Difference in East component (dE), Reference longitude: ' ...
            ,num2str(mtpi.neuReferencePosition(2),9),'°E, Difference =', num2str((mean(mtpixyzENU(2:end,1))-mean(mtpi.dE))*1E3,2),'mm');
        title('MTPI Final results Comparison',subtit);

    dN=subplot(3,1,2);
        p1=errorbar(mtpi_ingemmet.modifiedJulianDay+678942,mtpixyzENU(:,2)*1E2-(mean(mtpixyzENU(2:end,2))-mean(mtpi.dN))*1E2,mtpi_ingemmet.Sn*1E2, ...
            'b.','MarkerEdgeColor','blue','MarkerSize',15);
        hold on
        p2=errorbar(mtpi.modifiedJulianDay+678942,mtpi.dN*1E2,mtpi.Sn*1E2,'r.', ...
            'MarkerEdgeColor','red','MarkerSize',15);
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'INGEMMET','IAAPP'})
        ylabel('North (cm)');
        subtit=strcat('Difference in North component (dN), Reference latitude: ' ...
            ,num2str(mtpi.neuReferencePosition(1),9),'°N, Difference =', num2str((mean(mtpixyzENU(2:end,2))-mean(mtpi.dN))*1E2,2),'cm');
        subtitle(subtit);
    dU=subplot(3,1,3);
        p1=errorbar(mtpi_ingemmet.modifiedJulianDay+678942,mtpixyzENU(:,3)*1E3-(mean(mtpixyzENU(2:end,3))-mean(mtpi.du))*1E3,mtpi_ingemmet.Su*1E3, ...
            'b.','MarkerEdgeColor','blue','MarkerSize',15);
        hold on
        p2=errorbar(mtpi.modifiedJulianDay+678942,mtpi.du*1E2,mtpi.Su*1E3,'r.', ...
            'MarkerEdgeColor','red','MarkerSize',15);
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'INGEMMET','IAAPP'})
        ylabel('Up (mm)');
        subtit=strcat('Difference in Vertical component (dU), Reference altitude: ' ...
            ,num2str(mtpi.neuReferencePosition(3),9),'m, Difference =', num2str((mean(mtpixyzENU(2:end,3))-mean(mtpi.du))*1E3,2),'mm');
        subtitle(subtit);
        xlabel('Date')
linkaxes([dE,dN,dU],'x');


figure()
    dE=subplot(3,1,1);
        p1=errorbar(areq_nevada(:,4)+678942,areqxyzENU(:,1)*1E3,areq_nevada(:,15)*1E3,...
            '.','MarkerSize',15,'MarkerEdgeColor','blue');
        hold on
        p2=errorbar(areq.modifiedJulianDay+678942,areq.dE*1E3,areq.Se*1E3,'r.', ...
            'MarkerSize',15,'MarkerEdgeColor','red');
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'Nevada Geodetic Laboratory','IAAPP'})
        ylabel('East (mm)');
        subtit=strcat('Difference in East component (dE), Reference Longitude: ' ...
            ,num2str(areq.neuReferencePosition(2),9),'°E');
        %, Difference =', num2str((mean(areqxyzENU(2:end,3))-mean(areq.dE))*1E3,2),'mm');
        subtitle(subtit);
        title('AREQ Final results Comparison');
        xlabel('Date')
    dN=subplot(3,1,2);
        p1=errorbar(areq_nevada(:,4)+678942,areqxyzENU(:,2)*1E3,areq_nevada(:,16)*1E3,...
            '.','MarkerSize',15,'MarkerEdgeColor','blue');
        hold on
        p2=errorbar(areq.modifiedJulianDay+678942,areq.dN*1E3,areq.Sn*1E3,'r.', ...
            'MarkerSize',15,'MarkerEdgeColor','red');
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'Nevada Geodetic Laboratory','IAAPP'})
        ylabel('North (mm)');
        subtit=strcat('Difference in North component (dN), Reference Latitude: ' ...
            ,num2str(areq.neuReferencePosition(1),9),'°N');
        %, Difference =', num2str((mean(areqxyzENU(2:end,3))-mean(areq.dE))*1E3,2),'mm');
        subtitle(subtit);
        xlabel('Date')
    dU=subplot(3,1,3);
        p1=errorbar(areq_nevada(:,4)+678942,areqxyzENU(:,3)*1E3,areq_nevada(:,17)*1E3,...
            '.','MarkerSize',15,'MarkerEdgeColor','blue');
        hold on
        p2=errorbar(areq.modifiedJulianDay+678942,areq.du*1E3,areq.Su*1E3,'r.', ...
            'MarkerSize',15,'MarkerEdgeColor','red');
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        legend([p1,p2],{'Nevada Geodetic Laboratory','IAAPP'})
        ylabel('Up (mm)');
        subtit=strcat('Difference in Vertical component (dU), Reference Altitude: ' ...
            ,num2str(areq.neuReferencePosition(3),9),'m');
        %, Difference =', num2str((mean(areqxyzENU(2:end,3))-mean(areq.dE))*1E3,2),'mm');
        subtitle(subtit);
        xlabel('Date')
    linkaxes([dE,dN,dU],'x');
end