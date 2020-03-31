glvf
load('trueimu.mat');
ts = 0.1;
t_align = 180;
t_coarse = 60;
imu_coarse = trueimu(1:t_coarse/ts,:);
attsb = alignsb(imu_coarse); 