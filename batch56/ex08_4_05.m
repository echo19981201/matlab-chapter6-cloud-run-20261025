sysA=tf(1,[1 1 2 23]);
sysB=tf(1,[2 -3]);
sys=series(sysA,sysB);
display('串联系统');display(sys)
