% Definicion de numerador y denominador de F2(s)
num_F2 = [252 -273 -7560];
den_F2 = [1 32 378 1960 3773];

% Crear la funcion de transferencia
F2 = tf(num_F2, den_F2);

% Graficar respuesta al escalon
figure;
step(F2);
title('Respuesta al escalon de F_2(s)');
ylabel('Salida');
xlabel('Tiempo (s)');
grid on;

% Obtener informacion de la respuesta al escalon
%info = stepinfo(F2);
%disp(info);

% Agregamos un par de polos conjugados con menor amortiguamiento
% Polos en -1 + (+-j) -> s^2 + 2s + 2 (aprox) o s^2+s+1 segun ajuste
p_dominantes = conv([1 1 -1], [1 1 +1]); 

% Agregamos esos polos al denominador original
den_mod = conv(den_F2, [1 1 1]); 
% Agregamos un cero en s = -10
num_mod = conv([1 10], num_F2); 

% Funcion base sin ganancia
H_base = tf(num_mod, den_mod);

% Ajustar ganancia para estado estacionario deseado (2.5)
K = 2.5 / dcgain(H_base);
H_os = K * H_base;

% Simular nueva respuesta
figure;
step(H_os);
title('Respuesta al escalon de H(s) ajustada');
grid on;
info_os = stepinfo(H_os);
disp(info_os);