import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:karigaar_app/core/models/arrival_slot_model.dart';
import 'package:karigaar_app/core/models/audio_memo_model.dart';
import 'package:karigaar_app/core/models/booking_model.dart';
import 'package:karigaar_app/core/providers/app_providers.dart';
import 'package:karigaar_app/core/services/audio_service.dart';
import 'package:karigaar_app/core/theme/app_theme.dart';
import 'package:karigaar_app/features/customer/scoping/widgets/audio_memo_recorder_widget.dart';
import 'package:karigaar_app/features/customer/scoping/widgets/arrival_slot_picker_widget.dart';
import 'package:karigaar_app/features/customer/scoping/service_scoping_screen.dart';
import 'package:karigaar_app/features/artisan/radar/artisan_job_radar_screen.dart';
import 'package:karigaar_app/features/customer/bookings/customer_bookings_screen.dart';

void main() {
  Widget buildApp(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: child,
      ),
    );
  }

  group('Ticket T-08 Widget Tests: 15s Audio Memo & Scheduled Arrival Slot Picker', () {
    testWidgets('1. AudioMemoRecorderWidget renders in idle state with CTA', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final service = KarigaarAudioService();
      addTearDown(() => service.dispose());

      await tester.pumpWidget(buildApp(
        Scaffold(
          body: AudioMemoRecorderWidget(audioService: service),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('15s Audio Memo Scoping'), findsOneWidget);
      expect(find.byKey(const Key('start_recording_button')), findsOneWidget);
      expect(find.text('Record 15s Audio Memo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('2. AudioMemoRecorderWidget start & stop recording lifecycle', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final service = KarigaarAudioService();
      addTearDown(() => service.dispose());

      AudioMemoModel? capturedMemo;

      await tester.pumpWidget(buildApp(
        Scaffold(
          body: AudioMemoRecorderWidget(
            audioService: service,
            onMemoChanged: (memo) => capturedMemo = memo,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Tap start recording
      await tester.tap(find.byKey(const Key('start_recording_button')));
      await tester.pump();

      expect(service.state, AudioRecordingState.recording);
      expect(find.byKey(const Key('stop_recording_button')), findsOneWidget);

      // Tap stop recording
      await tester.tap(find.byKey(const Key('stop_recording_button')));
      await tester.pumpAndSettle();

      expect(service.state, AudioRecordingState.stopped);
      expect(find.byKey(const Key('play_preview_button')), findsOneWidget);
      expect(find.byKey(const Key('rerecord_button')), findsOneWidget);
      expect(find.byKey(const Key('delete_memo_button')), findsOneWidget);
      expect(capturedMemo, isNotNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('3. AudioMemoRecorderWidget preview playback play and pause', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final service = KarigaarAudioService();
      addTearDown(() => service.dispose());

      await service.startRecording(seed: 42);
      await service.stopRecording();

      await tester.pumpWidget(buildApp(
        Scaffold(
          body: AudioMemoRecorderWidget(audioService: service),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Play Preview'), findsOneWidget);

      // Tap play
      await tester.tap(find.byKey(const Key('play_preview_button')));
      await tester.pump();

      expect(service.state, AudioRecordingState.playing);
      expect(find.text('Pause'), findsOneWidget);

      // Tap pause
      await tester.tap(find.byKey(const Key('play_preview_button')));
      await tester.pump();

      expect(service.state, AudioRecordingState.paused);
      expect(tester.takeException(), isNull);
    });

    testWidgets('4. ArrivalSlotPickerWidget renders 7-day carousel and slots', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final fakeTime = DateTime(2026, 11, 14, 10, 0); // 10:00 AM

      await tester.pumpWidget(buildApp(
        Scaffold(
          body: ArrivalSlotPickerWidget(currentTime: fakeTime),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Select Arrival Date & Slot'), findsOneWidget);
      expect(find.text('7-Day Window'), findsOneWidget);
      expect(find.text('TODAY'), findsOneWidget);

      // 4 slot categories
      expect(find.byKey(const Key('slot_card_slot_emergency')), findsOneWidget);
      expect(find.byKey(const Key('slot_card_slot_morning')), findsOneWidget);
      expect(find.byKey(const Key('slot_card_slot_afternoon')), findsOneWidget);
      expect(find.byKey(const Key('slot_card_slot_evening')), findsOneWidget);

      // Morning should be closed at 10 AM on today
      expect(find.text('Closed for Today'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('5. ArrivalSlotPickerWidget date selection updates available slots', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final today = DateTime(2026, 11, 14, 10, 0);
      final tomorrow = DateTime(2026, 11, 15);

      ScheduledArrivalSlot? pickedSlot;
      DateTime? pickedDate;

      await tester.pumpWidget(buildApp(
        Scaffold(
          body: ArrivalSlotPickerWidget(
            currentTime: today,
            onSlotSelected: (d, s) {
              pickedDate = d;
              pickedSlot = s;
            },
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Tap Tomorrow date chip (15th)
      final tomorrowChip = find.byKey(Key('date_chip_${tomorrow.year}_${tomorrow.month}_${tomorrow.day}'));
      expect(tomorrowChip, findsOneWidget);
      await tester.tap(tomorrowChip);
      await tester.pumpAndSettle();

      // For tomorrow, morning should be available
      expect(find.text('Available (4 spots)'), findsOneWidget);
      expect(pickedDate?.day, 15);
      expect(pickedSlot, isNotNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('6. ServiceScopingScreen renders AudioMemoRecorderWidget and ArrivalSlotPickerWidget', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildApp(const ServiceScopingScreen(tradeId: 'trade_electrician')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('audio_memo_recorder_widget')), findsOneWidget);
      expect(find.byKey(const Key('arrival_slot_picker_widget')), findsOneWidget);
      expect(find.text('15s Audio Memo Scoping'), findsOneWidget);
      expect(find.text('Select Arrival Date & Slot'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('7. Viewport test on 360x800 with 2.0x font scaling mounts with zero overflows in idle, recording, and preview', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      final service = KarigaarAudioService();
      addTearDown(() => service.dispose());

      await tester.pumpWidget(buildApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AudioMemoRecorderWidget(audioService: service),
                const ArrivalSlotPickerWidget(),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('start_recording_button')), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Transition to active recording state under 2.0x text scaling
      await tester.tap(find.byKey(const Key('start_recording_button')));
      await tester.pump();
      expect(service.state, AudioRecordingState.recording);
      expect(tester.takeException(), isNull);

      // Transition to stopped preview state
      await tester.tap(find.byKey(const Key('stop_recording_button')));
      await tester.pumpAndSettle();
      expect(service.state, AudioRecordingState.stopped);
      expect(tester.takeException(), isNull);
    });

    testWidgets('8. Narrow viewport test on 320x568 (iPhone SE 1st gen) with 2.0x font scaling mounts with zero overflows in idle, recording, and preview', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      final service = KarigaarAudioService();
      addTearDown(() => service.dispose());

      await tester.pumpWidget(buildApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                AudioMemoRecorderWidget(audioService: service),
                const ArrivalSlotPickerWidget(),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('start_recording_button')), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Transition to active recording state under 2.0x text scaling
      await tester.tap(find.byKey(const Key('start_recording_button')));
      await tester.pump();
      expect(service.state, AudioRecordingState.recording);
      expect(tester.takeException(), isNull);

      // Transition to stopped preview state
      await tester.tap(find.byKey(const Key('stop_recording_button')));
      await tester.pumpAndSettle();
      expect(service.state, AudioRecordingState.stopped);
      expect(tester.takeException(), isNull);
    });

    testWidgets('9. ArtisanJobRadarScreen voice memo badge opens audio preview modal', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(buildApp(const ArtisanJobRadarScreen()));
      await tester.pumpAndSettle();

      final badge = find.byKey(const Key('voice_memo_radar_badge'));
      expect(badge, findsOneWidget);

      await tester.tap(badge);
      await tester.pumpAndSettle();

      expect(find.textContaining('Customer Audio Scoping'), findsOneWidget);
      expect(find.byKey(const Key('radar_modal_play_button')), findsOneWidget);
      expect(find.text('Listen to Customer Audio Memo'), findsOneWidget);

      // Tap play preview
      await tester.tap(find.byKey(const Key('radar_modal_play_button')));
      await tester.pump();
      expect(find.text('Pause Preview'), findsOneWidget);

      // Tap again to pause preview and clean up periodic timer
      await tester.tap(find.byKey(const Key('radar_modal_play_button')));
      await tester.pump();
      expect(find.text('Listen to Customer Audio Memo'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('10. CustomerBookingsScreen displays scheduled arrival slot badge and audio memo badge', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final sampleBooking = BookingModel(
        bookingId: 'BK_NANDED_8821',
        customerId: 'cust_01',
        customerName: 'Asim Farooqui',
        customerPhone: '+919822199882',
        tradeId: 'trade_electrician',
        tradeName: 'Electrician',
        localityId: 'loc_anand_nagar',
        localityName: 'Anand Nagar, Nanded',
        address: 'Plot 14, Near Water Tank, Anand Nagar',
        status: BookingStatus.artisanEnRoute,
        audioMemoUrl: 'https://cdn.karigaar.in/audio/memo_8821.aac',
        audioMemoDurationSeconds: 14,
        audioMemoTranscript: 'MCB switch sparks when turning on AC.',
        scheduledDate: DateTime.now(),
        scheduledSlot: 'Morning (9:00 AM - 12:00 PM)',
        scheduledSlotId: 'slot_morning',
        isEmergencyDispatch: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(buildApp(
        const CustomerBookingsScreen(),
        overrides: [
          activeBookingProvider.overrideWith((ref) => sampleBooking),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('active_booking_slot_badge')), findsOneWidget);
      expect(find.byKey(const Key('active_booking_audio_badge')), findsOneWidget);
      expect(find.text('Morning (9:00 AM - 12:00 PM)'), findsOneWidget);
      expect(find.text('14s Voice Note'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('11. ServiceScopingScreen on narrow viewport 320x568 with 2.0x font scaling mounts with zero overflows', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      await tester.pumpWidget(buildApp(const ServiceScopingScreen(tradeId: 'trade_electrician')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('audio_memo_recorder_widget')), findsOneWidget);
      expect(find.byKey(const Key('arrival_slot_picker_widget')), findsOneWidget);
      expect(find.text('Request Artisan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('12. ServiceScopingScreen on 360x800 with 2.0x font scaling mounts with zero overflows', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      await tester.pumpWidget(buildApp(const ServiceScopingScreen(tradeId: 'trade_plumber')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('audio_memo_recorder_widget')), findsOneWidget);
      expect(find.byKey(const Key('arrival_slot_picker_widget')), findsOneWidget);
      expect(find.text('Request Artisan'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
