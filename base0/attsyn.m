%% �ߵ���̬����ͳһ��

function [qnb, att, Cnb] = attsyn(attForm)
% ���ܣ��ߵ���̬����ͳһ��
% ���룺������ʽ�ߵ���̬����
% �������Ԫ����ŷ���ǣ���̬�����������
    [m, n] = size(attForm);
    mn = m*n;
    if mn==9         % if the input is direct cosine matirx
        Cnb = attForm; 
        qnb = m2qua(Cnb);
        att = m2att(Cnb);
    elseif mn==4     % if the input is quaternion
        qnb = attForm;
        % Cnb = q2mat(qnb);
        q11 = qnb(1)*qnb(1); q12 = qnb(1)*qnb(2); q13 = qnb(1)*qnb(3); q14 = qnb(1)*qnb(4); 
        q22 = qnb(2)*qnb(2); q23 = qnb(2)*qnb(3); q24 = qnb(2)*qnb(4);     
        q33 = qnb(3)*qnb(3); q34 = qnb(3)*qnb(4);  
        q44 = qnb(4)*qnb(4);
        Cnb=zeros(3,3);
        Cnb(1)=q11+q22-q33-q44;  Cnb(4)=2*(q23-q14);     Cnb(7)=2*(q24+q13);
        Cnb(2)=2*(q23+q14);      Cnb(5)=q11-q22+q33-q44; Cnb(8)=2*(q34-q12);
        Cnb(3)=2*(q24-q13);      Cnb(6)=2*(q34+q12);     Cnb(9)=q11-q22-q33+q44;
        % att = m2att(Cnb);
        att=zeros(3,1);
        att(1)=asin(Cnb(3,2));  
        att(2)=atan2(-Cnb(3,1),Cnb(3,3)); 
        att(3)=atan2(-Cnb(1,2),Cnb(2,2));
    elseif mn==3     % if the input is Euler attitude angles
        att = attForm;
        Cnb = a2mat(att);
        qnb = m2qua(Cnb);
    end