%% Performs a SIS contaqion for a net of N nodes, average degree Z
%%   nsteps number of steps
%%   p   is probability of contagion
%%   r   is probability of recovery
%%
%%   M Zimmermann @2008
%%
function [U, tseries, adj] = sis_net(N, z, nsteps, p_i, r0, n_i)

   global adj p beta r CX Restricted n_tam z_tam links_0 adj_0 error 
   beta = 1;
   p = p_i;
   r = r0;
   n_tam = N;
   z_tam =z;
   error = 1.1;
   
   rand('state',n_i);
   adj = adj_rand(N,z);
   adj_0 = adj;
   % select random node
   rand('state',0);
   flip    = randi([1,N],1,1);
   U       = zeros(1,N);
   Restricted = zeros(1,N);
   CX = sum(adj,2);
   
   U(flip) = 1;
   inf     = 1;
   rec     = 0;
  flag =0;
   tseries = [];
   step    = 0;

   if step == 0,
      
     links_0=flinks(U,adj);
   end
   while step < nsteps,
       if step >= nsteps*0.2,
            %flag=1;
        end  
       %[U] = infect_sync(U);
       [U] = infect_async(U,flag);
       tseries = [tseries; step sum(U)/N sum(Restricted)/N sum(U.*(1-Restricted))/N flinks(U,adj)/links_0];
      
       step = step+1;
   end

end

function[Util] = Util(U,matrix)

    global adj 

    AgUtil = 0;
    healthy=0;
    unhealthy=0;
    for i =1:length(U),
        if U(i) == 0,
           healthy =sum(matrix(i,:))*1.5;
        else
           unhealthy = sum(matrix(i,:))*.5;
        end
    AgUtil =healthy - unhealthy + AgUtil;
    end

    Util = AgUtil/2;


end


function[links] = flinks(U,matrix)

    links = 0;
    for i =1:length(U),
        links =sum(matrix(i,:)) + links;
    end
    links = links/2;
end

function[L] = Loss(links_0,links,beta,contagios)    
    L = beta*(links_0 - links)^2 + (1-beta)*contagios^2;
end




function[NodoUtil] = N_util(U)
    global adj
    NodoUtil = zeros(1,length(U));
    for i =1:length(U),
        for j =1:length(U),
            if U(i) == 1,
                NodoUtil(i) =adj(i,j)*1.5 +NodoUtil(i);
            else
                NodoUtil(i) = -adj(i,j)*.5 +NodoUtil(i);
            end
        end
    end
        
        
end

function Reconnect(U)
    global adj Restricted n_tam z_tam adj_0
    
    for i = 1:length(U),
        if  sum(Restricted) <= 0.0000001* length(Restricted),
           %disp('Fin de liberaci?n')
            return
        end
        if (U(i) == 0) && (Restricted(i)==1)
            values = rand(1,length(U)) < z_tam/n_tam;
            adj(:,i) = adj_0(:,i).* (1- Restricted)' ;
            adj(i,:) = adj_0(i,:).* (1- Restricted) ;
            Restricted(i)=0;
            %disp(strcat('Se liber? el nodo n?mero : ',num2str(i)))
        end
    end
    
    
end

 
function [U_noised] = scramble(U)
error = 1;
U_noised = zeros(1,length(U));
   for i= 1:length(U),
       if U(i)==1,
           U_noised(i) = rand(1,1) < error;
       end
       if U(i)==0,
           U_noised(i) = rand(1,1) > error;
       end
   end
end

function [pre_result] = Decission(U)
    global adj Restricted beta links_0 p r z_tam
    Dec=0;
    N = length(U);
    pre_result = zeros(1,length(U));
    %?disp('-------------------')
    %?disp('Heuristica empezada') 
    % Si queremos que se equivoque en algunos diagnósticos activamos:
    U_noised = scramble(U);
    % Capacidad de testeo 25% de la red
    for i = 1:length(U_noised),
        if Restricted(i) == 1,
        else
            if U_noised(i) == 0,
            else
                matrix = adj;
                matrix(i,:)=0;
                matrix(:,i)=0;
                links_corta = flinks(U,matrix);
                links_no_corta = flinks(U,adj);
                contagios_no_corta = (sum(U.*(1-Restricted)))*(1+p*z_tam-r);
                contagios_corta = (sum(U.*(1-Restricted)))*(1+p*z_tam-r)-1-p*sum(adj(i,:));
                Loss_no_corta = Loss(links_0, links_no_corta, beta, contagios_no_corta);
                Loss_corta = Loss(links_0, links_corta, beta, contagios_corta);
                pre_result(i) = Loss_no_corta - Loss_corta;
                % Vamos a cortar siempre que pre_result sea mayor a cero
                % (pérdida por no cortar mayor a pérdida por cortar).
            end
        end
    end
%     pre_result(find(pre_result==0)) = max(pre_result );
%     %disp(pre_result)
%     Dec = find(pre_result == min(pre_result));
%     if length(Dec) > 1,
%         Dec = Dec(1);
%      end
%     disp(strcat('Heuristica terminada, nodo a aislar :  ', num2str(Dec)))
%     disp(strcat('P?rdida actual: ', num2str(min(pre_result)))) 
end


function[idx] = FirstKMax(Result,K)
idx = zeros(1,K);
X = Result;
c = 0;
     for j = 1: K
         [c, I] = max(X);
         X(I) = -Inf;
         idx(j) = I;
         %disp(c)
     end
     %disp(idx)
end




function collect(pre_result,N)
global Restricted adj
        idx = FirstKMax(pre_result,N);
        for j =1:length(idx)
            if pre_result(idx(j))>0
                adj(:,idx(j)) = 0;
                adj(idx(j),:) = 0;
                Restricted(idx(j)) = 1;
                %disp(".");
            end
        end 
end


% Infect and recover asyncronously the field U
function [U] = infect_async(U,flag)
   global adj p r Restricted 
   N = length(U);
   
   sel =  randi([1,N],1,N);
    %?disp(strcat('Nodos Infectados total:  ',  num2str(sum(U))))
    %?disp(strcat('Nodos Infectados en la red:  ',  num2str(sum(U.*(1-Restricted)))))
   if flag ==1,
       %
       %if length(Restricted(Restricted==1)) > 0.2*length(Restricted) ,
       Reconnect(U)
       %end
%        result = find(U==1);
      %?disp('__________________')
      %?
      %disp(strcat('Nodos restringidos post:  ',  num2str(sum(Restricted)))) 
      %disp(strcat('Nodos restringidos e infectados :  ',  num2str(length(Restricted(U==1))))) 


      %disp(strcat('Utilidad antes de decidir : ',num2str(Util(U,adj))))
      result = Decission(U);
      %disp(result)
      collect(result,30);
      %?disp(strcat('Nodos a restringidos pre:  ',  num2str(sum(Restricted)))) 
      %disp(strcat('P?rdida : ',num2str(Util(U,adj))))
      %disp(strcat('Nodos Infectados',  num2str(length(Restricted(Restricted==1))))) 

      %?disp('__________________')

       
       
   end

   for i = 1:length(sel),
      x   = sel(i);
      
      if U(x) == 0,        
          nei = find(adj(x,:)==1);      % find neighbors
          inf = find(U(nei) == 1);      % find infected neighbors
          pp = rand(1,length(inf)) < p; 
          if sum(pp) > 0,
            U(x) = 1;
          end
      else
          if rand(1,1) < r,             % if infected, is recovered?
              U(x) = 0;
          end
      end
      
   end   
end


function [Unew] = infect_sync(U)

global adj p r

   Unew = U;
   
   % infect suceptibles
   suceptible = find(U==0);
   for i = 1:length(suceptible),
      x   = suceptible(i);
      nei = find(adj(x,:)==1);           % find neighbors
      ii  = find(U(nei) == 1);
      pp = rand(1,length(ii)) < p;
      if sum(pp) > 0,
          Unew(x) = 1;
      end
      
   end
   
   % infected become suceptible again
   infected = find(U==1);
   xx       = rand(1,length(infected)) < r;
   Unew(infected(xx)) = 0;
      
end