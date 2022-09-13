function x = estimateGnssOffset(laserData,gnssData,minico)
    %% TARGET A Constants
    %%%Inport GNSS Constants
        tara.gnssLat   =  mean(gnssData.tara.Nlat);
        tara.gnssLong  =  mean(gnssData.tara.Elong)-360;
        tara.gnssAlt   =  mean(gnssData.tara.HeightUp);

    %%%Inport SLR constants
        tara.slrRange =  mean(laserData.tgta.rawRange);
        tara.elev     =  mean(laserData.tgta.elev);
        tara.az       =  mean(laserData.tgta.azim);
    %% TARGET B Constants
    %%%Inport GNSS Constants
        tarb.gnssLat   =  mean(gnssData.tarb.Nlat);
        tarb.gnssLong  =  mean(gnssData.tarb.Elong)-360;
        tarb.gnssAlt   =  mean(gnssData.tarb.HeightUp);

    %%%Inport SLR constants
        tarb.slrRange =  mean(laserData.tgtb.rawRange);
        tarb.elev     =  mean(laserData.tgtb.elev);
        tarb.az       =  mean(laserData.tgtb.azim);

   %% Minimization Problem
     options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton','StepTolerance',1e-20);
     x0 = [0,0,1.80,0,0,1.80,-2.6790,-0.0140,0.0020];
     fun = @errorModel;
     [x,fval,exitflag,output] = fminunc(fun,x0,options);
   %% Plot functions
      disp(x);
      fprintf('ecc_une: [%f,%f,%f]m\n',x(7),x(8),x(9));  
      fprintf('Target A offsets: \n');  
      fprintf('Azimut: %f deg, Elev: %f deg, Height: %f m\n',x(2)*180/pi,x(1)*180/pi,x(3));
      fprintf('Target B offsets: \n');  
      fprintf('Azimut: %f deg, Elev: %f deg, Height: %f m\n',x(4)*180/pi,x(5)*180/pi,x(6));

      
    %% User defined functions
    function f = slrModel(data,elevoff,azoff,hoff,eccu,eccn,ecce)
     %% Calculate GNSS ENU Coordinates
        %%%Convert to Arel reference frame
        gnssENU=lla2enu([data.gnssLat,data.gnssLong,data.gnssAlt], [minico(1).lla(1), ...
            minico(1).lla(2)-360,minico(1).lla(3)],"ellipsoid");
        %%%Add GNSS offset
        gnssENU(:,3)=gnssENU(:,3)+hoff;

    %% Calculate SLR ENU Coordinates
        [dNx1,dEx1,dUx1]=sph2cart(data.az+azoff,data.elev+elevoff,data.slrRange); 
        %%Add offsets
        dNx1=dNx1-eccn;
        dEx1=dEx1-ecce;
        dUx1=dUx1-eccu;
    %% Calculate Error function
        f = ((gnssENU(:,2)-dNx1)^2+(gnssENU(:,1)-dEx1)^2+(gnssENU(:,3)-dUx1)^2)^(1/2);
    end
    
    function f = errorModel(x)
        %% Inputs
        elevoffTgta  = x(1);
        azoffTgta    = x(2);  
        hoffTgta     = x(3);  
        elevoffTgtb  = x(4);
        azoffTgtb    = x(5);  
        hoffTgtb     = x(6); 
        eccu         = x(7);
        eccn         = x(8);
        ecce         = x(9);
        %% Calculate
        f1 = slrModel(tara,elevoffTgta,azoffTgta,hoffTgta,eccu,eccn,ecce);
        f2 = slrModel(tarb,elevoffTgtb,azoffTgtb,hoffTgtb,eccu,eccn,ecce);
        %% Error function
        f = abs(f1)+abs(f2);
    end

end