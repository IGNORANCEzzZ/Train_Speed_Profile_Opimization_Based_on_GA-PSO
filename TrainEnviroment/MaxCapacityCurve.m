function [s,v,f,T,mode]=MaxCapacityCurve()
%% 输出
%s：距离离散点，1：N+1,以起始站为第一个点
%v：空间域离散的优化速度曲线，1：N+1，以起始站为第一个点
%f:列车输出力的位置离散矩阵，单位N
%T：累计时间，单位s
%mode: ATP防护曲线的每个位置离散点上所使用的工况
%|工况类型 |公里标
%0-无效工况 1-牵引 2-恒速 3-惰行 4-制动
%% 输入
% IsStop：中间站是否停车的标志位，1表示停车
%% 
global step_s;
global start_pos;
global end_pos;
global N;
global v0;
global vend;
global SpdLimit;
global MaxSpeed;

SpdLimit_Used=SpdLimit;
L=length(SpdLimit_Used);
for i=1:1:L
    if SpdLimit_Used(1,i)==MaxSpeed
        SpdLimit_Used(1,i)=SpdLimit_Used(1,i)-2;
    end
end
if end_pos>start_pos
    step=step_s;
else
   step=-step_s;
end

s=zeros(1,N+1);
v=zeros(1,N+1);
f=zeros(1,N+1);
%|工况类型 |公里标
mode=[zeros(N+1,1) zeros(N+1,1)];
s(1,1)=start_pos;
v(1,1)=v0;
f(1,N+1)=0;

mode(N+1,1)=0;
mode(1,2)=s(1,1);
for i=1:1:N
    if v(1,i)<SpdLimit_Used(1,i+1)
        [curspeed,F] = CalculateOneStep('FP',v(1,i),1,i);
        v(1,i+1)=curspeed;
        f(1,i)=F;
        mode(i,1)=1;%牵引工况
        s(1,i+1)=s(1,i)+step;
        mode(i+1,2)=s(1,i+1); 
    end
    if v(1,i)==SpdLimit_Used(1,i+1)
        [v(1,i+1),F]=CalculateOneStep('CONST',v(1,i),1,i);
        f(1,i)=F;
        mode(i,1)=2;%恒速工况
        s(1,i+1)=s(1,i)+step;
        mode(i+1,2)=s(1,i+1);
    end
    if v(1,i)>SpdLimit_Used(1,i+1)
        v(1,i+1)=v(1,i);
        s(1,i+1)=s(1,i)+step;
        f(1,i)=0;
        mode(i,1)=2;
        mode(i+1,2)=s(1,i+1);
    end
    if v(1,i)>SpdLimit_Used(1,i)%制动减速
        if v(1,i)-SpdLimit_Used(1,i)>=4
            mode(i,1)=4;
        end
        v(1,i)=SpdLimit_Used(1,i);
        %往后延申处理一个点，即i+1点的速度、位置，i点的力和工况。因为在下一此for循环里，这个点不会被处理
        if SpdLimit_Used(1,i+1)>v(1,i)
            [v(1,i+1),F]=CalculateOneStep('FP',v(1,i),1,i);
            mode(i+1,1)=1;%牵引工况
        elseif SpdLimit_Used(1,i+1)== v(1,i)
            [v(1,i+1),F]=CalculateOneStep('CONST',v(1,i),1,i);
            mode(i+1,1)=2;%恒速工况
        elseif SpdLimit_Used(1,i+1)< v(1,i)
            [v(1,i+1),F]=CalculateOneStep('FB',v(1,i),1,i);
            mode(i+1,1)=4;%制动工况
        else
            disp('制动减速或停车之后出现错误工况')
        end
        f(1,i)=F;
        s(1,i+1)=s(1,i)+step;
        mode(i+1,2)=s(1,i+1);
        %往后延申处理一个点，即i+1点的速度、位置，i点的力和工况。因为在下一此for循环里，这个点不会被处理
        
        %然后处理反算连接成功点即j点到i-1点的速度，以及对应的j点到i-1点的力和工况，i点的速度已经在上面被处理了就等于SpdLimit(1,i)
        j=i-1;
        [v_j,F]=CalculateOneStep('FB',v(1,j+1),0,j);
        while v_j<v(1,j)
            v(1,j)=v_j;
            f(1,j)=F;
            mode(j,1)=4;
            [v_j,F]=CalculateOneStep('FB',v(1,j),0,j-1);
            j=j-1;
        end
    end
    if i==N %制动停车
        %处理反算连接点即j点 到 最后的N+1点的位置、速度，以及对应的j-1点到N-1点的力和工况
        v(1,i+1)=vend;
        s(1,i+1)=s(1,i)+step;
        mode(i+1,2)=s(1,i+1);      
        j=i;
        [v_j,F]=CalculateOneStep('FB',v(1,j+1),0,j);
        while v_j<v(1,j)
            v(1,j)=v_j;
            f(1,j)=F;
            mode(j,1)=4;
            [v_j,F]=CalculateOneStep('FB',v(1,j),0,j-1);
            j=j-1;
        end
    end
% x=['SpeedLimit= ',num2str(SpdLimit_Used(1,i)),' i= ',num2str(i),' v(1,i)= ',num2str(v(1,i))];
% disp(x);
end
T=0;
for z=1:1:N
    T=T+2*step_s./(v(1,z)/3.6+v(1,1+z)/3.6);
end

end