function [ output_args ] = GetBasicResistance( speed )
%计算列车运行基本阻力
%输入参数：
    %speed：列车运行速度,km/h
%输出参数：
    %阻力 单位：N/KN(牛每千牛)
a=0.57;
b=0.0037;
c=0.000123;
output_args=a+b.*speed+c.*speed.*speed;
end
