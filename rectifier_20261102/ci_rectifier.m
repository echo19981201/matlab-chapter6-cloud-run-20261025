function ci_rectifier
% Actual R2024b SPS capability probe; no reference images are included.
mkdir('rectifier-output'); diary('rectifier-output/runtime.log');
c=onCleanup(@()diary('off'));
disp(version); ver; fprintf('Commit: %s\nRun: %s\n',getenv('GITHUB_SHA'),getenv('GITHUB_RUN_ID'));
load_system('powerlib');
blocks=find_system('powerlib','LookUnderMasks','all','FollowLinks','on','Type','Block');
names={'Universal Bridge','Three-Phase Source','Three-Phase V-I Measurement','Series RLC Branch','Current Measurement','Voltage Measurement','powergui','Ground','Diode'};
for k=1:numel(names)
 matches=blocks(strcmp(get_param(blocks,'Name'),names{k}));
 fprintf('\n--- %s ---\n',names{k});
 for j=1:numel(matches)
  b=matches{j}; fprintf('PATH %s\n',b);
  fprintf('MASK %s\n',get_param(b,'MaskType'));
  disp(get_param(b,'DialogParameters'));
  mn=get_param(b,'MaskNames'); mv=get_param(b,'MaskValues');
  for z=1:numel(mn), fprintf('%s = %s\n',mn{z},mv{z}); end
 end
end
fprintf('SPS_PROBE_COMPLETE\n');
end
