function eth = ethupdate(eth, pos, vn)
% ���ܣ�������ز����ṹ�����
% ���룺eth - ����ǰ�ĵ���ṹ��
%       pos - ����ļ���λ��
%       vn - �����ٶ�
% ��������º�ĵ�����ز����ṹ��
    if nargin==2,  vn = [0; 0; 0];  end
    eth.pos = pos;  
    eth.vn = vn;
    eth.sl = sin(pos(1));  eth.cl = cos(pos(1));  eth.tl = eth.sl/eth.cl;   % γ�ȵ�sin��cos��tanֵ 
    eth.sl2 = eth.sl*eth.sl;  sl4 = eth.sl2*eth.sl2;                        % γ��sinֵ��2��4�η�

    sq = 1-eth.e2*eth.sl2;  RN = eth.Re/sqrt(sq);                           % î��Ȧ�����ʰ뾶
    eth.RNh = RN+pos(3);  eth.clRNh = eth.cl*eth.RNh;                       % î��Ȧ�����ʰ뾶+��ƽ���ϸ߶�
    eth.RMh = RN*(1-eth.e2)/sq+pos(3);                                      % ����Ȧ�����ʰ뾶+��ƽ���ϸ߶�
    
    eth.wnie(1) = 0; eth.wnie(2) = eth.wie*eth.cl; eth.wnie(3) = eth.wie*eth.sl;                                                    % ������ת���ٶȵ��ڵ���ϵ�ϵ�ͶӰ
    eth.wnen(1) = -vn(2)/eth.RMh; eth.wnen(2) = vn(1)/eth.RNh; eth.wnen(3) = eth.wnen(2)*eth.tl;                                    % ����ϵ����ڵ���ϵ�Ľ��ٶ��ڵ���ϵ�ϵ�ͶӰ
    eth.wnin(1) = eth.wnie(1) + eth.wnen(1); eth.wnin(2) = eth.wnie(2) + eth.wnen(2); eth.wnin(3) = eth.wnie(3) + eth.wnen(3);      % ����ϵ����ڹ���ϵ�Ľ��ٶ��ڵ���ϵ�ϵ�ͶӰ
    eth.wnien(1) = eth.wnie(1) + eth.wnin(1); eth.wnien(2) = eth.wnie(2) + eth.wnin(2); eth.wnien(3) = eth.wnie(3) + eth.wnin(3);   % ����ϵ�͵���ϵ����ڹ���ϵ�Ľ��ٶ�֮��
    
    eth.g = eth.g0*(1+5.27094e-3*eth.sl2+2.32718e-5*sl4)-3.086e-6*pos(3);   % ���Ǹ߶ȵĲ�ͬγ�ȵ�������
    eth.gn(3) = -eth.g;                                                     % ֻ����������з���
    eth.gcc(1) = eth.wnien(3)*vn(2)-eth.wnien(2)*vn(3);                     % �����˶��͵�����ת����ĸ��ϼ��ٶȺ������˶�����ĶԵ����ļ��ٶ�
    eth.gcc(2) = eth.wnien(1)*vn(3)-eth.wnien(3)*vn(1);                     % �к����ٶ�
    eth.gcc(3) = eth.wnien(2)*vn(1)-eth.wnien(1)*vn(2)+eth.gn(3);
