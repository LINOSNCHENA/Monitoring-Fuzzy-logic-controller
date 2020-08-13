%clear all;                    clc;                
n1=1;                          n2=10;                nu = 10; 
a1=-0.4493;                    b1= 1.3767;           d6 = 0.1;                                                       
benda=load('bankX.mat');       d=zeros(1,7);         ref=ones(1,9);  
%=========================================================================
v=benda.z1;                                          
for k=1:300
ref(k)=-5;  if (k>=050) ref(k)=-5;  end
            if (k>=100) ref(k)=15;  end
            if (k>=170) ref(k)=27;  end
end

%*************************************************************************
B=1;                       f0=1-a1;           f1=a1;
x=[f0 f1 b1];              G=b1;                  
N=d6;                                         NS=-d6;

for i=1:(n2-1)
R=f0;                                         B=[B R];          
f0=f1+R*(1-a1);                               f1=R*(a1); 
G=[G;b1*B(i+1)+b1*B(i)]; 
N=[N;d6*B(i+1)+d6*B(i)];                      NS=[NS;-d6*B(i+1)-d6*B(i)];
x=[x;f0 f1 b1*B(i+1)];
end

for j=1:(n2-1)
G=[G [zeros(j,1);G(1:(length(G)-j),1)]];
N=[N [zeros(j,1);N(1:(length(N)-j),1)]];
end

for j=1:(1)
NS=[NS [zeros(j,1);0*NS(1:(length(NS)-j),1)]];
end

x=x(n1:n2,:);
G=G(n1:n2,:);

%***********************************************************************

for k=1:200
z(k)=k;
west4=N*[v((k+n1-1):(k+n2-1))'];      % DisturbanceInjecktor
east4=NS*[0;0];                       % DisturbanceMeasurering ZEROD
costfunction=(inv(G'*G+0.01*eye(size(G'*G)))*G');
y(k)=-a1*d(1)+b1*d(4)+d6*d(6);
duw=costfunction*([ref((k+n1):(k+n2))']-x*[y(k);d(1);0]...
    -west4-east4);
% HMatrix*(Ref(1)-actualPoints(2)-Disturbs(2)-InverseDisturbs(4))
du(k)=duw(1);
d(2)=d(1);
d(1)=y(k);
d(3)=du(k);

u(k)=d(4)+du(k);
d(5)=d(4);  d(4)=u(k);
d(7)=d(6);  d(6)=v(k);
end
loss=ref(1:200)-y;XA=0;XB=0;
for k=1:199
    XA=XA+loss(k)^2;
    XB=XB+(u(k+1)-u(k))^2;
end
errSize=sqrt(XA)
inputSize=sqrt(XB)
disp('*************************CompersationAbsent*********')
figure;                                 plot(z,u,z,y,z,ref(1:200));
legend('inputSize','actualResult','desiredResult', 'location', 'best')
title('Missing Compersation_5');
KoefficientsOfDiofant_x_G_NS =[x G NS];






