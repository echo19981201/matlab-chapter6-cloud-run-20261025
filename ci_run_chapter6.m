function ci_run_chapter6
% CI entry point. Only real MATLAB may produce these deliverables.
assert(~exist('OCTAVE_VERSION', 'builtin'), 'Actual MATLAB is required.');
assert(strcmp(version('-release'), '2024b'), 'Expected MATLAB R2024b.');
root = fileparts(mfilename('fullpath'));
cd(root);
if ~exist('ci-diagnostics', 'dir'), mkdir('ci-diagnostics'); end
if ~exist('output', 'dir'), mkdir('output'); end
fprintf('MATLAB version: %s\n', version);
fprintf('Display: %s\n', getenv('DISPLAY'));
fonts = listfonts;
fontName = 'Noto Sans CJK SC';
assert(any(strcmp(fonts, fontName)), 'Chinese font is unavailable to MATLAB.');
set(groot, 'DefaultAxesFontName', fontName, 'DefaultTextFontName', fontName);
set(groot, 'DefaultFigureVisible', 'on', 'DefaultFigureWindowStyle', 'normal');
opengl info;

% Fail early if this real runner cannot capture and play figure frames.
f = figure('Name', 'CI graphics validation', 'Position', [40 40 640 480]);
cleanupFigure = onCleanup(@() closeIfValid(f));
h = surf(peaks(15));
title('中文字体与图形捕获检查');
drawnow;
smokeFrames(1) = getframe(f);
rotate(h, [0 0 1], 15);
drawnow;
smokeFrames(2) = getframe(f);
assert(~isempty(smokeFrames(1).cdata), 'getframe returned no pixels.');
assert(std(double(smokeFrames(1).cdata(:))) > 1, 'Graphics capture is blank.');
movie(f, smokeFrames, 1, 10);
imwrite(smokeFrames(1).cdata, fullfile('ci-diagnostics', 'graphics-smoke.png'));
clear cleanupFigure;
blankFigure = figure('Name', 'Blank figure validation', 'Position', [40 40 600 600]);
cleanupBlank = onCleanup(@() closeIfValid(blankFigure));
drawnow;
blankCapture = getframe(blankFigure);
assert(~isempty(blankCapture.cdata), 'Cannot capture the intentionally blank first example.');
clear cleanupBlank;

[zipPath, manifest] = run_chapter6_verified(fullfile(root, 'output'));
fprintf('Produced ZIP: %s\n', zipPath);
assert(manifest.complete && manifest.succeeded == 28 && manifest.failed == 0, ...
    'Chapter6:Incomplete', 'Expected 28/28 successful examples. Inspect logs.');
end

function closeIfValid(fig)
if isgraphics(fig), delete(fig); end
end
