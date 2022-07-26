function [fig] = plotNEU(GAMITdata,DOY,clean,trigg,name)
%plotNEU: Is a function that plots the NEU data from the GAMIT Matrix. This
%data can be ploted without any intervention or cleaning the outliers.
%Inputs:
%GAMITdata: Is the GAMIT matrix
%DOY: Initial Day of year
%clean: cleaning flag (0 = N, 1 = Y)
%trigg: the value to discriminate data

% Clean data
% Build DOY vector
[n,m] = size(GAMITdata);
a=[DOY:1:DOY+n-1]';

if(m == 25)
    switch clean
        case 0
            data = [a,GAMITdata];
        case 1
            GAMITdata = [a,GAMITdata];
            data = [];
            for i = 1:n
                if(GAMITdata(i,20) < trigg)
                    data=[data; GAMITdata(i,:)];
                end
            end
        otherwise
            disp('Error: Too many arguments')
            return
    end
    
    fig = figure();
    subplot(3,1,1)
        errorbar(data(:,4)+678942,data(:,17),data(:,20),'.','MarkerEdgeColor','red')
        grid on
        datetick('x','dd/mm/yy');
        tit=strcat(name,': Difference in North component(dN)');
        title(tit);
        xlabel('DOY')
        ylabel('dN')
    subplot(3,1,2)
        errorbar(data(:,4)+678942,data(:,18),data(:,21),'.','MarkerEdgeColor','red')
        grid on
        datetick('x','dd/mm/yy');
        tit=strcat(name,': Difference in East component(dE)');
        title(tit);
        xlabel('DOY')
        ylabel('dE')
    subplot(3,1,3)
        errorbar(data(:,4)+678942,data(:,19),data(:,22),'.','MarkerEdgeColor','red')
        grid on
        datetick('x','dd/mm/yy');
        tit=strcat(name,': Difference in vertical component (dU)');
        title(tit);   
        xlabel('DOY')
        ylabel('dU')
elseif (m == 22)
    figure()
    subplot(3,1,1);
    errorbar(GAMITdata(1:176,17)',GAMITdata(1:176,7)',GAMITdata(1:176,8),'.','MarkerEdgeColor','red');
    title('NEU Coordinates')
    grid on;
    ylabel('dNorth(m)');
    subplot(3,1,2);
    errorbar(GAMITdata(1:176,17)',GAMITdata(1:176,9)',GAMITdata(1:176,10)','.','MarkerEdgeColor','red');
    grid on;
    ylabel('dEast(m)');
    subplot(3,1,3);
    errorbar(GAMITdata(1:176,17)',GAMITdata(1:176,11)',GAMITdata(1:176,12)','.','MarkerEdgeColor','red');
    grid on;
    ylabel('dHeight(m)');
    xlabel('DOY');
else
    disp('Not supported matrix');
end
end

