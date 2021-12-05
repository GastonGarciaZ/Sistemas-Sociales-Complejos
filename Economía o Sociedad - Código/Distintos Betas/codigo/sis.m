%%% SIS pr  opagation
clear;
rand('state',0);

N      = 300;
z      = 5.7;
r      = 0.6;
nsteps = 10000;
nave   = 10;

tseries = [];

% p = [0.01:0.02:0.15 0.15:0.05:0.95];
% p = [0.3 0.4 0.45 0.5 0.55 0.6 0.7];
p = 0.7;

beta = [0 0.1 0.2 0.25 0.26 0.27 0.28 0.29 0.31 0.32 0.33 0.34 0.35 0.4 0.5 0.6 0.7 0.8 0.9 1];
%beta = [0 1];
% 
%beta = [0 0.1 0.2 0.25  0.26  0.27  0.28 0.29  0.30 0.31 0.32];


economia_segun_beta = zeros(nsteps, length(beta));
contagios_segun_beta = zeros(nsteps, length(beta));
restringidos_segun_beta = zeros(nsteps, length(beta));
for k = 1:length(beta),
    
    beta_i = beta(k);

    i=1;
    tave = []; mave = [];
    disp('__________________')
    disp('__________________')
    disp('__________________')
    disp('__________________')
    %disp(strcat('Probabilidad  ', num2str(0.5)))
    
    suma_economia = 0;
    suma_contagios = 0;
    suma_restringidos = 0;
    while i<=nave,
        disp(strcat('Iteracion  ', num2str(i)))
        [U, tseries, adj_p]  = sis_net(N, z, nsteps, p, beta_i, r, i);
        suma_economia = tseries(:,5) + suma_economia;
        suma_contagios = tseries(:,2) + suma_contagios;
        suma_restringidos = tseries(:,3) + suma_restringidos;
        
%figure
%plot(tseries(:,1), tseries(:,2), 'r-', tseries(:,1), tseries(:,3), 'g-', tseries(:,1), tseries(:,4), 'm-')
%legend('Infectados','Restrictos', 'Infectados en la Red')
%figure
       
      %pause;  
       i=i+1;  
    end
economia_segun_beta(:, k) = suma_economia/nave;
contagios_segun_beta(:, k) = suma_contagios/nave;
restringidos_segun_beta(:, k) = suma_restringidos/nave;
    %tseries = [tseries; z pp mean(tave) var(tave) mean(mave) var(mave)];
end

%% plots
%figure(h1);
 %   plot(tseries(:,1), economia_segun_beta(:, 1),  '-', tseries(:,1), economia_segun_beta(:, 2), '-', tseries(:,1), economia_segun_beta(:, 3), '-' , tseries(:,1), economia_segun_beta(:, 4), '-' , tseries(:,1), economia_segun_beta(:, 5), '-', tseries(:,1), economia_segun_beta(:, 6), '-' , tseries(:,1), economia_segun_beta(:, 7), '-', tseries(:,1), economia_segun_beta(:, 8), '-' , tseries(:,1), economia_segun_beta(:, 9), '-', tseries(:,1), economia_segun_beta(:, 10), '-', tseries(:,1), economia_segun_beta(:, 11), '-', 'LineWidth', 1);
  %  legend("Beta = 0", "Beta = 0.1", "Beta = 0.2", "Beta = 0.3", "Beta = 0.4", "Beta = 0.5", "Beta = 0.6", "Beta = 0.7", "Beta = 0.8", "Beta = 0.9", "Beta = 1");
   % hold on;  
   
%  % Plot de contagios según p sin gobierno
%  figure;
%  subplot(3,2,1);
%  plot(tseries(:,1), contagios_segun_p(:, 1));
%  title(['$' 'p = 0.3' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,2);
%  plot(tseries(:,1), contagios_segun_p(:, 2));
%  title(['$' 'p = 0.4' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,3);
%  plot(tseries(:,1), contagios_segun_p(:, 3));
%  title(['$' 'p = 0.45' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,4);
%  plot(tseries(:,1), contagios_segun_p(:, 4));
%  title(['$' 'p = 0.5' '$'],'interpreter','latex','FontSize',12); 
%  subplot(3,2,5);
%  plot(tseries(:,1), contagios_segun_p(:, 5));
%  title(['$' 'p = 0.55' '$'],'interpreter','latex','FontSize',12); 
%  subplot(3,2,6); 
%  plot(tseries(:,1), contagios_segun_p(:, 6));
%  title(['$' 'p = 0.6' '$'],'interpreter','latex','FontSize',12); 
%  
%  % Contagios con p = 0.7
%  figure;
%  plot(tseries(:,1), contagios_segun_p(:, 7));
%  title(['$' 'p = 0.7' '$'],'interpreter','latex','FontSize',12); 

   
 % 2. Gráfico de evolución de contagios
%  figure;
%  subplot(3,2,1);
%  plot(tseries(:,1), contagios_segun_beta(:, 1), tseries(:,1), restringidos_segun_beta(:, 1));
%  legend("Contagiados", "Restringidos")
%  title(['$' '\beta = 0' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,2);
%  plot(tseries(:,1), contagios_segun_beta(:, 3), tseries(:,1), restringidos_segun_beta(:, 3));
%  legend("Contagiados", "Restringidos")
%  title(['$' '\beta = 0.2' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,3);
%  plot(tseries(:,1), contagios_segun_beta(:, 14), tseries(:,1), restringidos_segun_beta(:, 14));
%  legend("Contagiados", "Restringidos")
%  title(['$' '\beta = 0.4' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,4);
%  plot(tseries(:,1), contagios_segun_beta(:, 16), tseries(:,1), restringidos_segun_beta(:, 16));
%  legend("Contagiados", "Restringidos")
%  title(['$' '\beta = 0.6' '$'],'interpreter','latex','FontSize',12); 
%  subplot(3,2,5);
%  plot(tseries(:,1), contagios_segun_beta(:, 18), tseries(:,1), restringidos_segun_beta(:, 18));
%  legend("Contagiados", "Restringidos")
%  title(['$' '\beta = 0.8' '$'],'interpreter','latex','FontSize',12); 
%  subplot(3,2,6); 
%  plot(tseries(:,1), contagios_segun_beta(:, 20), tseries(:,1), restringidos_segun_beta(:, 20));
%  legend("Contagiados", "Restringidos")
%  title(['$' '\beta = 1' '$'],'interpreter','latex','FontSize',12); 
%  
%   % 3. Gráfico de evolución de la economía
%  figure;
%  subplot(3,2,1);
%  plot(tseries(:,1), economia_segun_beta(:, 1));
%  legend("Cantidad de Links")
%  title(['$' '\beta = 0' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,2);
%  plot(tseries(:,1), economia_segun_beta(:, 3));
%  legend("Cantidad de Links")
%  title(['$' '\beta = 0.2' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,3);
%  plot(tseries(:,1), economia_segun_beta(:, 14));
%  legend("Cantidad de Links")
%  title(['$' '\beta = 0.4' '$'],'interpreter','latex','FontSize',12);
%  subplot(3,2,4);
%  plot(tseries(:,1), economia_segun_beta(:, 16));
%  legend("Cantidad de Links")
%  title(['$' '\beta = 0.6' '$'],'interpreter','latex','FontSize',12); 
%  subplot(3,2,5); 
%  plot(tseries(:,1), economia_segun_beta(:, 18));
%  legend("Cantidad de Links")
%  title(['$' '\beta = 0.8' '$'],'interpreter','latex','FontSize',12); 
%  subplot(3,2,6); 
%  plot(tseries(:,1), economia_segun_beta(:, 20));
%  legend("Cantidad de Links")
%  title(['$' '\beta = 1' '$'],'interpreter','latex','FontSize',12); 
%  savefig('Evolución_contagios_segun_beta.fig')
% 
%  
%  % 4. Buscamos el Beta umbral
%  figure;
%  subplot(5,2,1);
%  plot(tseries(:,1), contagios_segun_beta(:, 3));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.25' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,2);
%  plot(tseries(:,1), contagios_segun_beta(:, 4));
%  axis([0 inf 0 1])
%   title(['$' '\beta = 0.26' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,3);
%  plot(tseries(:,1), contagios_segun_beta(:, 5));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.27' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,4);
%  plot(tseries(:,1), contagios_segun_beta(:, 6));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.28' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,5);
%  plot(tseries(:,1), contagios_segun_beta(:, 7));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.29' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,6);
%  plot(tseries(:,1), contagios_segun_beta(:, 8));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.31' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,7);
%  plot(tseries(:,1), contagios_segun_beta(:, 9));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.32' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,8);
%  plot(tseries(:,1), contagios_segun_beta(:, 10));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.33' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,9);
%  plot(tseries(:,1), contagios_segun_beta(:, 11));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.34' '$'],'interpreter','latex','FontSize',12);
%  subplot(5,2,10);
%  plot(tseries(:,1), contagios_segun_beta(:, 12));
%  axis([0 inf 0 1])
%  title(['$' '\beta = 0.35' '$'],'interpreter','latex','FontSize',12);
%  savefig('Beta_Umbral.fig')


%   % 5. Gráfico de restricciones de testeo (Beta = 0 y p = 0.7)
%  figure;
%  subplot(2,2,1);
%  plot(Contagios(:,4));
%  axis([0 inf 0 1])
%  title(['$' 'Capacidad = 80\%' '$'],'interpreter','latex','FontSize',12);
%  subplot(2,2,2);
%  plot(Contagios(:,3));
%  axis([0 inf 0 1])
%  title(['$' 'Capacidad = 60\%' '$'],'interpreter','latex','FontSize',12);
%  subplot(2,2,3);
%  plot(Contagios(:,2));
%  axis([0 inf 0 1])
%  title(['$' 'Capacidad = 40\%' '$'],'interpreter','latex','FontSize',12);
%  subplot(2,2,4);
%  plot(Contagios(:,1));
%  axis([0 inf 0 1])
%  title(['$' 'Capacidad = 20\%' '$'],'interpreter','latex','FontSize',12); 
%  savefig('Evolución_contagios_segun_cap_test.fig')
   
   
   
%xx = tseries(:,2);
%xx1= 0.01:0.01:0.95;
%yy = 1-r/z./xx1;
%yy1 = yy(find(yy >= 0));
%xx1 = xx1(find(yy >= 0));
%plot(xx, tseries(:,3), 'ro', xx, tseries(:,5), 'b+', xx1, yy1, 'g-')
%legend('mean i','max i', 'i^*_B')
%xlabel('p')

%%
% print -depsc 'sis-p.eps'
% system('/usr/local/bin/convert sis-p.eps -resize 500x400 sis-p.pdf;  cp sis-p.pdf ../../workbook-figs')

% dlmwrite('sis.txt', tseries, 'delimiter','\t')