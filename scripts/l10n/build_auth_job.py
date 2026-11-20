import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "scripts" / "l10n" / "auth_partner_translations.tsv"
ARB_DIR = ROOT / "apps" / "mobile_app" / "lib" / "l10n"

translations = {"en": {}, "hi": {}, "mr": {}}
group = "auth"
for line in ROWS.read_text(encoding="utf-8").splitlines():
    parts = line.split("|")
    if len(parts) != 4:
        raise ValueError(f"Expected four fields in translation row: {line!r}")
    key, en, hi, mr = parts
    if key == "InvalidStart":
        group = "job"
    arb_key = group + key
    for language, value in zip(("en", "hi", "mr"), (en, hi, mr)):
        translations[language][arb_key] = value.replace(r"\n", "\n")

translations["en"].update({
    "localitySelect": "Select Locality",
    "localityPilotDistrict": "Pilot City: Nanded-Waghala (Maharashtra)",
    "localityDistrict": "District: {district}",
    "localitySearchHint": "Search locality or PIN code",
    "localityEmptyText": "No locality found in {city}",
    "localityChanged": "Switched service hub to {name} ({pincode})",
    "emergencyTitle": "URGENT BREAKDOWN? (25 MINS)",
    "emergencyDispatch": "Immediate Doorstep Dispatch",
    "emergencyCoverage": "Electricians & Plumbers on stand-by across Nanded",
    "emergencyBookFast": "Book Fast",
    "skeletonTradesHeading": "CERTIFIED GUILD TRADES",
})
translations["hi"].update({
    "localitySelect": "इलाका चुनें",
    "localityPilotDistrict": "पायलट शहर: नांदेड़-वाघाला (महाराष्ट्र)",
    "localityDistrict": "ज़िला: {district}",
    "localitySearchHint": "इलाका या PIN कोड खोजें",
    "localityEmptyText": "{city} में कोई इलाका नहीं मिला",
    "localityChanged": "सेवा केंद्र {name} ({pincode}) पर बदल गया",
    "emergencyTitle": "ज़रूरी मरम्मत? (25 मिनट)",
    "emergencyDispatch": "तुरंत दरवाज़े तक सेवा",
    "emergencyCoverage": "नांदेड़ में इलेक्ट्रीशियन और प्लंबर तैयार हैं",
    "emergencyBookFast": "जल्दी बुक करें",
    "skeletonTradesHeading": "प्रमाणित गिल्ड सेवाएँ",
})
translations["mr"].update({
    "localitySelect": "परिसर निवडा",
    "localityPilotDistrict": "पायलट शहर: नांदेड-वाघाळा (महाराष्ट्र)",
    "localityDistrict": "जिल्हा: {district}",
    "localitySearchHint": "परिसर किंवा PIN कोड शोधा",
    "localityEmptyText": "{city} मध्ये परिसर सापडला नाही",
    "localityChanged": "सेवा केंद्र {name} ({pincode}) येथे बदलले",
    "emergencyTitle": "तातडीची दुरुस्ती? (२५ मिनिटे)",
    "emergencyDispatch": "तात्काळ घरपोच सेवा",
    "emergencyCoverage": "नांदेडमध्ये इलेक्ट्रीशियन आणि प्लंबर तयार आहेत",
    "emergencyBookFast": "लवकर बुक करा",
    "skeletonTradesHeading": "प्रमाणित गिल्ड सेवा",
})

for language, entries in translations.items():
    for resource_name in (
        f"catalog_{language}.json",
        f"booking_flow_{language}.json",
        f"customer_account_{language}.json",
    ):
        resource_path = ROWS.parent / resource_name
        if resource_path.exists():
            entries.update(json.loads(resource_path.read_text(encoding="utf-8")))
    path = ARB_DIR / f"app_{language}.arb"
    document = json.loads(path.read_text(encoding="utf-8"))
    conflicts = {
        key for key, value in entries.items()
        if key in document and document[key] != value
    }
    if conflicts:
        raise ValueError(f"Conflicting localization keys in {path.name}: {sorted(conflicts)}")
    document.update(entries)
    document.update({
        "@localityDistrict": {"placeholders": {"district": {"type": "String"}}},
        "@localityEmptyText": {"placeholders": {"city": {"type": "String"}}},
        "@localityChanged": {"placeholders": {
            "name": {"type": "String"},
            "pincode": {"type": "String"},
        }},
    })
    path.write_text(json.dumps(document, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
