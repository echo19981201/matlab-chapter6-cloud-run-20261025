sysA=tf(1,[1 1 2 23]);
sysB=tf(1,[2 -3]);
sys=parallel(sysA,sysB);
display('并联系统');display(sys)
