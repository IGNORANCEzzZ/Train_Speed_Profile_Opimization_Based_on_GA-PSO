function [ Force ] = GetTractionForce( v )
%计算最大列车牵引力（牵引特性曲线外包络）
%输入参数：
    %v 列车速度，单位：km/h
%输出参数：
    %Force 列车再生制动力 单位：KN    
%HXD2牵引特性
if v==0
    Force=225;
else
    Force=(v>0 & v<=50).*(225)+(50<v & v<=175).*(-0.296.*v+239.8)+(175<v & v<=350).*(32900./v);
end
end