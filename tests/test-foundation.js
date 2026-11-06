const fs = require('fs');
const path = require('path');
const assert = require('assert');

console.log('\n=======================================================');
console.log('   KARIGAAR WORKSPACE FOUNDATION DEEP TEST SUITE       ');
console.log('=======================================================\n');

let passCount = 0;
let failCount = 0;

function runTest(name, fn) {
  try {
    fn();
    console.log(`[PASS] ${name}`);
    passCount++;
  } catch (err) {
    console.error(`[FAIL] ${name}: ${err.message}`);
    failCount++;
  }
}

const rootDir = path.resolve(__dirname, '..');

// Test 1: Pilot City Nanded Configuration & Locality Pincode Integrity
runTest('Pilot City Nanded configuration file exists, is valid, and covers all locality pincodes', () => {
  const filePath = path.join(rootDir, 'config', 'pilot_city_nanded.json');
  assert.ok(fs.existsSync(filePath), 'pilot_city_nanded.json must exist');
  const content = JSON.parse(fs.readFileSync(filePath, 'utf8'));

  assert.strictEqual(content.cityId, 'city_nanded_01');
  assert.strictEqual(content.name, 'Nanded');
  assert.strictEqual(content.state, 'Maharashtra');
  assert.strictEqual(content.centerCoordinates.latitude, 19.1383);
  assert.strictEqual(content.centerCoordinates.longitude, 77.3210);
  assert.strictEqual(content.emergencyDispatchWindowMins, 25);
  assert.strictEqual(content.defaultDispatchRadiusKm, 4.5);
  assert.ok(Array.isArray(content.pincodeRange), 'pincodeRange must be an array');
  assert.ok(content.pincodeRange.includes('431601'));
  assert.ok(content.pincodeRange.includes('431606'), 'pincodeRange must include 431606 for Vishnupuri locality');
  assert.ok(Array.isArray(content.localities) && content.localities.length >= 10, 'Must have at least 10 localities in Nanded');
  
  // Every locality must have valid structure and its pincode must be in pincodeRange
  for (const loc of content.localities) {
    assert.ok(loc.localityId, `Locality must have an ID: ${loc.name}`);
    assert.ok(loc.name, `Locality ${loc.localityId} must have a name`);
    assert.ok(loc.marathiName, `Locality ${loc.name} must have a marathiName`);
    assert.ok(loc.pincode, `Locality ${loc.name} must have a pincode`);
    assert.ok(
      content.pincodeRange.includes(loc.pincode),
      `Locality '${loc.name}' pincode '${loc.pincode}' must be present in city.pincodeRange`
    );
    assert.ok(typeof loc.emergencyHub === 'boolean', `Locality ${loc.name} must specify emergencyHub boolean`);
    assert.ok(loc.center && loc.center.latitude > 19.0 && loc.center.latitude < 19.3, `Locality ${loc.name} lat in Nanded bounds`);
    assert.ok(loc.center && loc.center.longitude > 77.1 && loc.center.longitude < 77.5, `Locality ${loc.name} lng in Nanded bounds`);
  }

  const anandNagar = content.localities.find(l => l.localityId === 'loc_anand_nagar');
  assert.ok(anandNagar, 'Anand Nagar locality must exist');
  assert.strictEqual(anandNagar.emergencyHub, true);
});

// Test 2: 10 Launch Trades Configuration
runTest('10 Launch Trades configuration contains all required trades, pricing, and safety shield fees', () => {
  const filePath = path.join(rootDir, 'config', 'launch_trades.json');
  assert.ok(fs.existsSync(filePath), 'launch_trades.json must exist');
  const content = JSON.parse(fs.readFileSync(filePath, 'utf8'));

  assert.ok(Array.isArray(content.trades), 'trades must be an array');
  assert.strictEqual(content.trades.length, 10, 'Must have exactly 10 Launch Trades');

  const expectedTrades = [
    'electrician',
    'plumber',
    'carpenter',
    'mason-civil-worker',
    'painter',
    'ac-refrigeration',
    'appliance-repair',
    'welder-fabricator',
    'pest-control',
    'deep-cleaning'
  ];

  for (const slug of expectedTrades) {
    const trade = content.trades.find(t => t.slug === slug);
    assert.ok(trade, `Trade '${slug}' must exist in launch_trades.json`);
    assert.ok(trade.tradeId, `Trade '${slug}' must have a tradeId`);
    assert.ok(trade.marathiName, `Trade '${slug}' must have a marathiName for Maharashtra`);
    assert.strictEqual(trade.safetyShieldFee, 29, `Trade '${slug}' must have ₹29 safety shield fee`);
    assert.ok(trade.guaranteeDays >= 30, `Trade '${slug}' must have >= 30 days guarantee`);
    assert.ok(trade.baseInspectionFee > 0, `Trade '${slug}' baseInspectionFee must be > 0`);
    assert.ok(Array.isArray(trade.popularPackages), `Trade '${slug}' must have popularPackages array`);
  }
});

// Test 3: Design System Tokens
runTest('Design system tokens match DESIGN.md specifications', () => {
  const filePath = path.join(rootDir, 'config', 'design_tokens.json');
  assert.ok(fs.existsSync(filePath), 'design_tokens.json must exist');
  const content = JSON.parse(fs.readFileSync(filePath, 'utf8'));

  assert.strictEqual(content.colors.primary.main, '#0F172A');
  assert.strictEqual(content.colors.secondary.main, '#D97706');
  assert.strictEqual(content.colors.tertiary.main, '#059669');
  assert.strictEqual(content.colors.neutral.surfaceBase, '#F8FAFC');
  assert.strictEqual(content.typography.fontFamilyHeading, 'Plus Jakarta Sans');
  assert.strictEqual(content.typography.fontFamilyBody, 'Inter');
});

// Test 4: Firebase Configuration
runTest('Firebase configuration is bound to karigaar-ba812 and rules exist', () => {
  const rcPath = path.join(rootDir, '.firebaserc');
  assert.ok(fs.existsSync(rcPath), '.firebaserc must exist');
  const rc = JSON.parse(fs.readFileSync(rcPath, 'utf8'));
  assert.strictEqual(rc.projects.default, 'karigaar-ba812');

  const jsonPath = path.join(rootDir, 'firebase.json');
  assert.ok(fs.existsSync(jsonPath), 'firebase.json must exist');
  const fbJson = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
  assert.strictEqual(fbJson.firestore.rules, 'firestore.rules');
  assert.strictEqual(fbJson.storage.rules, 'storage.rules');

  const rulesContent = fs.readFileSync(path.join(rootDir, 'firestore.rules'), 'utf8');
  assert.ok(rulesContent.includes("rules_version = '2';"));
  assert.ok(rulesContent.includes('/bookings/{bookingId}'));
  assert.ok(rulesContent.includes('/artisans/{artisanId}'));
});

// Test 5: Automation Scripts
runTest('Automated installation and setup scripts exist and are well-formed', () => {
  const scripts = [
    'scripts/verify-env.ps1',
    'scripts/setup-environment.ps1',
    'scripts/install-flutter.ps1',
    'scripts/install-android-sdk.ps1',
    'scripts/install-java.ps1',
    'scripts/install-android-studio.ps1',
    'scripts/setup-workspace.bat'
  ];

  for (const s of scripts) {
    const fullPath = path.join(rootDir, s);
    assert.ok(fs.existsSync(fullPath), `${s} must exist`);
    const content = fs.readFileSync(fullPath, 'utf8');
    assert.ok(content.length > 50, `${s} must not be empty`);
  }

  // Ensure install-android-sdk.ps1 resolves JAVA_HOME
  const androidScriptContent = fs.readFileSync(path.join(rootDir, 'scripts/install-android-sdk.ps1'), 'utf8');
  assert.ok(androidScriptContent.includes('JAVA_HOME'), 'install-android-sdk.ps1 must resolve JAVA_HOME');
  
  // Ensure install-flutter.ps1 uses shallow clone
  const flutterScriptContent = fs.readFileSync(path.join(rootDir, 'scripts/install-flutter.ps1'), 'utf8');
  assert.ok(flutterScriptContent.includes('--depth 1'), 'install-flutter.ps1 must use shallow clone for fast downloads');
});

// Test 6: Flutter Mobile App & Multiplatform Harnesses (Android, iOS, Web)
runTest('Flutter mobile app structure, dependencies, and cross-platform Android/iOS harnesses are in place', () => {
  const pubspecPath = path.join(rootDir, 'apps', 'mobile_app', 'pubspec.yaml');
  assert.ok(fs.existsSync(pubspecPath), 'pubspec.yaml must exist');
  const pubspec = fs.readFileSync(pubspecPath, 'utf8');
  assert.ok(pubspec.includes('flutter_riverpod'));
  assert.ok(pubspec.includes('go_router'));
  assert.ok(pubspec.includes('google_fonts'));

  const requiredCoreFiles = [
    'apps/mobile_app/lib/main.dart',
    'apps/mobile_app/lib/core/theme/app_colors.dart',
    'apps/mobile_app/lib/core/theme/app_typography.dart',
    'apps/mobile_app/lib/core/theme/app_theme.dart',
    'apps/mobile_app/lib/core/models/user_role.dart',
    'apps/mobile_app/lib/core/models/booking_model.dart',
    'apps/mobile_app/lib/core/models/trade_model.dart',
    'apps/mobile_app/lib/core/models/city_model.dart',
    'apps/mobile_app/lib/core/router/app_router.dart',
    'apps/mobile_app/lib/features/auth/login_screen.dart',
    'apps/mobile_app/lib/features/auth/otp_verification_screen.dart',
    'apps/mobile_app/lib/features/customer/home/customer_home_screen.dart',
    'apps/mobile_app/lib/features/customer/scoping/service_scoping_screen.dart',
    'apps/mobile_app/lib/features/customer/tracking/live_tracking_screen.dart',
    'apps/mobile_app/lib/features/artisan/radar/artisan_job_radar_screen.dart',
    'apps/mobile_app/lib/features/artisan/active_job/artisan_active_job_screen.dart',
  ];

  for (const f of requiredCoreFiles) {
    assert.ok(fs.existsSync(path.join(rootDir, f)), `${f} must exist`);
  }

  // Cross-Platform Native Harness Validation (Android + iOS + Web)
  const requiredPlatformFiles = [
    'apps/mobile_app/android/build.gradle',
    'apps/mobile_app/android/settings.gradle',
    'apps/mobile_app/android/gradle.properties',
    'apps/mobile_app/android/app/build.gradle',
    'apps/mobile_app/android/app/src/main/AndroidManifest.xml',
    'apps/mobile_app/android/app/src/main/kotlin/in/karigaar/app/MainActivity.kt',
    'apps/mobile_app/ios/Podfile',
    'apps/mobile_app/ios/Runner/Info.plist',
    'apps/mobile_app/ios/Runner/AppDelegate.swift',
    'apps/mobile_app/web/index.html',
    'apps/mobile_app/web/manifest.json'
  ];

  for (const pf of requiredPlatformFiles) {
    assert.ok(fs.existsSync(path.join(rootDir, pf)), `Platform harness file ${pf} must exist`);
  }

  // Android Manifest permissions check
  const manifest = fs.readFileSync(path.join(rootDir, 'apps/mobile_app/android/app/src/main/AndroidManifest.xml'), 'utf8');
  assert.ok(manifest.includes('android.permission.ACCESS_FINE_LOCATION'), 'Manifest must require ACCESS_FINE_LOCATION');
  assert.ok(manifest.includes('android.permission.RECORD_AUDIO'), 'Manifest must require RECORD_AUDIO');
  assert.ok(manifest.includes('android.permission.CAMERA'), 'Manifest must require CAMERA');

  // iOS Info.plist descriptions check
  const plist = fs.readFileSync(path.join(rootDir, 'apps/mobile_app/ios/Runner/Info.plist'), 'utf8');
  assert.ok(plist.includes('NSLocationWhenInUseUsageDescription'), 'Info.plist must define NSLocationWhenInUseUsageDescription');
  assert.ok(plist.includes('NSMicrophoneUsageDescription'), 'Info.plist must define NSMicrophoneUsageDescription');
  assert.ok(plist.includes('NSCameraUsageDescription'), 'Info.plist must define NSCameraUsageDescription');
});

// Test 7: Admin Web Portal & Static Build
runTest('Admin Web portal Next.js structure and production export are in place', () => {
  const pkgPath = path.join(rootDir, 'apps', 'admin_web', 'package.json');
  assert.ok(fs.existsSync(pkgPath), 'apps/admin_web/package.json must exist');
  const pagePath = path.join(rootDir, 'apps', 'admin_web', 'src', 'app', 'page.tsx');
  assert.ok(fs.existsSync(pagePath), 'apps/admin_web/src/app/page.tsx must exist');
  const pageContent = fs.readFileSync(pagePath, 'utf8');
  assert.ok(pageContent.includes('HQ Ops Stream'));
  assert.ok(pageContent.includes('Nanded Surge Corridors'));
  assert.ok(pageContent.includes('Priority Guild Verification Queue'));

  // Static export check
  const outIndexPath = path.join(rootDir, 'apps', 'admin_web', 'out', 'index.html');
  assert.ok(fs.existsSync(outIndexPath), 'apps/admin_web/out/index.html must exist from production build');
});

// Test 8: Data Config Synchronization between root and mobile app
runTest('Root config and mobile app bundled assets are perfectly synchronized', () => {
  const pairs = [
    ['config/pilot_city_nanded.json', 'apps/mobile_app/assets/data/pilot_city_nanded.json'],
    ['config/launch_trades.json', 'apps/mobile_app/assets/data/launch_trades.json'],
    ['config/design_tokens.json', 'apps/mobile_app/assets/data/design_tokens.json']
  ];

  for (const [rootRel, mobileRel] of pairs) {
    const rootPath = path.join(rootDir, rootRel);
    const mobilePath = path.join(rootDir, mobileRel);
    assert.ok(fs.existsSync(rootPath), `${rootRel} must exist`);
    assert.ok(fs.existsSync(mobilePath), `${mobileRel} must exist`);

    const rootContent = fs.readFileSync(rootPath, 'utf8');
    const mobileContent = fs.readFileSync(mobilePath, 'utf8');
    assert.strictEqual(
      JSON.stringify(JSON.parse(rootContent)),
      JSON.stringify(JSON.parse(mobileContent)),
      `${rootRel} and ${mobileRel} JSON contents must be identical`
    );
  }
});

console.log('\n-------------------------------------------------------');
console.log(`SUMMARY: ${passCount} PASSED, ${failCount} FAILED`);
console.log('-------------------------------------------------------\n');

if (failCount > 0) {
  process.exit(1);
}
