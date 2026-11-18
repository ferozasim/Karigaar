import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: KarigaarApp(),
    ),
  );
}

class KarigaarApp extends ConsumerWidget {
  const KarigaarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Starts the repository mirror while retaining offline-first startup.
    ref.watch(activeBookingRepositoryMirrorProvider);
    return MaterialApp.router(
      title: 'Karigaar - Master Guildsman Meets Modern Concierge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
