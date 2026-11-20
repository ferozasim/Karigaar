import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/user_role.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/auth/login_screen.dart';
import 'package:karigaar_app/l10n/app_localizations.dart';

void main() {
  Widget loginIn(Locale locale, UserRole role) => ProviderScope(
        overrides: [userRoleProvider.overrideWith((ref) => role)],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const LoginScreen(),
        ),
      );

  testWidgets('Hindi homeowner entry and validation follow the app locale',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(loginIn(const Locale('hi'), UserRole.customer));
    await tester.pumpAndSettle();
    expect(find.text('घर के मालिक के रूप में लॉग इन करें'), findsOneWidget);
    expect(find.text('SMS से OTP प्राप्त करें'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '12');
    await tester.tap(find.text('WhatsApp से आगे बढ़ें'));
    await tester.pump();
    expect(find.text('कृपया सही 10 अंकों का मोबाइल नंबर दर्ज करें'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Marathi artisan entry follows the app locale', (tester) async {
    await tester.pumpWidget(loginIn(const Locale('mr'), UserRole.artisan));
    await tester.pumpAndSettle();
    expect(find.text('कारागीर गिल्ड पोर्टल'), findsOneWidget);
    expect(find.text('नवीन कारागीर? नांदेड गिल्डमध्ये सामील व्हा (0% शुल्क)'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
