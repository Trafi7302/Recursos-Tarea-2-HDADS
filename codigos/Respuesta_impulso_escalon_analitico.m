%Definir numerador y denominador

K = -0.1248;
num = K * conv([1 10], [252 -273 -7560]);
den = conv([1 32 378 1960 3773], [1 1 1]);

% Respuesta al impulso (inversa de Laplace de H(s))
[r_imp, p_imp, k_imp] = residue(num, den)
t = 0:0.01:10;
y_imp = zeros(size(t));

for i = 1:length(r_imp)
    y_imp = y_imp + real(r_imp(i)*exp(p_imp(i)*t));
end

% Graficar impulso
figure;
plot(t, y_imp, 'b', 'LineWidth', 1.5);
title('Respuesta al impulso \delta(t)');
xlabel('Tiempo (s)');
ylabel('Salida');
grid on;

% Para escalon, dividir H(s)/s = > agregar un polo en el origen
den_step = conv(den, [1 0]);
[r_step, p_step, k_step] = residue(num, den_step)
y_step = zeros(size(t));

for i = 1:length(r_step)
    y_step = y_step + real(r_step(i)*exp(p_step(i)*t));
end
% Agregar residuo directo si existe
for i = 1:length(k_step)
    y_step = y_step + k_step(i);
end

% Graficar escalon
figure;
plot(t, y_step, 'r', 'LineWidth', 1.5);
title('Respuesta al escalon \mu(t)');
xlabel('Tiempo (s)');
ylabel('Salida');
grid on;