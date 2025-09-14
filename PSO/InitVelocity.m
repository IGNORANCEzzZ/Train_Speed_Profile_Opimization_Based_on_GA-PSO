function [Velocity]=InitVelocity(Particle)
[row,col]=size(Particle);
Velocity=zeros(row,1);
Velocity(1,1)=0;
Velocity(row,1)=0;
for i=2:1:row-1
    Vmax=ceil(max((Particle(i,1)-Particle(i-1,1)),(Particle(i+1,1)-Particle(i,1))));
    Vmin=ceil(min((Particle(i,1)-Particle(i-1,1)),(Particle(i+1,1)-Particle(i,1))));

    if Particle(i,5)==0
        Velocity(i,1)=0;
    else        
        Velocity(i,1)=randi([Vmin,Vmax]);
    end
    Particle(i,1)=Particle(i,1)+Velocity(i,1);
end
end