clear
clc

% Variables
Is = 0.01e-12;
Ib = 0.1e-12; 
Vb = 1.3;
Gp = 0.1^-1;

V_input = linspace(-1.95, 0.7, 200);

% Calculations
ideal = @(V) Is*(exp(1.2*V/0.025)-1);
parallel_resistor = @(V) Gp*V;
breakdown = @(V) Ib*(exp(-1.2*(V+Vb)/0.25));

I_equation = @(V) ideal(V) + parallel_resistor(V) + breakdown(V);

I1 = I_equation(V_input);

random = rand(1, length(V_input))*0.2; 

I2 = I1.*random;

fit_no_noise_4 = polyfit(V_input, I1, 4);
fit_noise_4 = polyfit(V_input, I2, 4);
fit_no_noise_8 = polyfit(V_input, I1, 8);
fit_noise_8 = polyfit(V_input, I2, 8);

fitted_no_noise_4 = polyval(fit_no_noise_4, V_input);
fitted_noise_4 = polyval(fit_noise_4, V_input);
fitted_no_noise_8 = polyval(fit_no_noise_8, V_input);
fitted_noise_8 = polyval(fit_noise_8, V_input);

% Plotting
figure(1)
clf
subplot(221)
plot(V_input, I1, 'b'); 
hold on;
plot(V_input, fitted_no_noise_4, 'r'); 
hold off;
title('Voltage vs Current, no noise, plot');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

subplot(222)
plot(V_input, I2);
hold on;
plot(V_input, fitted_noise_4, 'r'); 
hold off;
title('Voltage vs Current, noise, plot');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

subplot(223)
semilogy(V_input, I1);
hold on;
plot(V_input, fitted_no_noise_8, 'r'); 
hold off;
title('Voltage vs Current, noise, semilogy');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

subplot(224)
semilogy(V_input, I2); 
hold on;
plot(V_input, fitted_noise_8, 'r'); 
hold off;
title('Voltage vs Current, noise, semilogy');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

% 2c - looks accurate to us!

% 3.3a
B = Gp;
D = Vb;
fo = fittype(@(A,B,C,D,x) (A.*exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1));
ff11 = fit(V_input', I1', fo);
If11 = ff11(V_input);
ff21 = fit(V_input', I2', fo);
If21 = ff21(V_input);


figure(2)
clf

subplot(231)
plot(V_input, If11);
title('Fitted I1 (B, D)');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

subplot(234)
plot(V_input, If21);
title('Fitted I2 (B, D)');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

% 3.3b
A = Is;
C = Ib;
fo = fittype(@(A,B,C,D,x) (A.*exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1));
ff12 = fit(V_input', I1', fo);
If12 = ff12(V_input);
ff22 = fit(V_input', I2', fo);
If22 = ff22(V_input);

subplot(232)
plot(V_input, If12);
title('Fitted I1 (A, C)');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

subplot(235)
plot(V_input, If22);
title('Fitted I2 (A, C)');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

% 3.3c
fo = fittype(@(A,B,C,D,x) (A.*exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1));
ff13 = fit(V_input', I1', fo);
If13 = ff13(V_input);
ff23 = fit(V_input', I2', fo);
If23 = ff23(V_input);

subplot(233)
plot(V_input, If13);
title('Fitted I1');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;

subplot(236)
plot(V_input, If23);
title('Fitted I2');
xlabel('Voltage (V)'); ylabel('Current (mA)');
grid on;
