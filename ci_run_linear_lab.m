function ci_run_linear_lab
assert(~exist('OCTAVE_VERSION','builtin'),'Real MATLAB required.');
assert(strcmp(version('-release'),'2024b'),'Expected MATLAB R2024b.');
root=fileparts(mfilename('fullpath'));
source=fullfile(root,'linear-lab','linear_system_lab.m');
out=fullfile(root,'linear-output');
if ~exist(out,'dir'),mkdir(out);end
for sub={'images','m','logs'}
    if ~exist(fullfile(out,sub{1}),'dir'),mkdir(fullfile(out,sub{1}));end
end
diary(fullfile(out,'logs','runner.log'));
cleanup=onCleanup(@() diary('off'));
fprintf('Actual MATLAB: %s\n',version);
fprintf('Platform: %s\n',computer);
ver control
assert(license('test','Control_Toolbox'),'Control System Toolbox license unavailable.');
feature('hotlinks',false);
set(groot,'DefaultFigureVisible','on','DefaultFigureWindowStyle','normal');
fontName='Noto Sans Mono CJK SC';
assert(any(strcmp(listfonts,fontName)),'Required Chinese monospaced font unavailable.');
raw=fileread(source);
[whole,vars]=runWhole(source);
writeText(fullfile(out,'logs','full_program_output.txt'),whole);
validateModels(vars);
blocks=regexp(strtrim(raw),'\r?\n\s*\r?\n','split');
assert(numel(blocks)==4,'Expected four source blocks.');
blockText=runBlocks(blocks);
images={};
for k=1:4
    writeText(fullfile(out,'logs',sprintf('block_%02d.txt',k)),blockText{k});
    captures=captureText(blockText{k},sprintf('MATLAB R2024b 运行结果 %d',k),sprintf('result_%02d',k),out,fontName);
    images=[images captures];
end
for k=1:4
    src=blocks{k};
    captures=captureText(src,sprintf('MATLAB 程序源码 %d',k),sprintf('source_%02d',k),out,fontName);
    images=[images captures];
end
copyfile(source,fullfile(out,'m','linear_system_lab.m'));
save(fullfile(out,'logs','verified_models.mat'),'-struct','vars');
manifest=struct('engine','MATLAB','version',version,'release',version('-release'),'toolbox',ver('control'),'complete',true,'images',{images});
writeText(fullfile(out,'manifest.json'),jsonencode(manifest));
fprintf('PASS: original script executed; continuous and discrete models/conversions validated.\n');
fprintf('Captures: %d\n',numel(images));
end
function [output,vars]=runWhole(source)
output=evalc('run(source)');
vars=collectVars(Gc,Zc,Sc,Gd,Zd,Sd,Zc1,Sc1,Gc1,Zd1,Sd1,Gd1,Ts);
end
function vars=collectVars(Gc,Zc,Sc,Gd,Zd,Sd,Zc1,Sc1,Gc1,Zd1,Sd1,Gd1,Ts)
vars=struct('Gc',Gc,'Zc',Zc,'Sc',Sc,'Gd',Gd,'Zd',Zd,'Sd',Sd,'Zc1',Zc1,'Sc1',Sc1,'Gc1',Gc1,'Zd1',Zd1,'Sd1',Sd1,'Gd1',Gd1,'Ts',Ts);
end
function texts=runBlocks(blocks)
texts=cell(1,numel(blocks));
for bi=1:numel(blocks)
    texts{bi}=evalc(blocks{bi});
end
end
function validateModels(v)
c={v.Gc,v.Zc,v.Sc,v.Zc1,v.Sc1,v.Gc1};
d={v.Gd,v.Zd,v.Sd,v.Zd1,v.Sd1,v.Gd1};
for k=1:numel(c)
    [num,den]=tfdata(tf(c{k}),'v');
    num=num/den(1);den=den/den(1);
    assert(max(abs(den-[1 3 2]))<1e-10);
    assert(max(abs([zeros(1,3-numel(num)) num]-[0 1 3]))<1e-10);
    assert(c{k}.Ts==0);
end
for k=1:numel(d)
    [num,den]=tfdata(tf(d{k}),'v');
    num=num/den(1);den=den/den(1);
    assert(max(abs(den-[1 -.7 .1]))<1e-10);
    assert(max(abs([zeros(1,3-numel(num)) num]-[0 1 .2]))<1e-10);
    assert(abs(d{k}.Ts-.1)<1e-12);
end
[zc,pc,kc]=zpkdata(v.Zc1,'v');
[zd,pd,kd]=zpkdata(v.Zd1,'v');
assert(abs(zc+3)<1e-10 && max(abs(sort(pc)-[-2;-1]))<1e-10 && abs(kc-1)<1e-10);
assert(abs(zd+.2)<1e-10 && max(abs(sort(pd)-[.2;.5]))<1e-10 && abs(kd-1)<1e-10);
end
function names=captureText(content,heading,prefix,out,fontName)
content=strrep(content,char(13),'');
content=regexprep(content,'<a href="matlab:[^\n]*</a>','');
content=regexprep(content,'\n\s*\n','\n');
lines=regexp(strtrim(content),'\n','split');
perPage=32;
nPages=ceil(numel(lines)/perPage);perPage=ceil(numel(lines)/nPages);names={};
for pg=1:nPages
    pageLines=lines((pg-1)*perPage+1:min(pg*perPage,numel(lines)));
    h=max(360,min(1160,160+numel(pageLines)*30));
    fig=figure('Color','w','Position',[20 20 1100 h],'MenuBar','none','ToolBar','none','NumberTitle','off','Name',heading);
    ax=axes('Parent',fig,'Position',[0 0 1 1],'Visible','off','XLim',[0 1100],'YLim',[0 h]);
    text(ax,40,h-35,heading,'Interpreter','none','FontName',fontName,'FontUnits','pixels','FontSize',27,'FontWeight','bold','VerticalAlignment','top');
    text(ax,40,h-90,strjoin(pageLines,newline),'Interpreter','none','FontName',fontName,'FontUnits','pixels','FontSize',26,'VerticalAlignment','top');
    drawnow;
    frame=getframe(fig);
    assert(~isempty(frame.cdata),'Empty MATLAB frame.');
    filename=sprintf('%s_%02d.png',prefix,pg);
    imwrite(frame.cdata,fullfile(out,'images',filename));
    names{end+1}=filename;
    close(fig);
end
end
function writeText(path,txt)
fid=fopen(path,'w','n','UTF-8');assert(fid~=-1);fprintf(fid,'%s',txt);fclose(fid);
end
