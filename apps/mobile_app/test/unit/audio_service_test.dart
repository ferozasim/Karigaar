import 'package:flutter_test/flutter_test.dart';
import 'package:karigaar_app/core/models/audio_memo_model.dart';
import 'package:karigaar_app/core/services/audio_service.dart';
import 'package:karigaar_app/core/services/api_service.dart';

void main() {
  group('Ticket T-08 Unit Tests: KarigaarAudioService & F-10 Audio Memo Scoping', () {
    late KarigaarAudioService audioService;
    late KarigaarApiService apiService;

    setUp(() {
      audioService = KarigaarAudioService();
      apiService = const KarigaarApiService();
    });

    tearDown(() {
      audioService.dispose();
    });

    test('1. AudioRecordingState enum predicates correctly identify lifecycle phases', () {
      expect(AudioRecordingState.idle.isIdle, isTrue);
      expect(AudioRecordingState.recording.isRecording, isTrue);
      expect(AudioRecordingState.stopped.isStopped, isTrue);
      expect(AudioRecordingState.playing.isPlaying, isTrue);
      expect(AudioRecordingState.paused.isPaused, isTrue);
    });

    test('2. AudioMemoModel initializes with valid properties and generates normalized waveform', () {
      final waveform = AudioMemoModel.generateSimulatedWaveform(24, 42);
      expect(waveform.length, 24);
      for (final val in waveform) {
        expect(val, greaterThanOrEqualTo(0.08));
        expect(val, lessThanOrEqualTo(0.98));
      }

      final memo = AudioMemoModel(
        id: 'memo_test_01',
        url: 'https://cdn.karigaar.in/audio/memo_test_01.aac',
        durationSeconds: 14,
        waveform: waveform,
        transcript: 'AC compressor humming loudly',
        fileSizeBytes: 35840,
        recordedAt: DateTime(2026, 11, 14, 18, 30),
      );

      expect(memo.id, 'memo_test_01');
      expect(memo.durationSeconds, 14);
      expect(memo.transcript, 'AC compressor humming loudly');
      expect(AudioMemoModel.maxDurationSeconds, 15);
    });

    test('3. AudioMemoModel serialization and deserialization (toJson / fromJson) preserves integrity', () {
      final original = AudioMemoModel(
        id: 'memo_8821',
        url: 'https://cdn.karigaar.in/audio/memo_8821.aac',
        durationSeconds: 12,
        waveform: const [0.15, 0.45, 0.82, 0.64],
        transcript: 'Water pipe leak in kitchen ceiling',
        fileSizeBytes: 30720,
        recordedAt: DateTime(2026, 11, 14, 12, 0, 0),
      );

      final json = original.toJson();
      expect(json['id'], 'memo_8821');
      expect(json['durationSeconds'], 12);
      expect(json['waveform'], [0.15, 0.45, 0.82, 0.64]);
      expect(json['transcript'], 'Water pipe leak in kitchen ceiling');

      final reconstructed = AudioMemoModel.fromJson(json);
      expect(reconstructed.id, original.id);
      expect(reconstructed.url, original.url);
      expect(reconstructed.durationSeconds, original.durationSeconds);
      expect(reconstructed.waveform, original.waveform);
      expect(reconstructed.transcript, original.transcript);
    });

    test('4. KarigaarAudioService starts in clean idle state', () {
      expect(audioService.state, AudioRecordingState.idle);
      expect(audioService.elapsedSeconds, 0);
      expect(audioService.liveWaveform, isEmpty);
      expect(audioService.playbackProgress, 0.0);
      expect(audioService.hasRecordedMemo, isFalse);
    });

    test('5. KarigaarAudioService.startRecording() transitions state and emits updates', () async {
      final stateExpectations = expectLater(
        audioService.stateStream,
        emits(AudioRecordingState.recording),
      );

      await audioService.startRecording(seed: 100);
      expect(audioService.state, AudioRecordingState.recording);
      await stateExpectations;
    });

    test('6. KarigaarAudioService.stopRecording() finalizes AudioMemoModel with correct duration and CDN url', () async {
      await audioService.startRecording(seed: 101);
      final memo = await audioService.stopRecording();

      expect(audioService.state, AudioRecordingState.stopped);
      expect(memo, isNotNull);
      expect(memo!.durationSeconds, greaterThanOrEqualTo(1));
      expect(memo.durationSeconds, lessThanOrEqualTo(15));
      expect(memo.url, startsWith('https://cdn.karigaar.in/audio/'));
      expect(memo.waveform.length, greaterThanOrEqualTo(6));
      expect(audioService.recordedMemo, equals(memo));
      expect(audioService.hasRecordedMemo, isTrue);
    });

    test('7. KarigaarAudioService.playPreview(), pausePreview(), and seekPreview() control playback preview', () async {
      await audioService.startRecording(seed: 102);
      await audioService.stopRecording();

      expect(audioService.state, AudioRecordingState.stopped);

      // Play preview
      await audioService.playPreview();
      expect(audioService.state, AudioRecordingState.playing);

      // Seek preview
      audioService.seekPreview(0.5);
      expect(audioService.playbackProgress, 0.5);

      // Pause preview
      await audioService.pausePreview();
      expect(audioService.state, AudioRecordingState.paused);
      expect(audioService.playbackProgress, 0.5);

      // Seek back to start
      audioService.seekPreview(0.0);
      expect(audioService.playbackProgress, 0.0);
    });

    test('8. KarigaarAudioService.deleteAndReset() completely purges recorded memo back to idle state', () async {
      await audioService.startRecording(seed: 103);
      await audioService.stopRecording();
      expect(audioService.hasRecordedMemo, isTrue);

      audioService.deleteAndReset();

      expect(audioService.state, AudioRecordingState.idle);
      expect(audioService.elapsedSeconds, 0);
      expect(audioService.liveWaveform, isEmpty);
      expect(audioService.recordedMemo, isNull);
      expect(audioService.playbackProgress, 0.0);
    });

    test('9. Contract 8 API: upload rejects duration exceeding 15 seconds with 422 AUDIO_EXCEEDS_MAX_DURATION', () async {
      expect(
        () => apiService.uploadAudioMemo(
          bookingId: 'BK_NANDED_8821',
          tradeId: 'trade_electrician',
          durationSeconds: 16,
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 422)
              .having((e) => e.code, 'code', 'AUDIO_EXCEEDS_MAX_DURATION'),
        ),
      );
    });

    test('10. Contract 8 API: upload rejects duration less than 1 second with 422 AUDIO_TOO_SHORT', () async {
      expect(
        () => apiService.uploadAudioMemo(
          bookingId: 'BK_NANDED_8821',
          tradeId: 'trade_electrician',
          durationSeconds: 0,
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 422)
              .having((e) => e.code, 'code', 'AUDIO_TOO_SHORT'),
        ),
      );
    });

    test('11. Contract 8 API: valid 1-15s upload succeeds and returns CDN URL, waveform, and transcript', () async {
      final res = await apiService.uploadAudioMemo(
        bookingId: 'BK_NANDED_8821',
        tradeId: 'trade_electrician',
        durationSeconds: 14,
        waveform: const [0.15, 0.42, 0.68, 0.85, 0.92],
      );

      expect(res['status'], 'SUCCESS');
      final data = res['data'] as Map<String, dynamic>;
      expect(data['memoId'], isNotEmpty);
      expect(data['audioMemoUrl'], contains('https://cdn.karigaar.in/audio/'));
      expect(data['durationSeconds'], 14);
      expect(data['waveform'], [0.15, 0.42, 0.68, 0.85, 0.92]);
      expect(data['transcript'], contains('trade_electrician'));
    });
  });
}
