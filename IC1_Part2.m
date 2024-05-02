% Jake DePiero
% ME 4056 - A1 
% IC Engines 1 Lab Matlab Code

%% Part 2: No-Head Characterization

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

% Steady-State Low RPM = 200 RPM
[angle_average_rad_1,torque_average_Nm_1,time_average_s_1] = StepWiseAverage(times,low_rpm_angle,low_t);
angular_velocity_1 = angle_average_rad_1./time_average_s_1;
angular_velocity_1 = angular_velocity_1.*(60./(2.*pi()));
angular_velocity_1 = mean(angular_velocity_1,'omitnan')
% Steady-State Medium RPM = 300 RPM
[angle_average_rad_2,torque_average_Nm_2,time_average_s_2] = StepWiseAverage(times,med_rpm_angle,med_t);
angular_velocity_2 = angle_average_rad_2./time_average_s_2;
angular_velocity_2 = angular_velocity_2.*(60./(2.*pi()));
angular_velocity_2 = mean(angular_velocity_2,'omitnan')
% Steady-State High RPM = 500 RPM
[angle_average_rad_3,torque_average_Nm_3,time_average_s_3] = StepWiseAverage(times,high_rpm_angle,high_t);
angular_velocity_3 = angle_average_rad_3./time_average_s_3;
angular_velocity_3 = angular_velocity_3.*(60./(2.*pi()));
angular_velocity_3 = mean(angular_velocity_3,'omitnan')
% Transient With FlyWheel
[angle_average_rad_4,torque_average_Nm_4,time_average_s_4] = StepWiseAverage(times_fly,allfly_angle,allfly_t);
% Transient Without FlyWheel
[angle_average_rad_5,torque_average_Nm_5,time_average_s_5] = StepWiseAverage(times_fly,nofly_angle,nofly_t);

figure
plot(angle_average_rad_1,-1.*torque_average_Nm_1)
hold on
grid on
plot(angle_average_rad_2,-1.*torque_average_Nm_2)
plot(angle_average_rad_3,-1.*torque_average_Nm_3)
xlabel('Angle [radians]')
ylabel('Torque [Nm]')
legend({'Low RPM = 300 RPM','Medium RPM = 583 RPM', 'High RPM = 625 RPM'},'Location','best','FontSize',12)
axis([-inf inf -inf inf])

figure
plot(angle_average_rad_1,-1.*torque_average_Nm_1)
avg_torque_Nm_200RPM = mean(torque_average_Nm_1,'omitnan')
grid on
xlabel('Angle [radians]')
ylabel('Torque [Nm]')
legend({'Low RPM = 200 RPM'},'Location','best','FontSize',12)
W_motor_J_1 = trapz(angle_average_rad_1,torque_average_Nm_1)
W_Friction_J_1 = avg_torque_Nm_200RPM.*(angle_average_rad_1(end)-angle_average_rad_1(1))

figure
plot(angle_average_rad_2,-1.*torque_average_Nm_2)
avg_torque_Nm_400RPM = mean(torque_average_Nm_2,'omitnan')
grid on
xlabel('Angle [radians]')
ylabel('Torque [Nm]')
legend({'Medium RPM = 400 RPM'},'Location','best','FontSize',12)
W_motor_J_2 = trapz(angle_average_rad_2,torque_average_Nm_2)
W_Friction_J_2 = avg_torque_Nm_400RPM.*(angle_average_rad_2(end)-angle_average_rad_2(1))

figure
plot(angle_average_rad_3,-1.*torque_average_Nm_3)
avg_torque_Nm_550RPM = mean(torque_average_Nm_3,'omitnan')
grid on
xlabel('Angle [radians]')
ylabel('Torque [Nm]')
legend({'High RPM = 550 RPM'},'Location','best','FontSize',12)
W_motor_J_3 = trapz(angle_average_rad_3,torque_average_Nm_3)
W_Friction_J_3 = avg_torque_Nm_550RPM.*(angle_average_rad_3(end)-angle_average_rad_3(1))


figure
plot(angle_average_rad_4,-1.*torque_average_Nm_4)
grid on
xlabel('Angle [radians]')
ylabel('Torque [Nm]')
legend({'Transient With Flywheel'},'Location','best','FontSize',12)

figure
avg_torque_Nm_Transient1 = mean(torque_average_Nm_4(600:end),'omitnan');
angle_averaged_rad_4_clean = angle_average_rad_4(50:end);
torque_average_Nm_4_clean = torque_average_Nm_4(50:end);
plot(angle_averaged_rad_4_clean,torque_average_Nm_4_clean)
grid on
xlabel('Angle [radians]')
ylabel('Torque [Nm]')
legend({'Transient With Flywheel-Cleaned Data'},'Location','best','FontSize',12)
W_motor_J_4 = trapz(angle_average_rad_4,torque_average_Nm_4-avg_torque_Nm_Transient1)
angular_velocity_4 = angle_average_rad_4./time_average_s_4;
wfly_b = angular_velocity_4(end);
Ifly = (2*(-W_motor_J_4))./((wfly_b).^2)

%%%%%%%

W_motor_trial = trapz(angle_average_rad_4,torque_average_Nm_4)
W_friction_trial = avg_torque_Nm_Transient1.*(angle_average_rad_4(end)-angle_average_rad_4(1))
Ifly2 = (2*(-W_motor_trial+W_friction_trial))./((wfly_b).^2)

figure
plot(angle_average_rad_5,-1.*torque_average_Nm_5)
grid on
xlabel('Angle [radians]')
ylabel('Torque [Nm]')
legend({'Transient Without Flywheel'},'Location','best','FontSize',12)

avg_torque_Nm_Transient2 = mean(torque_average_Nm_5(600:end),'omitnan');
W_motor_trial_2 = trapz(angle_average_rad_5,torque_average_Nm_5)
W_friction_trial_2 = avg_torque_Nm_Transient2.*(angle_average_rad_5(end)-angle_average_rad_5(1))
angular_velocity_5 = angle_average_rad_5./time_average_s_5;
wfly_b = angular_velocity_5(end);
Ifly3 = (2*(-W_motor_trial_2+W_friction_trial_2))./((wfly_b).^2)