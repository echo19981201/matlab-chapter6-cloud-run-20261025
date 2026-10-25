function [zipPath, manifest] = run_chapter6_verified(outputRoot)
% Run the 28 unchanged source scripts in actual MATLAB, capture, and package.
% Usage: [zipPath, manifest] = run_chapter6_verified;
% No output images are bundled with this runner. They are created by MATLAB.

if exist('OCTAVE_VERSION', 'builtin')
    error('Chapter6:MATLABRequired', 'This runner requires actual MATLAB, not Octave.');
end
runnerRoot = fileparts(mfilename('fullpath'));
programDir = fullfile(runnerRoot, 'm');
if nargin < 1, outputRoot = fullfile(runnerRoot, 'output'); end
if ~exist(outputRoot, 'dir'), mkdir(outputRoot); end
runDir = tempname(outputRoot);
mkdir(runDir);
subdirs = {'m','images','figures','animation_frames'};
for d = 1:numel(subdirs), mkdir(fullfile(runDir, subdirs{d})); end
names = [arrayfun(@(k) sprintf('task6_1_%02d', k), 1:26, ...
    'UniformOutput', false), {'task6_2_01','task6_2_02'}];
for k = 1:numel(names)
    source = fullfile(programDir, [names{k} '.m']);
    assert(exist(source, 'file') == 2, 'Missing source: %s', source);
    copyfile(source, fullfile(runDir, 'm', [names{k} '.m']));
end
if exist(fullfile(runnerRoot, 'SOURCE_SHA256.txt'), 'file')
    copyfile(fullfile(runnerRoot, 'SOURCE_SHA256.txt'), runDir);
end

oldVisible = get(groot, 'DefaultFigureVisible');
oldStyle = get(groot, 'DefaultFigureWindowStyle');
oldPosition = get(groot, 'DefaultFigurePosition');
restoreDefaults = onCleanup(@() restoreFigureDefaults(oldVisible, oldStyle, oldPosition));
set(groot, 'DefaultFigureVisible', 'on', 'DefaultFigureWindowStyle', 'normal');
set(groot, 'DefaultFigurePosition', [40 40 960 720]);
diary(fullfile(runDir, 'run.log'));
diaryCleanup = onCleanup(@() diary('off'));
fprintf('Actual MATLAB Chapter 6 run\nVersion: %s\nPlatform: %s\n', version, computer);
fprintf('Start: %s\nSource scripts are unchanged.\n', datestr(now, 31));
fprintf('Capture: getframe(figure) + imwrite; interior only, no OS chrome.\n');
fprintf('task6_1_01 intentionally creates a blank figure.\n');
fprintf('Multi-stage examples retain all textbook stages.\n');

manifest = struct;
manifest.engine = 'MATLAB';
manifest.version = version;
manifest.platform = computer;
manifest.started_at = datestr(now, 31);
manifest.expected_examples = numel(names);
manifest.source_scripts_executed_without_runtime_edits = true;
manifest.capture_method = 'getframe(figure) + imwrite';
manifest.notes = {'task6_1_01 is intentionally blank'; ...
    'task6_1_04/05/06 preserve all textbook plot stages'; ...
    'Animation frames are original getframe outputs retained by scripts 25 and 26'};
record = struct('example', '', 'status', 'not_run', 'figure_count', 0, ...
    'screenshots', {{}}, 'figure_files', {{}}, 'animation_frames', {{}}, ...
    'seconds', 0, 'error', '', 'warnings', {{}});
manifest.results = repmat(record, 1, numel(names));

for k = 1:numel(names)
    item = record;
    item.example = names{k};
    beforeFigures = findall(groot, 'Type', 'figure');
    started = tic;
    fprintf('\n=== %s ===\n', names{k});
    try
        frameSets = runSourceIsolated(fullfile(programDir, [names{k} '.m']));
        drawnow;
        madeFigures = newFigures(beforeFigures);
        item.figure_count = numel(madeFigures);
        expectedCount = 1;
        if strcmp(names{k}, 'task6_1_04'), expectedCount = 4; end
        if any(strcmp(names{k}, {'task6_1_05','task6_1_06'})), expectedCount = 2; end
        assert(numel(madeFigures) == expectedCount, 'Chapter6:FigureCount', ...
            'Expected %d new figures; found %d.', expectedCount, numel(madeFigures));
        for f = 1:numel(madeFigures)
            fig = madeFigures(f);
            drawnow;
            captured = getframe(fig);
            assert(~isempty(captured.cdata), 'Chapter6:EmptyCapture', 'No captured pixels.');
            outputName = names{k};
            if numel(madeFigures) > 1, outputName = sprintf('%s_%02d', names{k}, f); end
            pngRelative = fullfile('images', [outputName '.png']);
            imwrite(captured.cdata, fullfile(runDir, pngRelative));
            item.screenshots{end+1} = pngRelative;
            figRelative = fullfile('figures', [outputName '.fig']);
            try
                savefig(fig, fullfile(runDir, figRelative));
                item.figure_files{end+1} = figRelative;
            catch figError
                item.warnings{end+1} = ['Optional .fig: ' figError.message];
            end
        end
        for s = 1:numel(frameSets)
            for frameIndex = 1:numel(frameSets(s).frames)
                frame = frameSets(s).frames(frameIndex);
                frameRelative = fullfile('animation_frames', sprintf('%s_%s_%02d.png', ...
                    names{k}, frameSets(s).name, frameIndex));
                if isempty(frame.colormap)
                    imwrite(frame.cdata, fullfile(runDir, frameRelative));
                else
                    imwrite(frame.cdata, frame.colormap, fullfile(runDir, frameRelative));
                end
                item.animation_frames{end+1} = frameRelative;
            end
        end
        item.status = 'ok';
    catch ME
        item.status = 'failed';
        item.error = getReport(ME, 'extended', 'hyperlinks', 'off');
        fprintf(2, '%s\n', item.error);
    end
    item.seconds = toc(started);
    manifest.results(k) = item;
    fprintf('%s: %s (%.3f s)\n', names{k}, item.status, item.seconds);
    madeFigures = newFigures(beforeFigures);
    for f = 1:numel(madeFigures)
        if isgraphics(madeFigures(f)), delete(madeFigures(f)); end
    end
    save(fullfile(runDir, 'manifest.mat'), 'manifest');
end

manifest.finished_at = datestr(now, 31);
manifest.succeeded = sum(strcmp({manifest.results.status}, 'ok'));
manifest.failed = numel(names) - manifest.succeeded;
manifest.complete = manifest.succeeded == numel(names);
save(fullfile(runDir, 'manifest.mat'), 'manifest');
fid = fopen(fullfile(runDir, 'manifest.json'), 'w', 'n', 'UTF-8');
assert(fid ~= -1, 'Cannot open manifest.json');
fileCleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s\n', jsonencode(manifest));
clear fileCleanup;
fprintf('\nRESULT: %d/%d succeeded; %d failed.\n', manifest.succeeded, numel(names), manifest.failed);
fprintf('Output directory: %s\n', runDir);
diary('off');
clear diaryCleanup;
zipPath = [runDir '.zip'];
entries = [subdirs, {'run.log', 'manifest.json', 'manifest.mat'}];
if exist(fullfile(runDir, 'SOURCE_SHA256.txt'), 'file')
    entries{end+1} = 'SOURCE_SHA256.txt';
end
zip(zipPath, entries, runDir);
fprintf('ZIP: %s\n', zipPath);
if ~manifest.complete
    warning('Chapter6:Incomplete', 'Not all scripts succeeded. ZIP contains a failure log, not a complete result.');
end
end

function frameSets = runSourceIsolated(runnerSourcePath)
% This function workspace isolates source variables from runner state.
run(runnerSourcePath);
[~, auditName] = fileparts(runnerSourcePath);
if strcmp(auditName, 'task6_1_22')
    assert(numel(z) == 10 && max(abs(z - (x.^2 + 2*y))) < 1e-12, 'Incorrect stem heights.');
    fprintf('AUDIT PASS: z=x.^2+2*y, 10 stems.\n');
end
if strcmp(auditName, 'task6_1_25')
    assert(isequal(size(X), [41 41]) && abs(min(X(:)) + 3*pi) < 1e-12 && abs(max(X(:)) - 3*pi) < 1e-12, 'Incorrect radial surface range.');
    assert(abs(Z(21,21)-1) < 1e-12, 'Incorrect center of radial surface.');
    fprintf('AUDIT PASS: 41x41 mesh over [-3*pi,3*pi], center Z=1.\n');
end
frameSets = struct('name', {}, 'frames', {});
if exist('frames', 'var')
    frameSets(end+1) = struct('name', 'frames', 'frames', frames);
end
if exist('smallFrames', 'var')
    frameSets(end+1) = struct('name', 'smallFrames', 'frames', smallFrames);
end
if exist('largeFrames', 'var')
    frameSets(end+1) = struct('name', 'largeFrames', 'frames', largeFrames);
end
end

function figs = newFigures(before)
allFigures = findall(groot, 'Type', 'figure');
figs = allFigures(~ismember(allFigures, before));
if ~isempty(figs)
    [~, order] = sort(arrayfun(@(f) f.Number, figs));
    figs = figs(order);
end
end

function restoreFigureDefaults(visible, style, position)
set(groot, 'DefaultFigureVisible', visible, 'DefaultFigureWindowStyle', style, ...
    'DefaultFigurePosition', position);
end
