"""Настраивает сгенерированный Android-проект: название, озвучка (TTS), MainActivity."""
import pathlib
import re

ROOT = pathlib.Path("android/app")
TOOLS = pathlib.Path("tools/android")

m = ROOT / "src/main/AndroidManifest.xml"
t = m.read_text(encoding="utf-8")
t = re.sub(r'android:label="[^"]*"', 'android:label="Winter Language"', t, count=1)
tts = '        <intent>\n            <action android:name="android.intent.action.TTS_SERVICE"/>\n        </intent>\n'
if "android.intent.action.TTS_SERVICE" not in t:
    if "<queries>" in t:
        t = t.replace("<queries>\n", "<queries>\n" + tts, 1)
    else:
        t = t.replace("</manifest>", "    <queries>\n" + tts + "    </queries>\n</manifest>", 1)
m.write_text(t, encoding="utf-8")

kotlin = ROOT / "src/main/kotlin/com/winterhub/winter_language"
kotlin.mkdir(parents=True, exist_ok=True)
for old in ROOT.glob("src/main/kotlin/**/MainActivity.kt"):
    old.unlink()
(kotlin / "MainActivity.kt").write_text((TOOLS / "MainActivity.kt").read_text(encoding="utf-8"), encoding="utf-8")
if "TTS_SERVICE" not in m.read_text(encoding="utf-8"):
    raise SystemExit("PATCH ERROR: manifest")
print("patched")
