clear all;           clc;                      nu=3;            
b1= 1.3767;          a1=-0.4493;               umin=-10;                       
n1=1;                n2=3;                     umax=10;       d=[0 0 0];
%==========================================================================
lnw=ones(1,9);
for k=1:250
lnw(k)=-5;      if k>=50
lnw(k)=5;  end
                if k>=100
lnw(k)=10;  end
                if k>=170
lnw(k)=3; end
end
%==========================================================================
Ca =[1;           (1-a1);            a1*(1-a1)*(1-a1)] ;
Cb =[b1;       b1*(1-a1);       b1*((1-a1)*(1-a1)+a1)] ;
for j=1:(2)
Ca=[Ca [zeros(j,1); Ca(1:(length(Ca)-j),1)]];
Cb=[Cb [zeros(j,1); Cb(1:(length(Cb)-j),1)]];
end
CaS=Ca;
CbS=Cb;
%==========================================================================
for i=1:(n2)
CaS=[CaS;(1-a1)*Ca(3,1)+(a1)*Ca(2,1)+b1*Ca(1,1) ...
    (1-a1)*Ca(3,2)+(a1)*Ca(2,2)+b1*Ca(1,2) (1-a1)*Ca(3,3)+(a1)*Ca(2,3)+b1*Ca(1,3) ]
Ca=[Ca(2:3,:);(1-a1)*Ca(3,1)+(a1)*Ca(2,1)+b1*Ca(1,1)...
    (1-a1)*Ca(3,2)+(a1)*Ca(2,2)+b1*Ca(1,2) (1-a1)*Ca(3,3)+(a1)*Ca(2,3)+b1*Ca(1,3) ];
CbS=[CbS;(1-a1)*Cb(3,1)+(a1)*Cb(2,1)+b1*Cb(1,1) (1-a1)*Cb(3,2)+(a1)*Cb(2,2)+b1*Cb(1,2)...
(1-a1)*Cb(3,3)+(a1)*Cb(2,3)+b1*Cb(1,3) ];
Cb=[Cb(2:3,:);(1-a1)*Cb(3,1)+(a1)*Cb(2,1)+b1*Cb(1,1)...
    (1-a1)*Cb(3,2)+(a1)*Cb(2,2)+b1*Cb(1,2) (1-a1)*Cb(3,3)+(a1)*Cb(2,3)+b1*Cb(1,3)];
end
%AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Ca=[CaS(n2-2,1) 0 0;...
    CaS(n2-1,1) CaS(n2-2,1) 0; ...
    CaS(n2+0,1) CaS(n2-1,1)  CaS(n2-2,1) ] ;
HA=[CaS(n2-1,1) CaS(n2+0,1);...
    CaS(n2+0,1) CaS(n2+1,1);...
    CaS(n2+1,1) CaS(n2+2,1) ];
% Bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
Cb=[CbS(n2-2,1) 0 0;...
    CbS(n2-1,1) CbS(n2-2,1) 0;...
    CbS(n2+0,1) CbS(n2-1,1) CbS(n2-2,1) ]; 
Hb=[CbS(n2-1,1) ;...
    CbS(n2+0,1) ; ...
    CbS(n2+1,1) ];
CaI=inv(Ca); 

Q=CaI*HA;
P=CaI*Hb;
H=CaI*Cb;

%xxxxxxxxxxxxxxxxxxxxxxxxxxxxx ARITHMETICAL PART xxxxxxxxXxxxxxxxxxxxxxxxx

p=inv(H'*H+0.5*eye(size(H'*H)))*H';                    d=[0 0 0]; 
q=p*[Q P];                     q1=q(1,1);  q2=q(1,2);  q3=q(1,3);  
for i=1:(n2-n1+1)
pp(i)=p(1,i);
end

for k=1:200
zed(k)=k;                   y(k)=-a1*d(1)+b1*d(3);      duw=0;
for i=1:(n2-n1+1)
duw=duw+pp(i)*lnw(k+n1+i-1);
end
du(k)=-q1*y(k)-q2*d(1)+duw;
d(1)=y(k); 
d(2)=du(k);                  u(k)=d(3)+du(k);          d(3)=u(k); 
end
figure;                         plot(zed,u,zed,y,zed,lnw(1:200));

%xxxxxxxxxxxxxxxxxxxxxxxxx OBSERVING CONSTRAINTS xxxxxxxxXxxxxxxxxxxxxxxxxx
for j=1:(2)
P=[P [zeros(j,1);P(1:(length(P)-j),1)]];
end 
H=H'*H+ 20*eye(size(H'*H));                           d=[0 0 0];
options = optimset('LargeScale','off','Display','off');

for k=1:200  
zed(k)=k;               y(k)=-(a1)*d(1)+ b1*d(3); 

m1=P'*Q*[y(k);d(1)]        
m2=P'*lnw((n1+k-1):(n2+k-1))'      
m3=(m1-m2);

A=[-tril(ones(3));       tril(ones(3))];
b=[-ones(3,1)*umin+ones(3,1)*d(3);      ones(3,1)*umax-ones(3,1)*d(3)];
[lngap]=quadprog(H,m3,A,b,[],[],[],[],[],options);      du(k)=lngap(1);  
d(1)=y(k);         d(2)=du(k);         u(k)=d(3)+du(k);      d(3)=u(k);
end  
figure; plot(zed,u,zed,y,zed,lnw(1:200));
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxx ARITHMETICAL PART xxxxxxxxXxxxxxxxxxxxxxxxx




    
