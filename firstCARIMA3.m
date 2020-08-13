clear all;                     clc;        
a1=-0.3935;                    b1=-0.6065;
d=[0 0 0 0 0];                 n1=1;                             n2=3; 
umin= 0;                       umax=9.5;    
%**********************************************************************************************
P1 =[b1;          (1-a1)*b1+b1;             (1-a1)*(1-a1)*b1+(1-a1)*b1+b1]
X1 =[b1 0;       (1-a1)*b1  b1; (1-a1)*(1-a1)*b1 b1*b1];       P2=P1;X2=X1
for m=1:0
P2 =[P2;(1-a1)*P1(3)+(a1)*P1(2)+b1*P1(1)];     % changes 4th Datapoint and saves P2
X2 =[X2;(1-a1)*X1(3,1)+(a1)*X1(2,1)+b1*X1(1,1) (1-a1)*X1(3,2)+a1*X1(2,2)+b1*X1(1,2)];

P1=[P1(2:3);(1-a1)*P1(3)+(a1)*P1(2)+b1*P1(1)]; % changes 4th Datapoint and saves P1
X1=[X1(2:3,:);(1-a1)*X1(3,1)+(a1)*X1(2,1)+b1*X1(1,1) (1-a1)*X1(3,2)+(a1)*X1(2,2)+b1*X1(1,2)];
end
for j=1:(2)
P1=[P1 [zeros(j,1);P1(1:(length(P1)-j),1)]];
end
P1=P1(1:3,:);                 
X1=X1(1:3,:);
H=P1*P1'+ 1.5*eye(size(P1*P1'));
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ln2=ones(1,9);
for k=1:300 
   ln2(k)=7.5;  
 if k>=50  
 ln2(k)=6;  end
  if k>=100 
 ln2(k)=3;  end
end
%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
options = optimset('LargeScale','off','Display','off');
for k=1:150  
z(k)=k;                                    y(k)= -(a1)*d(1)+ b1*d(3) ; 
lineA=P1'*X1*[y(k);d(1)]; lineB= P1'*[ln2((k+n1):(k+n2))']; g=lineB-lineA;
A=[tril(ones(3));-tril(ones(3))];  
b=[ones(3,1)*umax-ones(3,1)*d(3); -ones(3,1)*umin+ones(3,1)*d(3)];
[deu]=quadprog(H,g,A,b,[],[],[],[],[],options) ;               
du(k)=deu(1);   
d(1)=y(k);   
d(2)=du(k);         u(k)=d(3)+du(k);       
d(3)=u(k); 
end  
figure; plot(z,u,z,y,z,ln2(1:150));

