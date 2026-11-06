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

// Test 1: Pilot City Nanded Configuration
runTest('Pilot City Nanded configuration file exists and is valid', () => {
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
  assert.ok(Array.isArray(content.pincodeRange) && content.pincodeRange.includes('431601'));
  assert.ok(Array.isArray(content.localities) && content.localities.length >= 10, 'Must have at least 10 localities in Nanded');
  
  const anandNagar = content.localities.find(l => l.localityId === 'loc_anand_nagar');
  assert.ok(anandNagar, 'Anand Nagar locality must exist');
  assert.strictEqual(anandNagar.emergencyHub, true);
});

// Test 2: 10 Launch Trades Configuration
runTest('10 Launch Trades configuration contains all required trades and pricing models', () => {
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
  assert.ok(rulesContent.includes('rules_version = \'2\';'));
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
    'scripts/setup-workspace.bat'
  ];

  for (const s of scripts) {
    const fullPath = path.join(rootDir, s);
    assert.ok(fs.existsSync(fullPath), `${s} must exist`);
    const content = fs.readFileSync(fullPath, 'utf8');
    assert.ok(content.length > 50, `${s} must not be empty`);
  }
});

// Test 6: Flutter Mobile App
runTest('Flutter mobile app structure, dependencies, and core screens are in place', () => {
  const pubspecPath = path.join(rootDir, 'apps', 'mobile_app', 'pubspec.yaml');
  assert.ok(fs.existsSync(pubspecPath), 'pubspec.yaml must exist');
  const pubspec = fs.readFileSync(pubspecPath, 'utf8');
  assert.ok(pubspec.includes('flutter_riverpod'));
  assert.ok(pubspec.includes('go_router'));
  assert.ok(pubspec.includes('google_fonts'));

  const requiredFiles = [
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

  for (const f of requiredFiles) {
    assert.ok(fs.existsSync(path.join(rootDir, f)), `${f} must exist`);
  }
});

// Test 7: Admin Web Portal
runTest('Admin Web portal Next.js structure and dashboard are in place', () => {
  const pkgPath = path.join(rootDir, 'apps', 'admin_web', 'package.json');
  assert.ok(fs.existsSync(pkgPath), 'apps/admin_web/package.json must exist');
  const pagePath = path.join(rootDir, 'apps', 'admin_web', 'src', 'app', 'page.tsx');
  assert.ok(fs.existsSync(pagePath), 'apps/admin_web/src/app/page.tsx must exist');
  const pageContent = fs.readFileSync(pagePath, 'utf8');
  assert.ok(pageContent.includes('HQ Ops Stream'));
  assert.ok(pageContent.includes('Nanded Surge Corridors'));
  assert.ok(pageContent.includes('Priority Guild Verification Queue'));
});

console.log('\n-------------------------------------------------------');
console.log(`SUMMARY: ${passCount} PASSED, ${failCount} FAILED`);
console.log('-------------------------------------------------------\n');

if (failCount > 0) {
  process.exit(1);
}
