function p = rectifier_parameters
p.lineVoltageRms = 380;
p.frequency = 50;
p.resistance = 20;
p.inductance = 0.05;
p.sampleTime = 2e-5;
p.stopTime = 0.30;
p.fftStart = 0.20;
p.fftCycles = 5;
p.maxHarmonic = 50;
end
