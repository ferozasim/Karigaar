import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/city_model.dart';
import 'package:karigaar_app/core/models/telemetry_model.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/customer/tracking/live_tracking_screen.dart';
import 'package:karigaar_app/features/artisan/active_job/artisan_active_job_screen.dart';

void main() {
  Widget wrapScreen({
    required Widget screen,
    required ProviderContainer container,
  }) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: screen,
      ),
    );
  }

  Future<void> setMobileViewport(WidgetTester tester, {required Size size}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('Ticket T-04: Live Tracking & Telemetry Streaming Widget Tests', () {
    const bookingId = 'BK_NANDED_8821';

    // Test 1: Initial Render & Dynamic ETA
    testWidgets('1. LiveTrackingScreen renders initial telemetry feed with dynamic ETA and artisan metadata', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        wrapScreen(
          screen: const LiveTrackingScreen(bookingId: bookingId),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Live Dispatch Radar'), findsOneWidget);
      expect(find.text('Arriving in ~6 mins (1.8 km)'), findsOneWidget);
      expect(find.text('Your Home'), findsOneWidget);
      expect(find.text('En Route to Doorstep (~6 mins)'), findsOneWidget);
      expect(find.text('Quick Doorstep Directions'), findsOneWidget);
      expect(find.text('Gate code is 8842'), findsOneWidget);
      expect(find.text('Visitor parking spot #4'), findsOneWidget);
      expect(find.text('Ring the doorbell twice'), findsOneWidget);
      expect(find.byKey(const Key('geofence_arrival_banner')), findsNothing);
    });

    // Test 2: Reactive UI updates on stream pings
    testWidgets('2. LiveTrackingScreen reactively updates ETA and distance when new telemetry pings arrive', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final telemetryService = container.read(telemetryServiceProvider);
      // Set customer destination at Anand Nagar
      telemetryService.setCustomerDestination(
        bookingId,
        const GeoPointModel(latitude: 19.1685, longitude: 77.3090),
      );

      await tester.pumpWidget(
        wrapScreen(
          screen: const LiveTrackingScreen(bookingId: bookingId),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Arriving in ~6 mins (1.8 km)'), findsOneWidget);

      // Publish an updated ping closer to customer (speed 30 km/h)
      // Destination: 19.1685, 77.3090. Ping: 19.1630, 77.3090 (~611m haversine -> ~0.79 km road -> ~2 min ETA at 30km/h)
      telemetryService.publishLocationPing(ArtisanLocationPing(
        bookingId: bookingId,
        artisanId: 'art_nanded_01',
        coordinates: const TelemetryCoordinates(latitude: 19.1630, longitude: 77.3090),
        headingDegrees: 45.0,
        speedKmph: 30.0,
        batteryLevelPercent: 86,
        isForeground: true,
        timestamp: DateTime.now(),
      ));

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Verify ETA badge updated dynamically with new values
      expect(find.textContaining('Arriving in ~2 mins'), findsOneWidget);
      expect(find.textContaining('En Route to Doorstep (~2 mins)'), findsOneWidget);
      expect(find.byKey(const Key('geofence_arrival_banner')), findsNothing);
    });

    // Test 3: 200m Geofence Arrival Banner Rendering
    testWidgets('3. LiveTrackingScreen displays prominent 200m Geofence Arrival Alert Banner when artisan is within 200m', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final telemetryService = container.read(telemetryServiceProvider);
      telemetryService.setCustomerDestination(
        bookingId,
        const GeoPointModel(latitude: 19.1685, longitude: 77.3090),
      );

      await tester.pumpWidget(
        wrapScreen(
          screen: const LiveTrackingScreen(bookingId: bookingId),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      // Outside geofence: banner not visible
      expect(find.byKey(const Key('geofence_arrival_banner')), findsNothing);

      // Publish ping within ~110m of customer doorstep
      telemetryService.publishLocationPing(ArtisanLocationPing(
        bookingId: bookingId,
        artisanId: 'art_nanded_01',
        coordinates: const TelemetryCoordinates(latitude: 19.1678, longitude: 77.3094),
        headingDegrees: 45.0,
        speedKmph: 12.0,
        batteryLevelPercent: 84,
        isForeground: true,
        timestamp: DateTime.now(),
      ));

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Prominent arrival alert banner is visible
      expect(find.byKey(const Key('geofence_arrival_banner')), findsOneWidget);
      expect(
        find.text('Karigaar within 200m of doorstep! Ready your Start Code 4921.'),
        findsOneWidget,
      );
      expect(find.text('Arrived at Doorstep (0 km)'), findsOneWidget);
      expect(find.text('Arrived at Doorstep (Within 200m)'), findsOneWidget);
    });

    // Test 4: Geofence banner absent outside 200m
    testWidgets('4. LiveTrackingScreen does NOT render 200m Geofence banner when distance > 200m', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final telemetryService = container.read(telemetryServiceProvider);
      telemetryService.setCustomerDestination(
        bookingId,
        const GeoPointModel(latitude: 19.1685, longitude: 77.3090),
      );

      // Coordinates at Vazirabad (~2040m away)
      telemetryService.publishLocationPing(ArtisanLocationPing(
        bookingId: bookingId,
        artisanId: 'art_nanded_01',
        coordinates: const TelemetryCoordinates(latitude: 19.1530, longitude: 77.3195),
        headingDegrees: 45.0,
        speedKmph: 28.0,
        batteryLevelPercent: 88,
        isForeground: true,
        timestamp: DateTime.now(),
      ));

      await tester.pumpWidget(
        wrapScreen(
          screen: const LiveTrackingScreen(bookingId: bookingId),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('geofence_arrival_banner')), findsNothing);
    });

    // Test 5: Narrow 360x800 Viewport Layout under AppTheme.lightTheme
    testWidgets('5. LiveTrackingScreen survives narrow 360x800 viewport without layout overflow under AppTheme.lightTheme', (tester) async {
      await setMobileViewport(tester, size: const Size(360, 800));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        wrapScreen(
          screen: const LiveTrackingScreen(bookingId: bookingId),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Live Dispatch Radar'), findsOneWidget);
      expect(find.text('DOORSTEP SECURITY START CODE'), findsOneWidget);
      expect(find.text('4921'), findsOneWidget);
    });

    // Test 6: Ultra-Compact 320x568 Viewport Layout under AppTheme.lightTheme
    testWidgets('6. LiveTrackingScreen survives ultra-compact 320x568 viewport without layout overflow under AppTheme.lightTheme', (tester) async {
      await setMobileViewport(tester, size: const Size(320, 568));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        wrapScreen(
          screen: const LiveTrackingScreen(bookingId: bookingId),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Live Dispatch Radar'), findsOneWidget);
    });

    // Test 7: Artisan Active Job Screen En-Route Telemetry HUD
    testWidgets('7. ArtisanActiveJobScreen renders en-route telemetry HUD with GPS streaming metrics', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        wrapScreen(
          screen: const ArtisanActiveJobScreen(bookingId: bookingId),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byKey(const Key('enroute_telemetry_hud')), findsOneWidget);
      expect(find.text('LIVE GPS TELEMETRY STREAMING (CONTRACT 3)'), findsOneWidget);
      expect(find.text('Speed'), findsOneWidget);
      expect(find.text('Heading'), findsOneWidget);
      expect(find.text('Battery'), findsOneWidget);
      expect(find.text('Remaining'), findsOneWidget);
    });

    // Test 8: Foreground vs. Background Telemetry Mode Switcher
    testWidgets('8. ArtisanActiveJobScreen switches between Foreground (3s) and Background (15s) streaming modes', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        wrapScreen(
          screen: const ArtisanActiveJobScreen(bookingId: bookingId),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Streaming Mode: High-Accuracy Foreground'), findsOneWidget);
      expect(find.text('Foreground (3s)'), findsOneWidget);

      final toggle = find.byKey(const Key('telemetry_streaming_mode_toggle'));
      expect(toggle, findsOneWidget);

      // Tap toggle to switch to background mode
      await tester.tap(toggle);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Streaming Mode: Battery-Saver Background'), findsOneWidget);
      expect(find.text('Background (15s)'), findsOneWidget);

      // Tap toggle again to return to foreground mode
      await tester.tap(toggle);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Streaming Mode: High-Accuracy Foreground'), findsOneWidget);
      expect(find.text('Foreground (3s)'), findsOneWidget);
    });
  });
}
