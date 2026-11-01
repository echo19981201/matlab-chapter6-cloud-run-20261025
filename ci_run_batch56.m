function ci_run_batch56
assert(~exist('OCTAVE_VERSION','builtin'),'Real MATLAB required.');
root=fileparts(mfilename('fullpath'));
srcdir=fullfile(root,'batch56'); out=fullfile(root,'batch-output');
for s={'m','images','logs','models'}, mkdir(fullfile(out,s{1})); end
diary(fullfile(out,'logs','runner.log'));
cleanup=onCleanup(@() diary('off'));
fprintf('Actual MATLAB: %s\nPlatform: %s\n',version,computer); ver
feature('hotlinks',false);
fontName='Noto Sans Mono CJK SC';
assert(any(strcmp(listfonts,fontName)),'Chinese font unavailable');
set(groot,'DefaultFigureVisible','on','DefaultFigureWindowStyle','normal','DefaultAxesFontName',fontName,'DefaultTextFontName',fontName);
files=dir(fullfile(srcdir,'*.m')); assert(numel(files)==56,'Expected 56 scripts');
items=struct('name',{},'success',{},'images',{},'error',{});
for k=1:numel(files)
    filename=files(k).name; [~,stem]=fileparts(filename);
    fprintf('\n=== %d/56 %s ===\n',k,filename);
    close all force; bdclose('all');
    imgs={}; err=''; ok=false;
    try
        output=runOne(fullfile(srcdir,filename));
        writeText(fullfile(out,'logs',[stem '.txt']),output);
        figs=findall(groot,'Type','figure');
        for f=1:numel(figs)
            set(figs(f),'Position',[20 20 1100 760]); drawnow;
            frame=getframe(figs(f));
            name=sprintf('%s_plot_%02d.png',stem,f); imwrite(frame.cdata,fullfile(out,'images',name)); imgs{end+1}=name;
        end
        if strcmp(stem,'ex08_3_11')
            names={'ex08_3_11_tf','ex08_3_11_zpk'};
            for j=1:2
                model=names{j};
                set_param(model,'SimulationCommand','update');
                simout=sim(model,'StopTime','10','ReturnWorkspaceOutputs','on');
                [a,b,c,d]=linmod(model); [n,de]=tfdata(tf(ss(a,b,c,d)),'v');
                n=n/de(1); de=de/de(1);
                assert(max(abs(de-[1 5 10]))<1e-8 && max(abs([zeros(1,3-numel(n)) n]-[0 2 10]))<1e-8,'Simulink closed loop mismatch');
                name=[model '_model.png'];
                print(['-s' model],'-dpng','-r180',fullfile(out,'images',name)); imgs{end+1}=name;
                save_system(model,fullfile(out,'models',[model '.slx']));
                save(fullfile(out,'logs',[model '_simulation.mat']),'simout','a','b','c','d');
                fprintf('PASS Simulink %s: update, sim 10 s, closed-loop coefficients verified.\n',model);
            end
        elseif ~isempty(strtrim(output))
            imgs=[imgs captureText(output,['MATLAB R2024b | ' stem],stem,out,fontName)];
        end
        assert(~isempty(imgs),'No result image generated');
        copyfile(fullfile(srcdir,filename),fullfile(out,'m',filename));
        ok=true;
    catch ME
        err=getReport(ME,'extended','hyperlinks','off');
        writeText(fullfile(out,'logs',[stem '_ERROR.txt']),err); fprintf('%s\n',err);
    end
    items(end+1)=struct('name',filename,'success',ok,'images',{imgs},'error',err);
    manifest=struct('engine','MATLAB','version',version,'release',version('-release'),'toolboxes',ver,'complete',false,'items',items);
    writeText(fullfile(out,'manifest.json'),jsonencode(manifest));
end
manifest.complete=all([items.success]);
writeText(fullfile(out,'manifest.json'),jsonencode(manifest));
fprintf('\nFINAL: %d / 56 scripts passed.\n',sum([items.success]));
assert(manifest.complete,'One or more scripts failed. See individual logs.');
end
function output=runOne(path)
evalin('base','clearvars');
cmd=sprintf('run(''%s'')',strrep(path,'''',''''''));
output=evalc('evalin(''base'',cmd);');
end
function names=captureText(content,heading,prefix,out,fontName)
content=strrep(content,char(13),'');
content=regexprep(content,'<a href="matlab:[^\n]*</a>','');
content=regexprep(content,'\n\s*\n','\n');
lines=regexp(strtrim(content),'\n','split');
% Preserve every actual output character; wrap only excessively wide text.
wrapped={};
for k=1:numel(lines)
    line=lines{k};
    while numel(line)>92, wrapped{end+1}=line(1:92); line=line(93:end); end
    wrapped{end+1}=line;
end
lines=wrapped; perPage=32; names={};
for pg=1:ceil(numel(lines)/perPage)
    pageLines=lines((pg-1)*perPage+1:min(pg*perPage,numel(lines)));
    h=max(360,160+numel(pageLines)*29);
    fig=figure('Color','w','Position',[20 20 1450 h],'MenuBar','none','ToolBar','none','NumberTitle','off','Name',heading);
    ax=axes('Parent',fig,'Position',[0 0 1 1],'Visible','off','XLim',[0 1450],'YLim',[0 h]);
    text(ax,35,h-30,heading,'Interpreter','none','FontName',fontName,'FontUnits','pixels','FontSize',26,'FontWeight','bold','VerticalAlignment','top');
    text(ax,35,h-85,strjoin(pageLines,newline),'Interpreter','none','FontName',fontName,'FontUnits','pixels','FontSize',24,'VerticalAlignment','top');
    drawnow; frame=getframe(fig);
    name=sprintf('%s_result_%02d.png',prefix,pg); imwrite(frame.cdata,fullfile(out,'images',name)); names{end+1}=name; close(fig);
end
end
function writeText(path,txt)
fid=fopen(path,'w','n','UTF-8'); assert(fid~=-1); fprintf(fid,'%s',txt); fclose(fid);
end
