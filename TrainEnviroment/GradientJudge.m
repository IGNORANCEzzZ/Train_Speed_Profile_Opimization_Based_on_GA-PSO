function [Gradient_After_Judge]=GradientJudge()
global Gradient;
global v_average;
global g;%N/kg
global M;
%|�µ����| �µ�ǧ����| �µ��յ�| �µ�����
%�µ����ͣ�
%�����µ����г�ʹ�ö��й���ʱ���г��������У���Fs(x)+F0(v)<0����3��ʾ
%�����µ����г������������ǣ��ʱ���г��������У���Ft-(Fs(x)+F0(v))<0,��1��ʾ
%�����µ�������������֮����µ�
Gradient_After_Judge=[Gradient(:,1) Gradient(:,2) Gradient(:,3) Gradient(:,1)];
length_of_gradient=length(Gradient_After_Judge);
for i=1:1:length_of_gradient
    F0=GetBasicResistance(v_average);%N/KN
    Fs=Gradient_After_Judge(i,2);%N/KN
    Ft=GetTractionForce(v_average)*1000/(M*g);%N/KN     
%     disp('FO= ')
%     disp(F0)
%     disp('Fs= ')
%     disp(Fs) 
% disp('v_average= ')
% disp(v_average)
% disp('Ft= ')
% disp(Ft)
    if F0+Fs<0
        Gradient_After_Judge(i,4)=3;
    elseif Ft-(Fs+F0)<0
        Gradient_After_Judge(i,4)=1;
    else
        Gradient_After_Judge(i,4)=2;
    end    
end
end