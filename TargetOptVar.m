
close all
%%Plot optval
[Elev,Azim] = meshgrid(0:0.01:6,0:0.01:6);
Elev=-5*pi/180:0.00000001:5*pi/180;

%%Problem Constants
zN=mean(arelRef.track.ENUtarcArel(:,2));
zE=mean(arelRef.track.ENUtarcArel(:,1));
zU=mean(arelRef.track.ENUtarcArel(:,3));
ab=mean(datatgtC.distFilt(10:end));
%dN=ab*cos(minico(1).targets.targetA.elevation+Elev)*cos(minico(1).targets.targetA.azimuth+offset.offanglesTarA(1));
%dE=ab*cos(minico(1).targets.targetA.elevation+Elev)*sin(minico(1).targets.targetA.azimuth+offset.offanglesTarA(1));
dN=ab*cos(minico(1).targets.targetC.elevation+Elev)*cos(minico(1).targets.targetC.azimuth+offset.offanglesTarC(1));
dE=ab*cos(minico(1).targets.targetC.elevation+Elev)*sin(minico(1).targets.targetC.azimuth+offset.offanglesTarC(1));
dU=ab*sin(minico(1).targets.targetC.elevation+Elev);

Err=abs(zN-dN)+abs(zE-dE)+abs(zU-dU);
figure()
plot(Elev,Err)
%surf(Elev,Azim,dN)
%figure()
%surf(Elev,Azim,dE)
%figure()
%surf(Elev,Azim,Err)
[Errmin,i]=min(Err(:));
%x=[Elev(i)*180/pi,Azim(i)*180/pi], 
x=Elev(i)*180/pi
Errmin

figure()
plot(Elev,abs(zU-dU),Elev,20*1E-2*ones(1,length(dU)))
% % %%Plot optval
% % %[Elev,Azim] = meshgrid(-5*pi/180:0.001:5*pi/180,-5*pi/180:0.1:5*pi/180);
%  Elev=-100*pi/180:0.00001:100*pi/180;
% % %%Problem Constants
%  zN=mean(arelRef.track.ENUtarcArel(:,2));
%  zE=mean(arelRef.track.ENUtarcArel(:,1));
%  ab=mean(datatgtC.distFilt(10:end));
%  dN=ab*cos(minico(1).targets.targetC.elevation+Elev).*cos(minico(1).targets.targetC.azimuth+1.3373*pi/180);
%  dE=ab*cos(minico(1).targets.targetC.elevation+Elev).*sin(minico(1).targets.targetC.azimuth+1.3373*pi/180);
%  figure
%  Err=abs(zN-dN)+abs(zE-dE);
%  plot(Elev,Err)
% % %surf(Elev,Azim,dN)
% % %figure()
% % %surf(Elev,Azim,dE)
% % %figure()
% % %surf(Elev,Azim,Err)
%  [Errmin,i]=min(Err);
% % % %x=[Elev(i)*180/pi,Azim(i)*180/pi], 
%   x=Elev(i)*180/pi
%   Errmin

% %%Plot optval
% %[Elev,Azim] = meshgrid(-5*pi/180:0.001:5*pi/180,-5*pi/180:0.1:5*pi/180);
% Elev=-100*pi/180:0.0001:100*pi/180;
% %%Problem Constants
% zN=mean(arelRef.track.ENUtarbArel(:,2));
% zE=mean(arelRef.track.ENUtarbArel(:,1));
% ab=mean(datatgtB.distFilt(10:end));
% dN=ab*cos(minico(1).targets.targetB.elevation+Elev).*cos(minico(1).targets.targetB.azimuth-0.1416*pi/180);
% dE=ab*cos(minico(1).targets.targetB.elevation+Elev).*sin(minico(1).targets.targetB.azimuth-0.1416*pi/180);
% figure
% Err=abs(zN-dN)+abs(zE-dE);
% plot(Elev,Err)
% % %surf(Elev,Azim,dN)
% % %figure()
% % %surf(Elev,Azim,dE)
% % %figure()
% % %surf(Elev,Azim,Err)
% [Errmin,i]=min(Err(:));
% % %x=[Elev(i)*180/pi,Azim(i)*180/pi], 
%  x=Elev(i)*180/pi
%  Errmin


%%Plot optval
%[Elev,Azim] = meshgrid(-3*pi/180:0.0001:5*pi/180,-5*pi/180:0.1:3*pi/180);

% %%Problem Constants
% zN=mean(arelRef.track.ENUtarcArel(:,2));
% zE=mean(arelRef.track.ENUtarcArel(:,1));
% ab=mean(datatgtC.distFilt(10:end));
% %dN=ab*cos(minico(1).targets.targetC.elevation+Elev).*cos(minico(1).targets.targetC.azimuth+offset.offanglesTarC(1));
% %dE=ab*cos(minico(1).targets.targetC.elevation+Elev).*sin(minico(1).targets.targetC.azimuth+offset.offanglesTarC(1));
% dN=ab*cos(minico(1).targets.targetC.elevation+Elev).*cos(minico(1).targets.targetC.azimuth+Azim);
% dE=ab*cos(minico(1).targets.targetC.elevation+Elev).*sin(minico(1).targets.targetC.azimuth+Azim);
% %figure()
% Err=abs(zN-dN)+abs(zE-dE);
% figure()
% surf(Elev,Azim,Err)
% 
% [Errmin,i]=min(Err(:));
% x=[Elev(i)*180/pi,Azim(i)*180/pi], Errmin



%%Create an optimization problem.
% prob = optimproblem('ObjectiveSense','min');
% xoptvar = optimvar('xoptvar',1,1,'LowerBound',0);
% 
% dN = ab*cos(minico(1).targets.targetA.elevation+xoptvar)...
%         *cos(minico(1).targets.targetA.azimuth+offset.offanglesTarA(1));
% prob.Objective =zz-dN;
% cons1 = xoptvar <= 100;
% cons2 = xoptvar >= -100;
% prob.Constraints.cons1 = cons1;
% prob.Constraints.cons2 = cons2;
% show(prob);
% sol0.xoptvar=-3.1098;
% sol = solve(prob,sol0);
% sol.xoptvar*180/pi;