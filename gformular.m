clc;
clear all;
disp('********************B/A************me1')
[x1 x2]=c2dm([5],[1 2],0.4)

disp('********************B/A************me2')
Linos1 = tf([5],[1 2],'IODelay',8) % Drawing

disp('********************B/A************me3')
Linos2 = c2d(Linos1,0.4)             % Koefficients
gs=x1(2)
