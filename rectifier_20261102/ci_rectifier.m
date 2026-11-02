function ci_rectifier
% Actual R2024b SPS capability probe; no reference images are included.
mkdir('rectifier-output'); diary('rectifier-output/runtime.log');
c=onCleanup(@()diary('off'));
disp(version); ver; fprintf('Commit: %s\nRun: %s\n',getenv('GITHUB_SHA'),getenv('GITHUB_RUN_ID'));
set(groot,'defaultAxesFontName','Noto Sans CJK SC','defaultTextFontName','Noto Sans CJK SC','defaultLegendFontName','Noto Sans CJK SC');
run_all;
sourceRoot=fileparts(mfilename('fullpath'));
copyfile(fullfile(sourceRoot,'models'),'rectifier-output/models');
copyfile(fullfile(sourceRoot,'results'),'rectifier-output/results');
copyfile(fullfile(sourceRoot,'data'),'rectifier-output/data');
copyfile(fullfile(sourceRoot,'rectifier_R_RL_MATLAB_verified.zip'),'rectifier-output');
fprintf('RECTIFIER_SIMULATION_COMPLETE\n');
end
