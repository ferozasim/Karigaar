import 'dart:math';

/// State of audio memo recording / preview playback lifecycle.
enum AudioRecordingState {
  idle,
  recording,
  stopped,
  playing,
  paused;

  bool get isIdle => this == AudioRecordingState.idle;
  bool get isRecording => this == AudioRecordingState.recording;
  bool get isStopped => this == AudioRecordingState.stopped;
  bool get isPlaying => this == AudioRecordingState.playing;
  bool get isPaused => this == AudioRecordingState.paused;
}

/// Data model representing a customer-recorded 15s audio memo conforming to F-10.
class AudioMemoModel {
  final String id;
  final String url;
  final int durationSeconds;
  final List<double> waveform;
  final String? transcript;
  final int fileSizeBytes;
  final DateTime recordedAt;

  const AudioMemoModel({
    required this.id,
    required this.url,
    required this.durationSeconds,
    this.waveform = const [],
    this.transcript,
    this.fileSizeBytes = 38400,
    required this.recordedAt,
  });

  /// Maximum allowed duration in seconds for scoping memos (Hard 15-second cap).
  static const int maxDurationSeconds = 15;

  /// Generate a realistic normalized waveform (amplitudes between 0.08 and 0.98)
  static List<double> generateSimulatedWaveform([int samples = 24, int? seed]) {
    final rng = Random(seed ?? DateTime.now().millisecondsSinceEpoch);
    final List<double> result = [];
    for (int i = 0; i < samples; i++) {
      // Natural bell-curve modulation with random acoustic variation
      final centerFactor = 1.0 - ((i - (samples / 2)).abs() / (samples / 2)) * 0.4;
      final raw = (0.2 + rng.nextDouble() * 0.75) * centerFactor;
      result.add(double.parse(raw.clamp(0.08, 0.98).toStringAsFixed(2)));
    }
    return result;
  }

  AudioMemoModel copyWith({
    String? id,
    String? url,
    int? durationSeconds,
    List<double>? waveform,
    String? transcript,
    int? fileSizeBytes,
    DateTime? recordedAt,
  }) {
    return AudioMemoModel(
      id: id ?? this.id,
      url: url ?? this.url,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      waveform: waveform ?? this.waveform,
      transcript: transcript ?? this.transcript,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  factory AudioMemoModel.fromJson(Map<String, dynamic> json) {
    return AudioMemoModel(
      id: json['id'] as String? ?? json['memoId'] as String? ?? 'memo_${DateTime.now().millisecondsSinceEpoch}',
      url: json['url'] as String? ?? json['audioMemoUrl'] as String? ?? '',
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      waveform: (json['waveform'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      transcript: json['transcript'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 38400,
      recordedAt: json['recordedAt'] != null
          ? DateTime.parse(json['recordedAt'] as String)
          : json['uploadedAt'] != null
              ? DateTime.parse(json['uploadedAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'durationSeconds': durationSeconds,
        'waveform': waveform,
        if (transcript != null) 'transcript': transcript,
        'fileSizeBytes': fileSizeBytes,
        'recordedAt': recordedAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioMemoModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url &&
          durationSeconds == other.durationSeconds;

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ durationSeconds.hashCode;

  @override
  String toString() =>
      'AudioMemoModel(id: $id, duration: ${durationSeconds}s, url: $url)';
}
