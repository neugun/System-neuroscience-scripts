bar(Frequency_before,Duration_before,Magnitude_before,'r',Frequency_stim,Duration_stim,Magnitude_stim,'c');

imagesc(A);
colormap jet
colorbar
axis([0 10 0 50]);
legend('boxoff')
 xlabel('time');
 ylabel('Frequency(Hz)');
 title('Firing rate' );
 
 set(0,'DefaultLineLineWidth',1);
 set(0,'DefaultAxesColorOrder',[0 0 0]);
 set(0,'DefaultAxeslineStyleorder');
 set(0,'DefaultAxesFontSize',14);
 