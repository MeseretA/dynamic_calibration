% load pendubot data
rawData = load('position_A_0.7_v_1.0.mat');
% rawData = load('position_A_1.2_v_0.05.mat');

% parse pendubot data
pendubot.time = rawData.data(:,1) - rawData.data(1,1);
pendubot.current = rawData.data(:,2);
pendubot.current_desired = rawData.data(:,4);
pendubot.torque = rawData.data(:,3);

pendubot.shldr_position = rawData.data(:,7) - pi/2; % to fit model
pendubot.shldr_velocity = rawData.data(:,9);
pendubot.elbw_position = rawData.data(:,8);
pendubot.elbw_velocity = rawData.data(:,10);

pendubot.position_desired = rawData.data(:,5);
pendubot.velocity_desired = rawData.data(:,6);

% filter velocties with zero phas filter
vlcty_fltr = designfilt('lowpassiir','FilterOrder',5, ...
                        'HalfPowerFrequency',0.25,'DesignMethod','butter');
pendubot.shldr_velocity_filtered = filtfilt(vlcty_fltr, pendubot.shldr_velocity);
pendubot.elbw_velocity_filtered = filtfilt(vlcty_fltr, pendubot.elbw_velocity);

% estimating accelerations based on filtered velocities
q2d1 = zeros(size(pendubot.shldr_velocity));
q2d2 = zeros(size(pendubot.elbw_velocity));
for i = 2:size(pendubot.shldr_velocity,1)-1
    q2d1(i) = (pendubot.shldr_velocity_filtered(i+1) - pendubot.shldr_velocity_filtered(i-1))/...
                (pendubot.time(i+1) - pendubot.time(i-1));
    q2d2(i) = (pendubot.elbw_velocity_filtered(i+1) - pendubot.elbw_velocity_filtered(i-1))/...
                (pendubot.time(i+1) - pendubot.time(i-1));
end
pendubot.shldr_acceleration = q2d1;
pendubot.elbow_acceleration = q2d2;

% filter estimated accelerations with zero phase filter
aclrtn_fltr = designfilt('lowpassiir','FilterOrder',5, ...
                        'HalfPowerFrequency',0.1,'DesignMethod','butter');
pendubot.shldr_acceleration_filtered = filtfilt(aclrtn_fltr, pendubot.shldr_acceleration);
pendubot.elbow_acceleration_filtered = filtfilt(aclrtn_fltr, pendubot.elbow_acceleration);

% filter torque measurements using zero phase filter
trq_fltr = designfilt('lowpassiir','FilterOrder',5, ...
                       'HalfPowerFrequency',0.2,'DesignMethod','butter');
pendubot.torque_filtered = filtfilt(trq_fltr, pendubot.torque);

%%

% Validation
pi_CAD = [plnr.pi(:,1); 0; plnr.pi(:,2)];
vldtnRange = 1:1500;
tau_prdctd_OLS = []; tau_prdctd_SDP = []; tau_prdctd_CAD = [];
for i = vldtnRange
    qi = [pendubot.shldr_position(i), pendubot.elbw_position(i)]';
    qdi = [pendubot.shldr_velocity_filtered(i), pendubot.elbw_velocity_filtered(i)]';
    q2di = [pendubot.shldr_acceleration_filtered(i), pendubot.elbow_acceleration_filtered(i)]';
    
    if plnrBaseQR.motorDynamicsIncluded
        Yi = regressorWithMotorDynamicsPndbt(qi, qdi, q2di);
    else
        Yi = full_regressor_plnr(qi, qdi, q2di);
    end
    Ybi = Yi*plnrBaseQR.permutationMatrix(:,1:plnrBaseQR.numberOfBaseParameters);
    Yfrctni = frictionRegressor(qdi);
    tau_prdctd_OLS = horzcat(tau_prdctd_OLS, [Ybi, Yfrctni]*pi_hat);
    tau_prdctd_SDP = horzcat(tau_prdctd_SDP, [Ybi, Yfrctni]*[pi_b; pi_frctn]);
    
    tau_prdctd_CAD = horzcat(tau_prdctd_CAD, Yi*pi_CAD);
end

%%
figure
subplot(2,1,1)
plot(pendubot.time(vldtnRange), pendubot.torque(vldtnRange),'r')
hold on
plot(pendubot.time(vldtnRange), tau_prdctd_OLS(1,:),'b-')
plot(pendubot.time(vldtnRange), tau_prdctd_SDP(1,:),'k-')
plot(pendubot.time(vldtnRange), tau_prdctd_CAD(1,:),'g-')
legend('measured', 'predicted OLS', 'predicted SDP', 'predicted CAD')
grid on
subplot(2,1,2)
plot(pendubot.time(vldtnRange), pendubot.shldr_acceleration_filtered(vldtnRange))