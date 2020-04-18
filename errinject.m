clear
glvf
trj = trjfile('trj10ms.mat');
inst = [3;60;6];  kod = 1.05;  qe = 0; dT = 0.01;
trjod = odsimu(trj, inst, kod, qe, dT, 0);
imuerr = adiserrset(); 
% imuerr = imuerrset(0.01, 50, 0.001, 5);
trjod.imu = imuadderr(trjod.imu, imuerr);
trjfile('trjod.mat', trjod);
