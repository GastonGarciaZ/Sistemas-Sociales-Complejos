   %%% SIS propagation
clear;
rand('state',0);

N      = 300;
z      = 5.7;
r      = 0.6;
nsteps = 1000;
nave   = 10;

tseries = [];

% p = [0.01:0.02:0.15 0.15:0.05:0.95];
p = [0.7];

error = [0.95 0.9 0.8 0.7 0.6 0.5]  ;
% 
%beta = [0 0.1 0.2 0.25  0.26  0.27  0.28 0.29  0.30 0.31 0.32];

h1 = figure;
contagios_segun_error = zeros(nsteps, length(error));
restringidos_segun_error = zeros(nsteps, length(error));
for k = 1:length(error),
    error_i = error(k);

    i=1;
    tave = []; mave = [];
    disp('__________________')
    disp('__________________')
    disp('__________________')
    disp('__________________')
    disp(strcat('Probabilidad  ', num2str(0.5)))
   
    suma_contagios = 0;
    suma_restringidos = 0;
    while i<=nave,
        disp(strcat('Iteracion  ', num2str(i)))
        [U, tseries, adj]  = sis_net_con_error(N, z, nsteps, 0.5, r, error_i, i);

        suma_contagios = tseries(:,2) + suma_contagios;
        suma_restringidos = tseries(:,3) + suma_restringidos;
        
        
%figure
%plot(tseries(:,1), tseries(:,2), 'r-', tseries(:,1), tseries(:,3), 'g-', tseries(:,1), tseries(:,4), 'm-')
%legend('Infectados','Restrictos', 'Infectados en la Red')
%figure
       
      %pause;  
       i=i+1;  
    end
contagios_segun_error(:, k) = suma_contagios/nave;
restringidos_segun_error(:, k) = suma_restringidos/nave;
    %tseries = [tseries; z pp mean(tave) var(tave) mean(mave) var(mave)];
end


% Gráfico
figure;
 subplot(3,2,1);
 plot(tseries(:,1), contagios_segun_error(:, 1), tseries(:,1), restringidos_segun_error(:, 1));
 legend("Contagiados", "Restringidos")
 title(['$' 'Error = 5\%' '$'],'interpreter','latex','FontSize',12);
 subplot(3,2,2);
 plot(tseries(:,1), contagios_segun_error(:, 2), tseries(:,1), restringidos_segun_error(:, 2));
 legend("Contagiados", "Restringidos")
 title(['$' 'Error = 10\%' '$'],'interpreter','latex','FontSize',12);
  subplot(3,2,3);
 plot(tseries(:,1), contagios_segun_error(:, 3), tseries(:,1), restringidos_segun_error(:, 3));
 legend("Contagiados", "Restringidos")
 title(['$' 'Error = 20\%' '$'],'interpreter','latex','FontSize',12);
  subplot(3,2,4);
 plot(tseries(:,1), contagios_segun_error(:, 4), tseries(:,1), restringidos_segun_error(:, 4));
 legend("Contagiados", "Restringidos")
 title(['$' 'Error = 30\%' '$'],'interpreter','latex','FontSize',12);
  subplot(3,2,5);
 plot(tseries(:,1), contagios_segun_error(:, 5), tseries(:,1), restringidos_segun_error(:, 5));
 legend("Contagiados", "Restringidos")
 title(['$' 'Error = 40\%' '$'],'interpreter','latex','FontSize',12);
  subplot(3,2,6);
 plot(tseries(:,1), contagios_segun_error(:, 6), tseries(:,1), restringidos_segun_error(:, 6));
 legend("Contagiados", "Restringidos")
 title(['$' 'Error = 50\%' '$'],'interpreter','latex','FontSize',12);
  