import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final savedLanguage = preferences.getString('app_language_code');
  final initialLanguage =
      const {'en', 'hi', 'mr'}.contains(savedLanguage) ? savedLanguage! : 'en';
  runApp(
    ProviderScope(
      overrides: [
        partnerLanguageProvider.overrideWith((ref) => initialLanguage),
      ],
      child: const KarigaarApp(),
    ),
  );
}

class KarigaarApp extends ConsumerWidget {
  const KarigaarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Starts the repository mirror while retaining offline-first startup.
    ref.watch(activeBookingRepositoryMirrorProvider);
    ref.listen(partnerLanguageProvider, (previous, next) {
      if (previous != next && const {'en', 'hi', 'mr'}.contains(next)) {
        SharedPreferences.getInstance().then(
          (preferences) => preferences.setString('app_language_code', next),
        );
      }
    });
    final locale = ref.watch(appLocaleProvider);
    return MaterialApp.router(
      title: 'Karigaar - Master Guildsman Meets Modern Concierge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: appRouter,
    );
  }
}
