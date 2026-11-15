import 'dart:async';
import 'dart:math';
import '../models/audio_memo_model.dart';

/// Pure Dart/Flutter Audio Service for 15s Scoping Memos (F-10).
/// Enforces 15-second hard limit auto-stop, live waveform generation,
/// and headless CI preview playback without broken native platform channels.
class KarigaarAudioService {
  static final KarigaarAudioService instance = KarigaarAudioService();

  AudioRecordingState _state = AudioRecordingState.idle;
  int _elapsedSeconds = 0;
  List<double> _liveWaveform = [];
  double _playbackProgress = 0.0; // 0.0 to 1.0
  AudioMemoModel? _recordedMemo;

  Timer? _recordingTimer;
  Timer? _playbackTimer;

  final _stateController = StreamController<AudioRecordingState>.broadcast();
  final _elapsedSecondsController = StreamController<int>.broadcast();
  final _waveformController = StreamController<List<double>>.broadcast();
  final _playbackProgressController = StreamController<double>.broadcast();

  KarigaarAudioService();

  // Getters
  AudioRecordingState get state => _state;
  int get elapsedSeconds => _elapsedSeconds;
  List<double> get liveWaveform => List.unmodifiable(_liveWaveform);
  double get playbackProgress => _playbackProgress;
  AudioMemoModel? get recordedMemo => _recordedMemo;
  bool get hasRecordedMemo => _recordedMemo != null;

  Stream<AudioRecordingState> get stateStream => _stateController.stream;
  Stream<int> get elapsedSecondsStream => _elapsedSecondsController.stream;
  Stream<List<double>> get waveformStream => _waveformController.stream;
  Stream<double> get playbackProgressStream =>
      _playbackProgressController.stream;

  void _setState(AudioRecordingState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  void _setElapsedSeconds(int sec) {
    _elapsedSeconds = sec;
    if (!_elapsedSecondsController.isClosed) {
      _elapsedSecondsController.add(_elapsedSeconds);
    }
  }

  void _setWaveform(List<double> wf) {
    _liveWaveform = wf;
    if (!_waveformController.isClosed) {
      _waveformController.add(_liveWaveform);
    }
  }

  void _setPlaybackProgress(double progress) {
    _playbackProgress = progress.clamp(0.0, 1.0);
    if (!_playbackProgressController.isClosed) {
      _playbackProgressController.add(_playbackProgress);
    }
  }

  /// Start recording up to a hard cap of 15 seconds.
  Future<void> startRecording({int? seed}) async {
    _stopAllTimers();
    _recordedMemo = null;
    _setPlaybackProgress(0.0);
    _setElapsedSeconds(0);
    _setWaveform([]);

    _setState(AudioRecordingState.recording);

    final rng = Random(seed ?? DateTime.now().millisecondsSinceEpoch);
    final List<double> dynamicWaveform = [];

    // Periodic timer ticking every 1 second
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state != AudioRecordingState.recording) {
        timer.cancel();
        return;
      }

      final nextSec = _elapsedSeconds + 1;
      _setElapsedSeconds(nextSec);

      // Generate 1-2 new normalized waveform amplitudes per second
      final amp1 = double.parse((0.15 + rng.nextDouble() * 0.75).clamp(0.1, 0.95).toStringAsFixed(2));
      final amp2 = double.parse((0.10 + rng.nextDouble() * 0.80).clamp(0.1, 0.95).toStringAsFixed(2));
      dynamicWaveform.addAll([amp1, amp2]);
      _setWaveform(List.from(dynamicWaveform));

      // Hard Limit: Exactly 15 seconds
      if (nextSec >= AudioMemoModel.maxDurationSeconds) {
        timer.cancel();
        stopRecording();
      }
    });
  }

  /// Stop recording and finalize AudioMemoModel.
  Future<AudioMemoModel?> stopRecording() async {
    if (_state != AudioRecordingState.recording) return _recordedMemo;

    _recordingTimer?.cancel();
    _recordingTimer = null;

    final finalDuration = _elapsedSeconds < 1 ? 1 : _elapsedSeconds;
    final finalWaveform = _liveWaveform.isNotEmpty
        ? List<double>.from(_liveWaveform)
        : AudioMemoModel.generateSimulatedWaveform(24);

    _setWaveform(finalWaveform);
    _setElapsedSeconds(finalDuration);

    final memoId = 'memo_${DateTime.now().millisecondsSinceEpoch}';
    _recordedMemo = AudioMemoModel(
      id: memoId,
      url: 'https://cdn.karigaar.in/audio/$memoId.aac',
      durationSeconds: finalDuration,
      waveform: finalWaveform,
      transcript: 'Customer voice description of defect ($finalDuration seconds).',
      fileSizeBytes: finalDuration * 2560,
      recordedAt: DateTime.now(),
    );

    _setState(AudioRecordingState.stopped);
    return _recordedMemo;
  }

  /// Start playback preview of the recorded memo.
  Future<void> playPreview() async {
    if (_recordedMemo == null && _liveWaveform.isEmpty) return;
    if (_state == AudioRecordingState.recording) return;

    _playbackTimer?.cancel();
    _setState(AudioRecordingState.playing);

    final totalDuration = _recordedMemo?.durationSeconds ??
        (_elapsedSeconds > 0 ? _elapsedSeconds : 15);
    final totalTicks = totalDuration * 10; // 10 ticks per second (100ms)

    _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_state != AudioRecordingState.playing) {
        timer.cancel();
        return;
      }

      final nextProgress = _playbackProgress + (1.0 / totalTicks);
      if (nextProgress >= 1.0) {
        _setPlaybackProgress(1.0);
        timer.cancel();
        _setState(AudioRecordingState.stopped);
        _setPlaybackProgress(0.0);
      } else {
        _setPlaybackProgress(nextProgress);
      }
    });
  }

  /// Pause current playback preview.
  Future<void> pausePreview() async {
    if (_state != AudioRecordingState.playing) return;
    _playbackTimer?.cancel();
    _playbackTimer = null;
    _setState(AudioRecordingState.paused);
  }

  /// Seek to a fractional position (0.0 to 1.0) in playback preview.
  void seekPreview(double progressRatio) {
    _setPlaybackProgress(progressRatio);
  }

  /// Delete recorded memo and reset service to idle state.
  void deleteAndReset() {
    _stopAllTimers();
    _recordedMemo = null;
    _setWaveform([]);
    _setElapsedSeconds(0);
    _setPlaybackProgress(0.0);
    _setState(AudioRecordingState.idle);
  }

  /// Reset to idle.
  void reset() {
    deleteAndReset();
  }

  void _stopAllTimers() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    _playbackTimer?.cancel();
    _playbackTimer = null;
  }

  void dispose() {
    _stopAllTimers();
    _stateController.close();
    _elapsedSecondsController.close();
    _waveformController.close();
    _playbackProgressController.close();
  }
}
