clc;
clear all;

cd('E:\Internship\New Task')
load('khan.mat')
load('stationsmayjunecomplete.mat')

power_station{1} = stationsmayjune(1:161280,1);  % s1039v
power_station{2} = stationsmayjune(1:161280,7);  % s640v
power_station{3} = stationsmayjune(1:161280,13); % s679v
power_station{4} = stationsmayjune(1:161280,19); % s677v
power_station{5} = stationsmayjune(1:161280,25); % s667v
power_station{6} = stationsmayjune(1:161280,31); % s697v
power_station{7} = stationsmayjune(1:161280,37)*1000; % s700v

Volt{1} = s1039v;
Volt{2} = s640v;
Volt{3} = s679v;
Volt{4} = s677v;
Volt{5} = s667v;
Volt{6} = s697v;
Volt{7} = s700v;

n = 161280/(4*60*24);

t1 = datenum(2017,5,1,00,00,00);
del_t = datenum(0,0,0,0,0,15);
t2 = t1 + n - del_t;

t = t1:del_t:t2;length(t);

for i = 1:7
    % i = 7;
    voltage_station = Volt{i};
    
    if i == 1 || i == 4
        
        Va = voltage_station(:,1)./100/2;
        Vb = voltage_station(:,2)./100/2;
        Vc = voltage_station(:,3)./100/2;
        
    else
        
        Va = voltage_station(:,1)/100;
        Vb = voltage_station(:,2)/100;
        Vc = voltage_station(:,3)/100;
        
    end
    
    Va(Va == 0) = 230;
    Vb(Vb == 0) = 230;
    Vc(Vc == 0) = 230;
    
    Vrms = sqrt(((sqrt(3)*Va).^2 + (sqrt(3)*Vb).^2 + (sqrt(3)*Vc).^2)/9);
    
    data_power = power_station{i}/1000;
    
    day = 161280/28;% measurements per day
    for num_days = 1:3
        %        num_days = 4;
        n_start = 2 + num_days*day -day ; n_end = day * num_days;
        
        
        hrs = day/24;% measurements per hour
        %        for n_day = n_start : n_end
        
        K(:,:) = 0;
        for num_hrs = 1:24
            
            n_hrs_start = 2 + num_days*day - day + num_hrs*hrs - hrs;
            n_hrs_end = num_days*day - day + num_hrs*hrs;
            Kp(:,:) = 0;
            count = 0;
            
            for n = n_hrs_start:n_hrs_end
                
                num = (data_power(n) - data_power(n-1))/(data_power(n-1));
                den = (Vrms(n) - Vrms(n-1)) /(Vrms(n-1));
                
                
                if  sign(num) == sign(den) && den ~= 0 && num/den < 2
                    count = count + 1;
                    Kp(count,num_hrs) = num/den;
                else
                    continue;
                end
                
                
            end
            
            if count == 0
                K(num_hrs) = 0;
            else
                K(num_hrs) = sum(Kp(:,num_hrs))/count
            end
            
            
        end
        
        num_hrs = 1:24;
        figure('Name',['Station ',num2str(i), ': day ', num2str(num_days)]);
        bar(num_hrs,K(num_hrs))
        xlabel('Hours');ylabel('Sensivity');
        fig_name = ['Voltage Sensitivity of Station ', num2str(i),' (0',num2str(num_days), '-May-2017)'];
        title(fig_name);
        
    end
end