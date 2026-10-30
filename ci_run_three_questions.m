function ci_run_three_questions
root=fileparts(mfilename('fullpath'));
cd(root);
out=fullfile(root,'three-output');
if ~exist(out,'dir'),mkdir(out);end
if ~exist(fullfile(out,'images'),'dir'),mkdir(fullfile(out,'images'));end
if ~exist(fullfile(out,'m'),'dir'),mkdir(fullfile(out,'m'));end
diary(fullfile(out,'run.log'));
cleanup=onCleanup(@() diary('off'));
fprintf('Actual MATLAB: %s\n',version);
fprintf('Computer: %s\n',computer);
files={'simulation_1_parzen.m','simulation_2_fisher.m','simulation_3_knn_flowchart.m'};
record=struct('script','','status','not_run','screenshots',{{}},'error','');
results=repmat(record,1,numel(files));
for k=1:numel(files)
    close all force;
    cd(root);
    set(groot,'DefaultAxesFontName','Noto Sans CJK SC','DefaultTextFontName','Noto Sans CJK SC');
    set(groot,'DefaultFigureVisible','on','DefaultFigureWindowStyle','normal', ...
        'DefaultFigurePosition',[40 40 960 720]);
    r=record;r.script=files{k};
    source=fullfile(root,'three-m',files{k});
    try
        assert(exist(source,'file')==2,'Missing source: %s',source);
        vars=runIsolated(source);
        if k==2
            validate_three_fisher(vars);
            fprintf('Fisher numerical verification: PASS\n');
        end
        drawnow;
        figs=findall(groot,'Type','figure');
        assert(numel(figs)==1,'Expected exactly one figure for each question.');
        [~,order]=sort(arrayfun(@(f)f.Number,figs));figs=figs(order);
        [~,name]=fileparts(files{k});
        for j=1:numel(figs)
            figure(figs(j));drawnow;
            frame=getframe(figs(j));
            assert(~isempty(frame.cdata),'Empty screenshot.');
            filename=sprintf('%s_%02d.png',name,j);
            imwrite(frame.cdata,fullfile(out,'images',filename));
            r.screenshots{end+1}=filename;
        end
        r.status='ok';
    catch ME
        r.status='failed';
        r.error=getReport(ME,'extended','hyperlinks','off');
        fprintf(2,'%s\n',r.error);
    end
    results(k)=r;
    fprintf('%s: %s; captures=%d\n',files{k},r.status,numel(r.screenshots));
end
sources=dir(fullfile(root,'three-m','*.m'));
for k=1:numel(sources)
    copyfile(fullfile(sources(k).folder,sources(k).name),fullfile(out,'m',sources(k).name));
end
manifest=struct('engine','MATLAB','version',version,'results',results);
manifest.complete=all(strcmp({results.status},'ok'));
fid=fopen(fullfile(out,'manifest.json'),'w','n','UTF-8');
assert(fid~=-1,'Cannot write manifest.');
fprintf(fid,'%s\n',jsonencode(manifest));fclose(fid);
assert(manifest.complete,'One or more programs failed.');
assert(numel(dir(fullfile(out,'images','*.png')))==3,'Expected exactly three result PNGs.');
fprintf('THREE QUESTIONS PASS: 3/3; real screenshots: 3/3\n');
end
function vars=runIsolated(source)
run(source);
ci_names=who;
vars=struct;
for ci_i=1:numel(ci_names)
    if ~strcmp(ci_names{ci_i},'source')
        vars.(ci_names{ci_i})=eval(ci_names{ci_i});
    end
end
end
