import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_verification_screen.dart';
import '../../features/customer/home/customer_home_screen.dart';
import '../../features/customer/scoping/service_scoping_screen.dart';
import '../../features/customer/tracking/live_tracking_screen.dart';
import '../../features/artisan/radar/artisan_job_radar_screen.dart';
import '../../features/artisan/active_job/artisan_active_job_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp-verify',
      builder: (context, state) {
        final phone = state.extra as String? ?? '9822199882';
        return OtpVerificationScreen(phone: phone);
      },
    ),
    GoRoute(
      path: '/customer/home',
      builder: (context, state) => const CustomerHomeScreen(),
    ),
    GoRoute(
      path: '/customer/service/:tradeId',
      builder: (context, state) {
        final tradeId = state.pathParameters['tradeId'] ?? 'trade_electrician';
        return ServiceScopingScreen(tradeId: tradeId);
      },
    ),
    GoRoute(
      path: '/customer/active-tracking/:bookingId',
      builder: (context, state) {
        final bookingId = state.pathParameters['bookingId'] ?? 'BK_NANDED_8821';
        return LiveTrackingScreen(bookingId: bookingId);
      },
    ),
    GoRoute(
      path: '/artisan/radar',
      builder: (context, state) => const ArtisanJobRadarScreen(),
    ),
    GoRoute(
      path: '/artisan/active-job/:bookingId',
      builder: (context, state) {
        final bookingId = state.pathParameters['bookingId'] ?? 'BK_NANDED_8821';
        return ArtisanActiveJobScreen(bookingId: bookingId);
      },
    ),
  ],
);
