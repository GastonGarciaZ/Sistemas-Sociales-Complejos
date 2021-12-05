% Generates an adjacency matrix for N agents and average degree z
%
% 2006 M Zimmermann
%
function adj = adj_rand(N,z)

adj    = zeros(N);
nlinks = N*z/2;

while nlinks>0,
   x= floor(rand(1,2)*N) + 1;
   while adj(x(1),x(2)) == 1 || x(1) == x(2),
      x= floor(rand(1,2)*N) + 1;
   end
   
   adj(x(1),x(2))=1;
   adj(x(2),x(1))=1;
   
   nlinks = nlinks - 1;
end
