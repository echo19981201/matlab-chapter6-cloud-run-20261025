sys=tf(1,[1 1 2 23]);
closed=feedback(sys,1);
display('单位负反馈闭环传递函数');display(closed)
