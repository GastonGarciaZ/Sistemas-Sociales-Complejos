% plots

z = 16; p = 0.1; r = 0.4;
[uu, ts1,adj] = sis_net(100,z,350,p,r); 
plot(ts(:,1), ts(:,2), 'r-')
xlabel('t');
ylabel('i(t)');

ll1 = p*z/r
1-1/ll1

print -depsc 'sis.eps'
system('/usr/local/bin/convert sis.eps -resize 500x400 sis.pdf;  cp sis.pdf ../../workbook-figs')

