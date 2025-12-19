%% 1. Definición del sistema
clc; clear; close all;

K = -0.1248;
% Numerador
num = K * conv([1 10], [252 -273 -7560]); 
% Denominador: [1 1 1] representa s^2 + s + 1
den = conv([1 32 378 1960 3773], [1 1 1]); 

% Crear objeto de función de transferencia para usar con comandos de Matlab
sys = tf(num, den);

% Vector de tiempo
t = 0:0.01:10; 

%% 2. Respuesta al IMPULSO (Analítica vs Matlab)

% --- A) Cálculo Analítico (Residue) ---
[r_imp, p_imp, k_imp] = residue(num, den);

y_imp_analitica = zeros(size(t));
for i = 1:length(r_imp)
    % Se suma la parte real de r*e^(pt). 
    % Al sumar todos los residuos (incluyendo conjugados), la parte imaginaria se cancela.
    y_imp_analitica = y_imp_analitica + real(r_imp(i)*exp(p_imp(i)*t));
end

% Sumar término directo si existe (k_imp)
if ~isempty(k_imp)
    for i = 1:length(k_imp)
        y_imp_analitica = y_imp_analitica + k_imp(i)*(t==0); % Solo afecta en t=0 teóricamente para impulso ideal
    end
end

% --- B) Cálculo con Matlab (Comando impulse) ---
[y_imp_matlab, t_out] = impulse(sys, t);

% --- C) Gráfica Comparativa ---
figure('Name', 'Comparación Impulso');
plot(t, y_imp_analitica, 'b', 'LineWidth', 2.5); % Analítica (Azul gruesa)
hold on;
plot(t, y_imp_matlab, 'r--', 'LineWidth', 1.5);  % Matlab (Roja punteada)
hold off;

title('Comparación: Respuesta al Impulso \delta(t)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Cálculo Analítico (Residue)', 'Comando impulse (Matlab)', 'Location', 'Best');
grid on;


%% 3. Respuesta al ESCALÓN (Analítica vs Matlab)

% --- A) Cálculo Analítico (H(s)/s) ---
% Para escalón, dividimos por s => agregamos un polo en el origen (0)
den_step = conv(den, [1 0]); 

[r_step, p_step, k_step] = residue(num, den_step);

y_step_analitica = zeros(size(t));
for i = 1:length(r_step)
    y_step_analitica = y_step_analitica + real(r_step(i)*exp(p_step(i)*t));
end

% Agregar residuo directo constante si existe
for i = 1:length(k_step)
    y_step_analitica = y_step_analitica + k_step(i);
end

% --- B) Cálculo con Matlab (Comando step) ---
[y_step_matlab, t_out_step] = step(sys, t);

% --- C) Gráfica Comparativa ---
figure('Name', 'Comparación Escalón');
plot(t, y_step_analitica, 'b', 'LineWidth', 2.5); % Analítica (Azul gruesa)
hold on;
plot(t, y_step_matlab, 'r--', 'LineWidth', 1.5);  % Matlab (Roja punteada)
hold off;

title('Comparación: Respuesta al Escalón \mu(t)');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend('Cálculo Analítico (Residue)', 'Comando step (Matlab)', 'Location', 'Best');
grid on;