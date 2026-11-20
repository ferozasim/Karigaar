import re
import sys
sys.stdout.reconfigure(encoding='utf-8')
from pathlib import Path
files = [Path('apps/mobile_app/lib/features/auth/otp_verification_screen.dart'), Path('apps/mobile_app/lib/features/auth/artisan_registration_screen.dart'), *Path('apps/mobile_app/lib/features/artisan').rglob('*.dart')]
for p in files:
    print('\nFILE',p)
    for i,line in enumerate(p.read_text(encoding='utf-8').splitlines(),1):
        if line.lstrip().startswith('//') or line.startswith('import'): continue
        for m in re.finditer(r"'(?:\\.|[^'\\])*'",line):
            v=m.group(0)[1:-1]
            if re.search(r'[A-Za-z]{2}',v) and not re.match(r'^[a-zA-Z0-9_./]+$',v):
                print(i, v)
