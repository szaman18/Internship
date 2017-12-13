cd('E:\Internship\New Task')
load('khan.mat')

%i = 7;%select the station

for i = 1:7
    if i == 1
        station = s1039v;
    elseif i == 2
        station = s640v;
    elseif i == 3
        station = s679v;
    elseif i == 4
        station = s677v;
    elseif i == 5
        station = s667v;
    elseif i == 6
        station = s697v;
    elseif i == 7
        station = s700v;
    end
    
    
    %station_name = varname(s700v);
    nom_voltage = 232;
    
    n = 161280/(4*60*24); %total number of days
    %n = 28;
    
    
    if i == 1 || i == 4
        Va = station(:,1)./100/2;
        Vb = station(:,2)./100/2;
        Vc = station(:,3)./100/2;
    else
        Va = station(:,1)/100;
        Vb = station(:,2)/100;
        Vc = station(:,3)/100;
    end
    
    
    % Voltage---phase a
    Va(Va == 0) = nom_voltage; % Replace zeros
    % Take 10 mean average
    Va_phase = reshape(Va,40,[]); %10 mins = 40 readings
    Va_phase = mean(Va_phase);
    
    % Voltage --- phase b
    Vb(Vb == 0) = nom_voltage; % Replace zeros
    % Take 10 mean average
    Vb_phase = reshape(Vb,40,[]);  %10 mins = 40 readings
    Vb_phase = mean(Vb_phase);
    
    % Voltage --- phase c
    Vc(Vc == 0) = nom_voltage;     % Replace zeros
    % Take 10 mean average
    Vc_phase = reshape(Vc, 40, []); %10 mins = 40 readings
    Vc_phase = mean(Vc_phase);
    
    t1 = datenum(2017,5,1,00,00,00);
    del_t = datenum(0,0,0,0,10,00);
    t2 = t1 + n - del_t;            %change n(no. of days) for changing time duration for the plot
    
    % Voltage Quality Plots
    
    % t = t1:del_t:t2;length(t)
    % figure('Name',['Station ',num2str(i)]);
    % plot(t,Va_phase(1:length(t)),'b',t,Vb_phase(1:length(t)),'c',t,Vc_phase(1:length(t)),'y');
    % datetick('x','dd:mm:yy','keepticks','keeplimits')
    % xlabel('time duration');ylabel('Voltage (V)');
    % legend('Va','Vb','Vc');
    % title(['Three Phase Voltages: Station ',num2str(i)]);
    % hold on
    % uppervoltage = nom_voltage + 0.1 * nom_voltage;
    % plot(t,ones(size(t)) * uppervoltage, 'r')
    %
    % lowervoltage = nom_voltage - 0.1 * nom_voltage;
    % plot(t,ones(size(t)) * lowervoltage, 'r')
    % hold off
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%    Unbalance Factor calculation ---CIGRE Definition
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Vab = Va*sqrt(3);
    Vbc = Vb*sqrt(3);
    Vca = Vc*sqrt(3);
    
    num_beta = Vab.^4 + Vbc.^4 + Vca.^4;
    den_beta = (Vab.^2 + Vbc.^2 + Vca.^2).^2;
    beta = num_beta./den_beta;
    
    num1 = (1-sqrt(3-6*beta));
    den1 = (1 +sqrt(3-6*beta));
    
    Unbalance_factor = sqrt(num1./den1)*100;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Unbalance Factor calculation ---PVUR
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    Vavg = (Va + Vb + Vc)./3;
    
    num2 = [abs(Va - Vavg),abs(Vb - Vavg),abs(Vc - Vavg)];
    num2 = max(num2,[],2);
    
    PVUR = (num2./Vavg)*100;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Unbalance Factor calculation ---PVUR1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % V = [Va, Vb, Vc];
    % Vmax = max(V,[],2);
    %
    % Vmin = min(V,[],2);
    %
    % PVUR1 = ((Vmax - Vmin)./Vavg)*100;
    
    t1 = datenum(2017,5,1,00,00,00);
    del_t = datenum(0,0,0,0,0,15);
    t2 = t1 + n - del_t;
    
    % Plot:Unbalance Factor
    
    t = t1:del_t:t2;length(t);
    figure('Name',['Station ',num2str(i)]);
    plot(t,Unbalance_factor(1:length(t)),t,PVUR(1:length(t)));     %%t,PVUR1(1:length(t)));
    datetick('x','dd:mm:yy','keepticks','keeplimits')
    xlabel('time duration');ylabel('%Unbalance Factor');
    legend('CIGRE','%PVUR');                                      %%'%PVUR1');
    title(['Unbalance Factor: Station ',num2str(i)]);
    
end