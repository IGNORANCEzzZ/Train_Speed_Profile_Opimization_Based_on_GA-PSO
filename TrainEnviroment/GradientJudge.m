function [Gradient_After_Judge]=GradientJudge()
global Gradient;
global v_average;
global g;%N/kg
global M;
%|坡道起点| 坡道千分数| 坡道终点| 坡道类型
%坡道类型：
%大下坡道：列车使用惰行工况时，列车加速运行，即Fs(x)+F0(v)<0，用3表示
%大上坡道：列车采样最大能力牵引时，列车减速运行，即Ft-(Fs(x)+F0(v))<0,用1表示
%连续坡道：除上述两种之外的坡道
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