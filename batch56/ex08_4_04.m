sys1=tf([6 42 72],[1 6 11 6]);
sys2=zpk(-3,[-1 -2 -5],6);
sysA=sys1+tf(sys2);
sysB=sys1*tf(sys2);
display('并联');display(sysA)
display('串联');display(sysB)
