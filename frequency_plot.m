cd('E:\Internship\New Task')
load('khan.mat')

% station{1} = s1039fr; %465 ; 100
% 
% station{4} = s677fr;   %465 ; 100

station{1} = s1039fr;%
station{2} = s640fr;
station{3} = s679fr;
station{4} = s677fr;%
station{5} = s667fr;
station{6} = s697fr;
station{7} = s700fr;

for i = 1:7
    var_station = station{i};
    freq_station = station{i};
    nom_station = 50;
    n = 161280/(4*60*24); %total number of days
    %n = 28;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%    frequency plot
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if i == 1 || i == 4
        f = freq_station(:)/100/2;
        disp('100')
    else
        f = freq_station(:)/100;
        disp('50');
    end
        
    f(f == 0) = nom_station;

    t1 = datenum(2017,5,1,00,00,00);
    del_t = datenum(0,0,0,0,0,15);
    t2 = t1 + n - del_t;

    t = t1:del_t:t2;length(t);
    %figure('Name',['Station ', num2str(i), ' Frequency']);
    plot(t,f(1:length(t)));
    datetick('x','dd:mm:yy','keepticks','keeplimits')
    xlabel('time duration');ylabel('frequency (Hz)');
    title('Frequency');
    hold on

end
    
    legend('station1','station2','station3','station4','station5','station6','station7');
    upperstation = nom_station + 0.01 * nom_station;
    plot(t,ones(size(t)) * upperstation, 'g--')

    lowerstation = nom_station - 0.01 * nom_station;
    plot(t,ones(size(t)) * lowerstation, 'g--')
    hold off