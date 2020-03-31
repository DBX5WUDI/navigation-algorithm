function imuerr = imuerrset(eb, db, web, wdb, sqrtR0G, TauG, sqrtR0A, TauA, dKGii, dKAii, dKGij, dKAij, KA2)
% ���ܣ�����IMU���
% ���룺 eb-���ݺ㶨Ư��ƫ�deg/h����db-���ٶȼƳ���ƫ�ug��
%        web-���ݽ��������ϵ����deg/sqrt(h)����wdb-���ٶȼ��������ϵ����ug/sqrt(h)��
%        sqrtR0G,TauG
%        sqrtR0A,TauA
%        dKGii-���ݲ���̶�ϵ����ppm����dKAii-���ٶȼƲ���̶�ϵ����ppm��
%        dKGij-���ݰ�װ����arcsec����dKAij-���ٶȼư�װ��arcsec��
%                                   |dKGii(1) dKGij(4) dKGij(5)|         
%        ���ݱ궨�̶�������dKg =|dKGij(1) dKGii(2) dKGij(6)| , 
%                                   |dKGij(2) dKGij(3) dKGii(3)|         
%                                           |dKAii(1) 0        0       |
%       ���ٶȼƱ궨�̶�ϵ��������dKa = |dKAij(1) dKAii(2) 0       |
%                                           |dKAij(2) dKAij(3) dKAii(3)|
% �����IMU���ṹ��
global glv
    o31 = zeros(3,1); o33 = zeros(3);
    imuerr = struct('eb',o31, 'db',o31, 'web',o31, 'wdb',o31,...
        'sqg',o31, 'taug',inf(3,1), 'sqa',o31, 'taua',inf(3,1), 'dKg',o33, 'dKa',o33, 'dKga',zeros(15,1),'KA2',o31); 
    %% �̶�ƫ��&�������
    imuerr.eb(1:3) = eb*glv.dph;   imuerr.web(1:3) = web*glv.dpsh;
    imuerr.db(1:3) = db*glv.ug;    imuerr.wdb(1:3) = wdb*glv.ugpsHz;
    %% ���ƫ��
    if exist('sqrtR0G', 'var')
        if TauG(1)==inf, imuerr.sqg(1:3) = sqrtR0G*glv.dphpsh;   % algular rate random walk !!!
        elseif TauG(1)>0, imuerr.sqg(1:3) = sqrtR0G*glv.dph.*sqrt(2./TauG); imuerr.taug(1:3) = TauG; % Markov process
        end
    end
    if exist('sqrtR0A', 'var')
        if TauA(1)==inf, imuerr.sqa(1:3) = sqrtR0A*glv.ugpsh;   % specific force random walk !!!
        elseif TauA(1)>0, imuerr.sqa(1:3) = sqrtR0A*glv.ug.*sqrt(2./TauA); imuerr.taua(1:3) = TauA; % Markov process
        end
    end
    %% �궨ϵ���̶���� 
    if exist('dKGii', 'var')
        imuerr.dKg = setdiag(imuerr.dKg, dKGii*glv.ppm);
    end
    if exist('dKAii', 'var')
        imuerr.dKa = setdiag(imuerr.dKa, dKAii*glv.ppm);
    end
    %% ��װ�����
    if exist('dKGij', 'var')
        dKGij = ones(6,1).*dKGij*glv.sec;
        imuerr.dKg(2,1) = dKGij(1); imuerr.dKg(3,1) = dKGij(2); imuerr.dKg(3,2) = dKGij(3); 
        imuerr.dKg(1,2) = dKGij(4); imuerr.dKg(1,3) = dKGij(5); imuerr.dKg(2,3) = dKGij(6);
    end
    if exist('dKAij', 'var')
        dKAij = ones(3,1).*dKAij*glv.sec;
        imuerr.dKa(2,1) = dKAij(1); imuerr.dKa(3,1) = dKAij(2); imuerr.dKa(3,2) = dKAij(3); 
    end
    imuerr.dKga = [imuerr.dKg(:,1); imuerr.dKg(:,2);   imuerr.dKg(:,3);
                   imuerr.dKa(:,1); imuerr.dKa(2:3,2); imuerr.dKa(3,3)];
    if exist('KA2', 'var')
        imuerr.KA2(1:3) = KA2*glv.ugpg2; 
    end
