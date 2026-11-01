sys=tf(1,[1 1],'InputDelay',0.3);
set(sys,'InputName','energy','OutputName','temperature','Notes','A simple heater model');
NoteValue=get(sys,'Notes');
display(NoteValue)
sys.Numerator{1}=2;
sys.Denominator{1}(2)=2;
sys.InputName='Hz';
get(sys)
display(sys)
