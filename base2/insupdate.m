%% �����ߵ���ֵ�����㷨
function ins = insupdate(ins, imu)
% ���ܣ�SINS��ֵ�����㷨
% ���룺ins - ��ֵ����ǰ��SINS�ṹ��
%       imu - �������ߵ�IMU����
% �������ֵ���º��SINS�ṹ��
    nn = size(imu,1);                                               %����������size������������
    nts = nn*ins.ts;  nts2 = nts/2;  ins.nts = nts;                 %�������ڣ�������
    [phim, dvbm] = cnscl(imu,0);                                    %׶�����������תʸ���� ������ת�뻮����������ٶ�����
    phim = ins.Kg*phim-ins.eb*nts; dvbm = ins.Ka*dvbm-ins.db*nts;   %������Ȳ����볣ֵƫ���
    %% earth & angular rate updating 
    vn01 = ins.vn+ins.an*nts2; pos01 = ins.pos+ins.Mpv*vn01*nts2;   % extrapolation at t1/2
    ins.eth = ethupdate(ins.eth, pos01, vn01);                      %������ؽṹ�����
    ins.wib = phim/nts; ins.fb = dvbm/nts;                          %����������ڹ���ϵ�Ľ��ٶ�=��תʸ��/���� ����=�ٶȱ仯/����
    ins.web = ins.wib - ins.Cnb'*ins.eth.wnie;                      %
    ins.wnb = ins.wib - (ins.Cnb*rv2m(phim/2))'*ins.eth.wnin;       
    %% (1)velocity updating
    ins.fn = qmulv(ins.qnb, ins.fb);                                %����
    ins.an = rotv(-ins.eth.wnin*nts2, ins.fn) + ins.eth.gcc;        %����+�к����ٶ�
    vn1 = ins.vn + ins.an*nts;                                      %�ٶȸ���
    %% (2)position updating
    ins.Mpv(4)=1/ins.eth.RMh; ins.Mpv(2)=1/ins.eth.clRNh;
    ins.Mpvvn = ins.Mpv*(ins.vn+vn1)/2;
    ins.pos = ins.pos + ins.Mpvvn*nts;  
    ins.vn = vn1;
    ins.an0 = ins.an;
    %% (3)attitude updating
    ins.Cnb0 = ins.Cnb;
    ins.qnb = qupdt2(ins.qnb, phim, ins.eth.wnin*nts);
    [ins.qnb, ins.att, ins.Cnb] = attsyn(ins.qnb);
    ins.avp = [ins.att; ins.vn; ins.pos];

