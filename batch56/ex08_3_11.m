load_system('simulink');
models={'ex08_3_11_tf','ex08_3_11_zpk'};
for j=1:2
name=models{j};
if bdIsLoaded(name)
close_system(name,0)
end
new_system(name);
add_block('simulink/Ports & Subsystems/In1',[name '/In1'],'Position',[40 100 70 120]);
add_block('simulink/Math Operations/Sum',[name '/Sum'],'Inputs','+-','Position',[130 95 160 125]);
if j==1
add_block('simulink/Continuous/Transfer Fcn',[name '/Plant'],'Numerator','[2 10]','Denominator','[1 3 0]','Position',[230 85 370 135]);
else
add_block('simulink/Continuous/Zero-Pole',[name '/Plant'],'Zeros','[-5]','Poles','[0 -3]','Gain','2','Position',[230 85 370 135]);
end
add_block('simulink/Ports & Subsystems/Out1',[name '/Out1'],'Position',[460 100 490 120]);
add_line(name,'In1/1','Sum/1','autorouting','on');
add_line(name,'Sum/1','Plant/1','autorouting','on');
add_line(name,'Plant/1','Out1/1','autorouting','on');
add_line(name,'Plant/1','Sum/2','autorouting','on');
save_system(name);
open_system(name);
end
