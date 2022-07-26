function [Omean,Osdeviation] = dataAnalitics(data,p,num)
%dataAnalitics: This function reads the input data and perform an
%stadistical analisys. If data has two rows, the first row is taken as the
%value and the second data is taken as its proper standard deviation.
% Inputs:
%   data : data to analisys
%   p: plot flag (1 = y, 0 = N)
%   num: The number of ranges in the histogram

%   Determine data vector size
    [m, n] = size(data);
    if(m > n)
        data = data';
        Size = n;
    else
        Size = m;
    end
%   Assign data values
    switch Size
        case 0
            disp('Error: Empty data.');
        case 1
            disp('Single data.');
            dataI = data(1,:);
            %   Perform statistical analisys
            Mean = mean(dataI);
            Sdeviation = std(dataI);
            %   Plot Resoults
            if (p == 1)
                figure()
                x = (Mean-3*Sdeviation):.0001:(Mean+3*Sdeviation);
                y = normpdf(x,Mean,Sdeviation);
                plot(x,y,'b--')
                hold on 
                histogram(dataI,num,'DisplayStyle','stairs');
                legend('Gaussian distribution','Data distribution')
                grid on
            end
        otherwise
            disp('Error: Too many arguments')
    end
    
%   Prepare the Output
    Omean = Mean;
    Osdeviation = Sdeviation;
end

