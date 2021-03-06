clear, clc
close all;
% Developed by Bespi123 

areg=ReadGamitFiles('AREG.mit.final.igs14.pos');
areq=ReadGamitFiles('AREQ.mit.final.igs14.pos');
mtpi=ReadGamitFiles('MTPI.mit.final.igs14.pos');
mtpi_ingemmet = ReadGamitFiles('MTPI.ovi.orbit_sam14.pos');
areq_nevada = readmatrix('AREQ.Geoff.txt');

%%Calculate Baselines
CalculateBaseline(areq,areg)
CalculateBaseline(mtpi,areq)
CalculateBaseline(mtpi,areg)

%%Plot areqxyzENUfigures
plotGamitNEU(areg,'01-01-2021','01-01-2022',6);
plotGamitNEU(areq,'01-01-2021','01-01-2022',6);
plotGamitNEU(mtpi,'01-01-2021','01-01-2022',6);
%plotMTPIdata(mtpi_ingemmet);

comparison(mtpi_ingemmet,mtpi,areq_nevada,areq,'01-02-2021','01-01-2022',6);

%% Function to plot ingemmet files
function plotMTPIdata(mtpi_ingemmet)
    figure()
    dE=subplot(3,1,1);
        errorbar(mtpi_ingemmet(2:end,3)+678942,mtpi_ingemmet(2:end,16),mtpi_ingemmet(2:end,19),'s','MarkerSize',3,...
        'MarkerEdgeColor','red','MarkerFaceColor','red')
        grid on
        title('MTPI: Difference in North component(dN)');
        datetick('x','dd/mm/yy')
    dN=subplot(3,1,2);
        errorbar(mtpi_ingemmet(2:end,3)+678942,mtpi_ingemmet(2:end,17),mtpi_ingemmet(2:end,20),'s','MarkerSize',3,...
        'MarkerEdgeColor','red','MarkerFaceColor','red')
        grid on
        title('MTPI: Difference in East component(dE)');
        datetick('x','dd/mm/yy')
    dU=subplot(3,1,3);
        errorbar(mtpi_ingemmet(2:end,3)+678942,mtpi_ingemmet(2:end,19),mtpi_ingemmet(2:end,21),'s','MarkerSize',3,...
        'MarkerEdgeColor','red','MarkerFaceColor','red')
        grid on
        title('MTPI: Difference in vertical component(dU)')
        datetick('x','dd/mm/yy')
    linkaxes([dE,dN,dU],'x');
end

%% General Plot function for GAMIT Files
function plotGamitNEU(areg,inicialDate,finalDate,ticksnum)
    figure();
    dN=subplot(3,1,1);
        errorbar(areg.modifiedJulianDay+678942,areg.dN*1E3,areg.Sn*1E3,'.','MarkerEdgeColor','red')
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);        
        %datetick('x','dd/mm/yy');
        subtit=strcat('Difference in North component (dN), Reference latitude: ' ...
            ,num2str(areg.neuReferencePosition(1),9),'??N, RMS =', num2str(mean((areg.Sn)*1E3),2),'mm');
        title(areg.name,subtit);
        ylabel('North (mm)')        
    dE=subplot(3,1,2);
        errorbar(areg.modifiedJulianDay+678942,areg.dE*1E3,areg.Se*1E3,'.','MarkerEdgeColor','red')
        grid on
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');  
        subtit=strcat('Difference in East component(dE), Reference longitude: ' ...
            ,num2str(areg.neuReferencePosition(2),9),'??E, RMS =', num2str(mean((areg.Se)*1E3),2),'mm');
        subtitle(subtit);
        %xlabel('DOY')
        ylabel('East (mm)')
    dU=subplot(3,1,3);
        errorbar(areg.modifiedJulianDay+678942,areg.du,areg.Su,'.','MarkerEdgeColor','red')
        time = linspace(datenum(inicialDate),datenum(finalDate),ticksnum);
        xticks(time);
        xticklabels(cellstr(datestr(time,2)));
        xlim([datenum(inicialDate) datenum(finalDate)]);
        %datetick('x','dd/mm/yy');
        grid on
        subtit=strcat('Difference in Vertical component(dU), Reference height: ' ...
            ,num2str(areg.neuReferencePosition(3),9),'m, RMS =', num2str(mean((areg.Su)*1E3),2),'mm');
        subtitle(subtit);
        ylabel('Up (mm)')
    linkaxes([dE,dN,dU],'x');
end

%% Baseline Calculation
function CalculateBaseline(site1,site2)
   %%Intersection between site1 and site2
   [time,is1,is2]=intersect(site1.modifiedJulianDay,site2.modifiedJulianDay);

    %%Transform site2 to site1 NEU reference frame for comparisson
    xyzENU=lla2enu([site2.Nlat,site2.Elong-360,site2.HeightUp] ...
     ,[site1.neuReferencePosition(1),site1.neuReferencePosition(2)-360,site1.neuReferencePosition(3)],"ellipsoid");
   %%Substract site1-site2    
   dxE=site1.dE(is1(1):is1(1)+length(is1)-1)-xyzENU(is2(1):is2(1)+length(is2)-1,1);
   dyN=site1.dN(is1(1):is1(1)+length(is1)-1)-xyzENU(is2(1):is2(1)+length(is2)-1,2);
   dzU=site1.du(is1(1):is1(1)+length(is1)-1)-xyzENU(is2(1):is2(1)+length(is2)-1,3);
   %%Calculate mean values
   dxE_mean=mean(dxE)*ones(1,length(is1));
   dyN_mean=mean(dyN)*ones(1,length(is1));
   dzU_mean=mean(dzU)*ones(1,length(is1));

  figure()
  dE=subplot(3,1,1);
        Se=site1.Se(is1(1):is1(1)+length(is1)-1)+site2.Se(is2(1):is2(1)+length(is2)-1);
        p1=errorbar(time+678942,dxE,Se,'.','MarkerEdgeColor','red');
        hold on
        p2=plot(time+678942,dxE_mean,'g--','LineWidth',3);
        grid on
        datetick('x','dd/mm/yy');
        tit=strcat(site1.name,'-',site2.name);
        subtit=strcat('Difference in North component (dN), Reference latitude: ' ...
            ,num2str(site1.neuReferencePosition(1),9),'??N, RMS =', num2str(mean((Se)*1E3),2),'mm');
        title(tit,subtit);
        %ax = gca;
        %ax.TitleHorizontalAlignment = 'left';
        %ax.FontSize = 8;
        %xlabel('DOY')
        ylabel('North (m)')
        leg=strcat('Mean: ', num2str(mean(dxE)),'m');
        legend([p1,p2],{'Baseline',leg})
    dN=subplot(3,1,2);
        Sn=site1.Sn(is1(1):is1(1)+length(is1)-1)+site2.Sn(is2(1):is2(1)+length(is2)-1);
        p1=errorbar(time+678942,dyN,Sn,'.','MarkerEdgeColor','red');
        hold on
        p2=plot(time+678942,dyN_mean,'g--','LineWidth',3);
        grid on
        datetick('x','dd/mm/yy');
        subtit=strcat('Difference in East component (dE), Reference longitude: ' ...
            ,num2str(site1.neuReferencePosition(2),9),'??E, RMS =', num2str(mean((Sn)*1E3),2),'mm');
        subtitle(subtit);
        %xlabel('DOY')
        ylabel('East (m)')
        leg=strcat('Mean: ', num2str(mean(dyN)),'m');
        legend([p1,p2],{'Baseline',leg})
    dU=subplot(3,1,3);
        Su=site1.Su(is1(1):is1(1)+length(is1)-1)+site2.Su(is2(1):is2(1)+length(is2)-1);
        p1=errorbar(time+678942,dzU,Su,'.','MarkerEdgeColor','red');
        hold on
        p2=plot(time+678942,dzU_mean,'g--','LineWidth',3);
        grid on
        datetick('x','dd/mm/yy');
        subtit=strcat('Difference in Vertical component (dU), Reference altitude: ' ...
            ,num2str(site1.neuReferencePosition(3),9),'m, RMS =', num2str(mean((Su)*1E3),2),'mm');
        subtitle(subtit);   
        xlabel('Date')
        ylabel('Up (m)')
        leg=strcat('Mean: ', num2str(mean(dzU)),'m');
        legend([p1,p2],{'Baseline',leg})
    linkaxes([dE,dN,dU],'x');
end

function comparison(mtpi_ingemmet,mtpi,areq_nevada,areq,inicialDate,finalDate,ticksnum)
    %%Transform Ingemmet processing to IAAPP processing NEU reference frame for
    %%comparisson
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
            ,num2str(mtpi.neuReferencePosition(2),9),'??E, Difference =', num2str((mean(mtpixyzENU(2:end,1))-mean(mtpi.dE))*1E3,2),'mm');
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
            ,num2str(mtpi.neuReferencePosition(1),9),'??N, Difference =', num2str((mean(mtpixyzENU(2:end,2))-mean(mtpi.dN))*1E2,2),'cm');
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
            ,num2str(mtpi.neuReferencePosition(2),9),'??E, Difference =', num2str((mean(mtpixyzENU(2:end,1))-mean(mtpi.dE))*1E3,2),'mm');
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
            ,num2str(mtpi.neuReferencePosition(1),9),'??N, Difference =', num2str((mean(mtpixyzENU(2:end,2))-mean(mtpi.dN))*1E2,2),'cm');
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
            ,num2str(areq.neuReferencePosition(2),9),'??E');
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
            ,num2str(areq.neuReferencePosition(1),9),'??N');
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