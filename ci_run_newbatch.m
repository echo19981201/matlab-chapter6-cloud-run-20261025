function ci_run_newbatch
root=fileparts(mfilename('fullpath'));
cd(root);
out=fullfile(root,'new-output');
if ~exist(out,'dir'),mkdir(out);end
mkdir(fullfile(out,'m'));mkdir(fullfile(out,'images'));
diary(fullfile(out,'run.log'));
fprintf('Actual MATLAB: %s\n',version);
set(groot,'DefaultAxesFontName','Noto Sans CJK SC','DefaultTextFontName','Noto Sans CJK SC');
set(groot,'DefaultFigureVisible','on','DefaultFigureWindowStyle','normal','DefaultFigurePosition',[40 40 960 720]);
files=dir(fullfile(root,'new-m','*.m'));
assert(numel(files)==23,'Expected 23 source programs.');
record=struct('example','','status','not_run','expected_figures',0,'screenshots',{{}},'error','');
results=repmat(record,1,numel(files));
for k=1:numel(files)
    close all;
    [~,name]=fileparts(files(k).name);
    r=record;r.example=name;r.expected_figures=1;
    if any(strcmp(name,{'ex2_64','ppt09_peaks_mesh_surf'})),r.expected_figures=2;end
    if strcmp(name,'ppt11_polar_petals'),r.expected_figures=4;end
    copyfile(fullfile(files(k).folder,files(k).name),fullfile(out,'m',files(k).name));
    try
        runIsolated(fullfile(files(k).folder,files(k).name));
        drawnow;
        figs=findall(groot,'Type','figure');
        [~,idx]=sort(arrayfun(@(f)f.Number,figs));figs=figs(idx);
        assert(numel(figs)==r.expected_figures,'Unexpected figure count.');
        for q=1:numel(figs)
            drawnow;
            frame=getframe(figs(q));
            assert(~isempty(frame.cdata),'Empty capture.');
            basename=name;
            if numel(figs)>1,basename=sprintf('%s_fig%d',name,q);end
            filename=[basename '.png'];
            imwrite(frame.cdata,fullfile(out,'images',filename));
            r.screenshots{end+1}=filename;
        end
        r.status='ok';
    catch ME
        r.status='failed';r.error=getReport(ME,'extended','hyperlinks','off');
        fprintf(2,'%s\n',r.error);
    end
    results(k)=r;
    fprintf('%s: %s (%d expected figures)\n',name,r.status,r.expected_figures);
end
manifest=struct('engine','MATLAB','version',version,'results',results,'succeeded',sum(strcmp({results.status},'ok')));
manifest.complete=manifest.succeeded==23;
fid=fopen(fullfile(out,'manifest.json'),'w','n','UTF-8');
fprintf(fid,'%s\n',jsonencode(manifest));fclose(fid);
fprintf('NEW BATCH RESULT: %d/23 passed.\n',manifest.succeeded);
diary off;
assert(manifest.complete,'New batch incomplete.');
assert(numel(dir(fullfile(out,'images','*.png')))==28,'Expected 28 screenshots.');
end
function runIsolated(source)
run(source);
end
