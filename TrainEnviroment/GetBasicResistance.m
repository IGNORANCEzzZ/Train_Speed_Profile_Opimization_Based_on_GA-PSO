function [ output_args ] = GetBasicResistance( speed )
%�����г����л�������
%���������
    %speed���г������ٶ�,km/h
%���������
    %���� ��λ��N/KN(ţÿǧţ)
a=0.57;
b=0.0037;
c=0.000123;
output_args=a+b.*speed+c.*speed.*speed;
end
