"""Validate actual MATLAB outputs; never render or synthesize plots."""
import hashlib
import json
import os
from pathlib import Path
import struct
import sys
import zipfile

root = Path(__file__).resolve().parents[1]
diagnostics = root / "ci-diagnostics"
diagnostics.mkdir(exist_ok=True)
issues = []
manifests = sorted((root / "output").glob("*/manifest.json"))
if len(manifests) != 1:
    issues.append(f"Expected one completed manifest, found {len(manifests)}")
summary = {"validation": "failed", "issues": issues}

if len(manifests) == 1:
    manifest_path = manifests[0]
    run_dir = manifest_path.parent
    data = json.loads(manifest_path.read_text(encoding="utf-8"))
    expected = [f"task6_1_{i:02d}" for i in range(1, 27)] + ["task6_2_01", "task6_2_02"]
    results = data.get("results", [])
    if [item["example"] for item in results] != expected:
        issues.append("Example inventory differs from expected 28 examples")
    if not data.get("complete") or data.get("succeeded") != 28 or data.get("failed") != 0:
        issues.append("MATLAB did not report 28/28 successes")
    screenshots = sorted((run_dir / "images").glob("*.png"))
    if {p.stem for p in screenshots} != set(expected):
        issues.append("Missing or unexpected screenshot names")
    frames = sorted((run_dir / "animation_frames").glob("*.png"))
    if len(frames) != 36:
        issues.append(f"Expected 36 original animation frames, found {len(frames)}")
    image_info = []
    for path in screenshots + frames:
        raw = path.read_bytes()
        if raw[:8] != b"\x89PNG\r\n\x1a\n" or len(raw) < 24:
            issues.append(f"Not a PNG: {path.name}")
            continue
        width, height = struct.unpack(">II", raw[16:24])
        if width < 200 or height < 200:
            issues.append(f"Suspicious image dimensions: {path.name}: {width}x{height}")
        image_info.append({"file": str(path.relative_to(run_dir)), "width": width,
                           "height": height, "sha256": hashlib.sha256(raw).hexdigest()})
    for line in (root / "SOURCE_SHA256.txt").read_text().splitlines():
        expected_hash, relative = line.split("  ", 1)
        actual_hash = hashlib.sha256((run_dir / relative).read_bytes()).hexdigest()
        if actual_hash != expected_hash:
            issues.append(f"Copied source changed: {relative}")
    zip_path = Path(str(run_dir) + ".zip")
    if not zip_path.is_file():
        issues.append("Result ZIP is missing")
    else:
        with zipfile.ZipFile(zip_path) as archive:
            if archive.testzip():
                issues.append("ZIP CRC check failed")
            if len([n for n in archive.namelist() if n.startswith("images/") and n.endswith(".png")]) != 28:
                issues.append("ZIP does not contain 28 main screenshots")
    summary.update({"matlab_version": data.get("version"), "main_screenshots": len(screenshots),
                    "animation_frames": len(frames), "images": image_info})

summary["validation"] = "passed" if not issues else "failed"
(diagnostics / "validation.json").write_text(json.dumps(summary, indent=2) + "\n")
message = f"Output validation: {summary['validation']}\n"
if "main_screenshots" in summary:
    message += f"Main screenshots: {summary['main_screenshots']}/28; animation frames: {summary['animation_frames']}/36.\n"
message += "\n".join(f"- {issue}" for issue in issues) + "\n"
print(message)
if os.environ.get("GITHUB_STEP_SUMMARY"):
    with open(os.environ["GITHUB_STEP_SUMMARY"], "a") as stream:
        stream.write(message)
sys.exit(1 if issues else 0)
