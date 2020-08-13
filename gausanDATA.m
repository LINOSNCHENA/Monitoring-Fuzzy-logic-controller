clear all; 
clc;
a = 200; b = 15; c = 90;  noise_size = 20.2;
x = linspace(-200, 200, 300);     % Guassian normal
z1 = a*exp(-(x-b).^2/c^2) + noise_size * randn(size(x));


a = 1; b = 1:200;                   % Uniform Random
z2 = unifrnd(a,b(200),1,300);  


plot(z1,'Color', 'red', 'LineStyle', '-', 'LineWidth',1); hold on
plot(z2,'Color', 'blue', 'LineStyle', '-', 'LineWidth',1); grid on
save bankX z1 z2
legend('Guassian plot','Uniform plot','location', 'best')
title('SAMPLES OF NORMAL AND UNIFORM DISTRIBUTIONS DISTURBANCES');