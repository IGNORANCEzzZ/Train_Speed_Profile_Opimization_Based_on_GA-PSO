function [Particle_moved,Velocity_After]=UpdatePosition(Particle,Velocity_Before,BestParticle_Individual,BestParticle_Global,Iter)
%固定学习因子
global c1;
global c2;
global IterMax;
global direction;

%时变学习因子
global c1_i;
global c1_f;
global c2_i;
global c2_f;

%惯性权重
exponent=(log(1.5)+log(19))*Iter/IterMax-log(19);
Omega=1/(1+exp(exponent));
%Omega=0.2;

%学习因子
c1_used=(c1_f-c1_i)*(Iter/IterMax)+c1_i;
c2_used=(c2_f-c2_i)*(Iter/IterMax)+c2_i;
% c1_used=c1;
% c2_used=c2;

%随机数
rand1=rand;
rand2=rand;

Velocity_After=Omega.*Velocity_Before+c1_used*rand1.*(BestParticle_Individual(:,1)-Particle(:,1))+c2_used*rand2.*(BestParticle_Global(:,1)-Particle(:,1));

Particle_moved=Particle;
[row,col]=size(Particle);
for i=1:1:row
    if Particle(i,5)==0
        Velocity_After(i,1)=0;
    end
end
for i=2:1:row-1
    Particle_moved(i,1)=Particle(i,1)+Velocity_After(i,1);
    if direction==1%上行
        if Particle_moved(i,1)>Particle_moved(i-1,1)
            Particle_moved(i,1)=Particle_moved(i-1,1);
            Velocity_After(i,1)=Particle_moved(i,1)-Particle(i,1);
        elseif Particle_moved(i,1)<Particle_moved(i+1,1)
            Particle_moved(i,1)=Particle_moved(i+1,1);
            Velocity_After(i,1)=Particle_moved(i,1)-Particle(i,1);
        end
    else
        if Particle_moved(i,1)<Particle_moved(i-1,1)
            Particle_moved(i,1)=Particle_moved(i-1,1);
            Velocity_After(i,1)=Particle_moved(i,1)-Particle(i,1);
        elseif Particle_moved(i,1)>Particle_moved(i+1,1)
            Particle_moved(i,1)=Particle_moved(i+1,1);
            Velocity_After(i,1)=Particle_moved(i,1)-Particle(i,1);
        end
    end
end