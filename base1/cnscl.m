function [phim, dvbm, dphim, rotm, scullm] = cnscl(imu, coneoptimal)
% ���ܣ�Բ׶�ͻ�������
% ���룺imu - IMU���ݣ�
%       coneoptimal - ��ת����ѡ�� - 0 - ����ʽ��������
%                                    1 - ����׶����������   
%                                    2 - ������ + ��ǰ����
% �����phim - ׶�����������תʸ��
%       dvbm - ������ת�뻮����������ٶ�����
%       dphim - ��̬׶�����
%       rotm - �ٶ���ת���
%       scullm - �ٶȻ������
global glv
    if nargin<2,  coneoptimal=0;  end
    [n, m] = size(imu);         
    if n>glv.csmax              % the maximun subsample number is glv.csmax, if n exceeds, then reshape imu
        [imu, n] = imureshape(imu, n, m);
    end
    %% coning compensation
    wm = imu(:,1:3);
	if n==1
        wmm = wm;
        if coneoptimal==2
            dphim = 1/12*cros(glv.wm_1,wm);  glv.wm_1 = wm;
        else
            dphim = [0, 0, 0];
        end
    else
        wmm = sum(wm,1);
        if coneoptimal==0
            cm = glv.cs(n-1,1:n-1)*wm(1:n-1,:);
            dphim = cros(cm,wm(n,:));
        elseif coneoptimal==1                       % else: using polynomial fitting coning compensation method
            dphim = conepolyn(wm);
        else
            dphim = coneuncomp(wm);
        end
	end
    phim = (wmm+dphim)';  dvbm = [0; 0; 0];
    %% sculling compensation
    if m>=6
        vm = imu(:,4:6); 
        if n==1
            vmm = vm;
            if coneoptimal==0
                scullm = [0, 0, 0];
            else
                scullm = 1/12*(cros(glv.wm_1,vm)+cros(glv.vm_1,wm));  glv.vm_1 = vm;
            end
        else
            vmm = sum(vm,1);
            if coneoptimal==0
                sm = glv.cs(n-1,1:n-1)*vm(1:n-1,:);
                scullm = (cros(cm,vm(n,:))+cros(sm,wm(n,:)));
            else  % else: using polynomial fitting sculling compensation method
                scullm = scullpolyn(wm, vm);
            end
        end
        rotm = 1.0/2*cros(wmm,vmm);
        dvbm = (vmm+rotm+scullm)';
    end

function [imu, n] = imureshape(imu0, n0, m0)
global glv
    for n=glv.csmax:-1:1
        if mod(n0,n)==0,  break;  end
    end
    nn = n0/n;
    imu = zeros(n, m0);
    for k=1:n
        imu(k,:) = sum(imu0((k-1)*nn+1:k*nn,:),1);
    end
