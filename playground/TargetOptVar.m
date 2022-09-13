function targetOptVar(lowth,highth,laserData,gnssData,offset) 
    %% Obtaining initial values 
    %%%Generate meshgrid                          
        [elevoff,azimuthoff] = meshgrid(lowth:.01:highth, lowth:.01:highth);                                  
    %%%Inport GNSS Constants
        gnssdN   =  mean(gnssData.ENU(:,2));
        gnssdE   =  mean(gnssData.ENU(:,1));
        gnssdU   =  mean(gnssData.ENU(:,3));
    %%%Inport SLR constants
        slrRange =  mean(laserData.rawRange);
        gnssRange = mean(gnssData.range);
        elev     =  mean(laserData.elev);
        az       =  mean(laserData.azim);
    %%%Calculate rectangular coordinates and modulus
        [dN,dE,dU]=sph2cart(az+azimuthoff,elev+elevoff,slrRange);  
        slrRangeExp=(dN.^2+dE.^2+dU.^2).^(1/2);
    %%% Add offsets
        dN=dN-offset.slr.ecc_une(2);
        dE=dE-offset.slr.ecc_une(3);
        dU=dU-offset.slr.ecc_une(1);
    %%% Calculate function error
        Err=((gnssdN-dN).^2+(gnssdE-dE).^2+(gnssdU-dU).^2).^(1/2);
    %%% Plot Solution
        figure()
        s=surf(elevoff,azimuthoff,Err);
        s.EdgeColor = 'none';
        a=strcat('Target ',laserData.name);
        title(a);
        xlabel('Elevation Offset (rad)');
        ylabel('Azimuth Offset (rad)');
        zlabel('Error (m)');    
    %%% Calculate offsets that minimize error
        [Errmin,i]=min(Err(:));
    
    %% Minimization Problem
    options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','StepTolerance',1e-20);
    x0 = [azimuthoff(i),elevoff(i)];
    fun = @slrModel;
    [x,fval,exitflag,output] = fminunc(fun,x0,options);
    
    %% Recalculate Values
    %%%Calculate rectangular coordinates and modulus
        [dN,dE,dU]=sph2cart(az+x(1),elev+x(2),slrRange);  
        Errmin = ((gnssdN-dN).^2+(gnssdE-dE).^2+(gnssdU-dU).^2).^(1/2);
    %%% Add offsets
        dN=dN-offset.slr.ecc_une(2);
        dE=dE-offset.slr.ecc_une(3);
        dU=dU-offset.slr.ecc_une(1);
    %%% Calculate range    
        slrRangeExp=(dN.^2+dE.^2+dU.^2).^(1/2);

    %% Show results
    fprintf('dN err: %f, dE err: %f, dU err: %f, Min err: %f, azimuth offset: %f, Elevation offset: %f\n', ...
        (gnssdN-dN),(gnssdE-dE),(gnssdU-dU),Errmin,x(1)*180/pi,x(2)*180/pi);
    fprintf('Slr Range: %f, GNSS Range %f, Error: %f\n', mean(mean(slrRangeExp)), ...
        gnssRange ,mean(mean(slrRangeExp))-gnssRange )
    fprintf('Slr az: %f, GNSS az: %f\n',(az+x(1))*180/pi, ...
        mean(gnssData.az)*180/pi)
    fprintf('Slr elev: %f, GNSS elev: %f\n',(elev+x(2))*180/pi, ...
        mean(gnssData.elev)*180/pi)

    %% User defined functions
    function f = slrModel(x)
        [dNx1,dEx1,dUx1]=sph2cart(az+x(1),elev+x(2),slrRange); 
        %%Add offsets
        dNx1=dNx1-offset.slr.ecc_une(2);
        dEx1=dEx1-offset.slr.ecc_une(3);
        dUx1=dUx1-offset.slr.ecc_une(1);
        f = ((gnssdN-dNx1)^2+(gnssdE-dEx1)^2+(gnssdU-dUx1)^2)^(1/2);
    end
end