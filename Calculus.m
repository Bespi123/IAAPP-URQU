%Plot NEU coordinates
close all

%% Calculus in the AREL reference
%Espacial definitions
 tAdn_pos=[];
 tAdn_neg=[];
 tBdn_pos=[];
 tBdn_neg=[];
 tCdn_pos=[];
 tCdn_neg=[];
 x=[];
 y=[];
 
%Target A circles
 tAde_a=-50:0.1:127.2;
 %tAradius=norm([xNorthA,yEastA]);        %% Radious calculated by gnss
 tAradius=norm([mean(dataTgtA(:,9)),mean(dataTgtA(:,10))]); %% LRS
 %TarA coordinates calculated by TRACK
 Ntgta_arel = mean(xNorthA); %%North component respect to AREL
 Etgta_arel = mean(yEastA);  %%East component respect to AREL
 
 for i=1:1:length(tAde_a)
     tAdn_pos=[tAdn_pos,(tAradius^2-(tAde_a(i)-Etgta_arel)^2)^(1/2)+Ntgta_arel];
     tAdn_neg=[tAdn_neg,-(tAradius^2-(tAde_a(i)-Etgta_arel)^2)^(1/2)+Ntgta_arel];
 end
 
%Target B circles
 tBde_a=-27.06:0.1:185;
 %tBradius=norm([xNorthB,yEastB]);        %% Radious calculated by gnss
 tBradius=norm([mean(dataTgtB(:,9)),mean(dataTgtB(:,10))]); %% LRS
 %TarB coordinates calculated by TRACK
 Ntgtb_arel = mean(xNorthB); %%North component respect to AREL
 Etgtb_arel = mean(yEastB);  %%East component respect to AREL

 for i=1:1:length(tBde_a)
    tBdn_pos=[tBdn_pos,(tBradius^2-(tBde_a(i)-Etgtb_arel)^2)^(1/2)+Ntgtb_arel];
    tBdn_neg=[tBdn_neg,-(tBradius^2-(tBde_a(i)-Etgtb_arel)^2)^(1/2)+Ntgtb_arel];
 end
 
%Target C circles
 tCde_a=-50:0.1:350;
 %tCradius=norm([xNorthC,yEastC]);        %% Radious calculated by gnss
 tCradius=norm([mean(dataTgtC(:,9)),mean(dataTgtC(:,10))]); %% LRS
 %TarC coordinates calculated by TRACK
 Ntgtc_arel = mean(xNorthC); %%North component respect to AREL
 Etgtc_arel = mean(yEastC);  %%East component respect to AREL

 for i=1:1:length(tCde_a)
    tCdn_pos=[tCdn_pos,(tCradius^2-(tCde_a(i)-Etgtc_arel)^2)^(1/2)+Ntgtc_arel];
    tCdn_neg=[tCdn_neg,-(tCradius^2-(tCde_a(i)-Etgtc_arel)^2)^(1/2)+Ntgtc_arel];
 end

%Calculate TLRS-3 position
 A=tAradius^2-(Etgta_arel^2+Ntgta_arel^2);
 B=tBradius^2-(Etgtb_arel^2+Ntgtb_arel^2);
 C=tCradius^2-(Etgtc_arel^2+Ntgtc_arel^2);
 a=Etgtb_arel-Etgta_arel;
 b=Ntgtb_arel-Ntgta_arel;
 c=Etgtb_arel-Etgtc_arel;
 d=Ntgtb_arel-Ntgtc_arel;
 for i=1:1:length(A)
     x=[x;(A(i)-B(i))/(2*a(i))-(b(i)*((C(i)-B(i))-(A(i)-B(i)))/(2*(d(i)*a(i)-b(i)*c(i))))];
     y=[y;(a(i)*((C(i)-B(i))-(A(i)-B(i))))/(2*(d(i)*a(i)-b(i)*c(i)))];
 end
 
%% Calculate LLA coordinates
AREL_calc=enu2lla([x,y,arelalt],[arellat,360-arellong,arelalt],"flat");

%Get Areg coordinates
%Areglat  =-16.465423319;
%Areglong =288.507095868;
%Aregalt  =2489.3371;
%wgs84 = wgs84Ellipsoid('meter');
%[AregEast, AregNorth, AregUp] = geodetic2enu(Areglat, Areglong , Aregalt,arellat,arellong,arelalt,wgs84);
 
 figure(1)
 plot(tAde_a,[tAdn_pos;tAdn_neg],'--r');
 hold on
 grid on
 plot(Etgta_arel,Ntgta_arel,'r.');
 quiver(0,0,Etgta_arel,Ntgta_arel,0,'r','LineWidth',2)
 text(Etgta_arel+1,Ntgta_arel,'Target A','Color','red','FontSize',20)   

 plot(tBde_a,[tBdn_pos;tBdn_neg],'--g');
 plot(Etgtb_arel,Ntgtb_arel,'g.');
 quiver(0,0,Etgtb_arel,Ntgtb_arel,0,'g','LineWidth',2)
 text(Etgtb_arel+1,Ntgtb_arel,'Target B','Color','green','FontSize',20)

 plot(tCde_a,[tCdn_pos;tCdn_neg],'--b');
 plot(Etgtc_arel,Ntgtc_arel,'b.');
 quiver(0,0,Etgtc_arel,Ntgtc_arel,0,'b','LineWidth',2)
 text(Etgtc_arel+1,Ntgtc_arel,'Target C','Color','blue','FontSize',20)

 %plot(AregEast, AregNorth,'m.');
 %text(AregEast+1,AregNorth,'AREG','Color','magenta','FontSize',20);
 
 plot(x,y,'k.');
 text(x+1,y,'AREL','Color','black','FontSize',20);
 ylabel('North Component (m)')
 xlabel('East Component (m)')
 tit=strcat('NEU Coordinates; Reference: (', num2str(arellat,'%.4f'),' ,', ...
     num2str(arellong,'%.4f'), ' ,', num2str(arelalt,'%.4f'),')');
 title(tit);
 xlim([-10 320]);
 ylim([-400 200]);

 
 figure(2)
 gx = geoaxes;
 geoplot(gx,mean(taraGEOD(1:176,4)),mean(taraGEOD(1:176,5)),'r.');
 geobasemap(gx,'satellite');
 hold on
 %quiver(arellat,arellong,mean(taraGEOD(1:176,4)),mean(taraGEOD(1:176,5)),0,'r','LineWidth',2)
 dimen = [.3 .1 .5 .5];
 %a = annotation('arrow',[arellat,arellong],[0.7 0.8])
 %a.Position = dimen;
 %a.Color = [1 0 0];
 %a.LineWidth = 2;
 %a.HeadStyle = 'vback3';

 geoplot(mean(tarbGEOD(1:176,4)),mean(tarbGEOD(1:176,5)),'g.');
 geoplot(mean(tarcGEOD(1:176,4)),mean(tarcGEOD(1:176,5)),'b.');
 %geoplot(mean(aregGEOD(1:176,4)),mean(aregGEOD(1:176,5)),'r.');
 %geoplot(-16.4647809952,288.5072384849,'go');
 %geoplot(-16.4647809919,288.5072384866,'go');
 %geoplot(-16.4650797669,288.5077793856,'go');
 %geoplot(-16.4650797649,288.5077793883,'go');
 %geoplot(-16.4650797649,288.5077793883,'go');
 geoplot(AREL_calc(1),360-AREL_calc(2),'b.');
 geoplot(arellat,arellong,'b.');
