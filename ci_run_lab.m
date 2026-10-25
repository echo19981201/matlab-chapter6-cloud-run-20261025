function ci_run_lab
root=fileparts(mfilename('fullpath'));
cd(root);
out=fullfile(root,'lab-output');
if ~exist(out,'dir'),mkdir(out);end
fontName='Noto Sans CJK SC';
set(groot,'DefaultAxesFontName',fontName,'DefaultTextFontName',fontName);
set(groot,'DefaultFigureVisible','on','DefaultFigureWindowStyle','normal');
diary(fullfile(out,'run.log'));
fprintf('Actual MATLAB: %s\n',version);
runLabIsolated(fullfile(root,'lab','plot2d_lab.m'));
figs=findall(groot,'Type','figure');
[~,idx]=sort(arrayfun(@(f)f.Number,figs));figs=figs(idx);
assert(numel(figs)==6,'Expected six figures.');
for k=1:6
    set(findall(figs(k),'Type','axes'),'FontSize',14);
    set(findall(figs(k),'Type','text'),'FontSize',14);
    drawnow;
    frame=getframe(figs(k));
    assert(~isempty(frame.cdata),'Empty capture.');
    imwrite(frame.cdata,fullfile(out,sprintf('plot2d_lab_%02d.png',k)));
    savefig(figs(k),fullfile(out,sprintf('plot2d_lab_%02d.fig',k)));
end
copyfile(fullfile(root,'lab','plot2d_lab.m'),out);
fprintf('LAB PASS: 6/6 real figure captures.\n');
diary off;
end
function runLabIsolated(source)
run(source);
assert(max(abs(y1-sin(x)))<1e-12 && max(abs(y2-cos(x)))<1e-12,'Function mismatch.');
assert(isequal(get(gca,'XTick'),[0 pi/2 pi 3*pi/2 2*pi]),'Ticks mismatch.');
end
