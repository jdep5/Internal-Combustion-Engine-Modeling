% Jake DePiero
% ME 4056 - A1
% IC Engines HW 
% Due 3/30/2020

%% Part I.


% Angle

data = xlsread('No-Head Characterization - Remote.xlsx',1);
times = data(:,1);
low_rpm_angle = data(:,3);
med_rpm_angle = data(:,6);
high_rpm_angle = data(:,9);
allfly_angle = data(:,12);
nofly_angle = data(:,15);
times_fly = data(:,10);

% torque
data2 = xlsread('No-Head Characterization - Remote.xlsx',2);
times2 = data2(:,1);
low_t = data2(:,3);
med_t = data2(:,6);
high_t = data2(:,9);
fly_times2 = data2(:,10);
allfly_t = data2(:,12);
nofly_t = data2(:,15);


angle = allfly_angle;
time = fly_times2;
torque = allfly_t;

%% Part II. 

%% 1. 

% plot 

figure

subplot(2,1,1)
plot(time,angle,'r*')
xlabel('Time [s]')
ylabel('Angle [deg]')

subplot(2,1,2)
plot(time,angle,'r*')
xlim([1.85,2.3])
xlabel('Time [s]')
ylabel('Angle [deg]')

%% 2. 

initial = angle(1); % first angle value
continuous = [initial];
final = 0; % initialize

% 2 cases 

for i = 2:length(time)
    differ = angle(i) - angle(i-1);
    if differ >= 0
        continuous = [continuous; angle(i)+final];
    else 
        final = final + angle(i-1);
        continuous = [continuous; angle(i)+final];
    end
    
end

% plot

figure

subplot(2,1,1)
plot(time,continuous,'r.')
xlabel('Time [s]')
ylabel('Angle [deg]')

subplot(2,1,2)
plot(time,continuous,'r.')
xlim([1.85,2.3])
xlabel('Time [s]')
ylabel('Angle [deg]')

%% 3 and 4

% initialize values 

angle_initial = [];
time_initial = [];
torque_initial = [];
avg_angle_vector = [];
avg_time_vector = [];
avg_torque_vector = [];
differ = 0;

% compare

for i = 2:length(time)
   
    differ = continuous(i) - continuous(i-1); 
    
    if differ == 0
        angle_initial = [angle_initial; continuous(i)]; 
        torque_initial = [torque_initial; torque(i)];
        time_initial = [time_initial; time(i)];
    else
        avg_angle = mean(angle_initial);
        avg_torq = mean(torque_initial);
        avg_time = time_initial(end);
        avg_angle_vector = [avg_angle_vector; avg_angle];
        avg_torque_vector = [avg_torque_vector; avg_torq];
        avg_time_vector = [avg_time_vector; avg_time];
        angle_initial = continuous(i); 
        torque_initial = torque(i);
        time_initial = time(i);
    end
end

% plot 
avg_angle_vector = avg_angle_vector(~isnan(avg_angle_vector))*(pi/180);
avg_torque_vector = avg_torque_vector(~isnan(avg_torque_vector));
avg_time_vector = avg_time_vector(~isnan(avg_time_vector));

avg_angle_vector_ss = avg_angle_vector(400:end);
avg_torque_vector_ss = avg_torque_vector(400:end);

avg_angle = mean(avg_angle_vector);
avg_torque = mean(avg_torque_vector)
avg_time = mean(avg_time_vector);

avg_torque_ss = mean(avg_torque_vector_ss)

Wmotor = trapz(avg_angle_vector,avg_torque_vector)
Wmotor = -1*Wmotor
Wfriction = avg_torque_ss*(avg_angle_vector(end)-avg_angle_vector(1))

iflyexp = 2*(Wmotor-Wfriction)/(52.359^2)
% figure
% 
% subplot(2,1,1)
% hold on
% plot(avg_time_vector,avg_angle_vector,'r.')
% plot(avg_time_vector,avg_angle_vector,'b-')
% xlabel('Time [s]')
% ylabel('Angle [deg]')
% 
% subplot(2,1,2)
% hold on
% plot(avg_time_vector,avg_angle_vector,'r.')
% plot(avg_time_vector,avg_angle_vector,'b-')
% xlim([1.85,2.3])
% xlabel('Time [s]')
% ylabel('Angle [deg]')
% 
% 
% figure 
% 
% hold on
% plot(avg_angle_vector,avg_torque_vector,'r*')
% plot(avg_angle_vector,avg_torque_vector,'b-')
% xlabel('Angle [deg]')
% ylabel('Torque [N-m]')
% title('Angle vs. Torque for No Flywheel')

num_plates = 4; % number of flywheel plates
mass_fly = 1.0141; % mass of flywheel [kg]
radius_fly = 0.07; % radius of flywheel [m]
theory_Ifly = num_plates*(0.5 * mass_fly * radius_fly^2) % MOI for flywheel
