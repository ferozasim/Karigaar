import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/audio_memo_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Interactive 15-Second Audio Memo Recorder & Playback Preview Widget (F-10).
/// Strictly adheres to flutter_layout_rules: finite button sizes, no Flexible inside button icons,
/// responsive down to 320px viewport width.
class AudioMemoRecorderWidget extends ConsumerStatefulWidget {
  final KarigaarAudioService? audioService;
  final ValueChanged<AudioMemoModel?>? onMemoChanged;

  const AudioMemoRecorderWidget({
    super.key,
    this.audioService,
    this.onMemoChanged,
  });

  @override
  ConsumerState<AudioMemoRecorderWidget> createState() =>
      _AudioMemoRecorderWidgetState();
}

class _AudioMemoRecorderWidgetState
    extends ConsumerState<AudioMemoRecorderWidget>
    with SingleTickerProviderStateMixin {
  late KarigaarAudioService _service;
  StreamSubscription<AudioRecordingState>? _stateSub;
  StreamSubscription<int>? _elapsedSub;
  StreamSubscription<List<double>>? _waveformSub;
  StreamSubscription<double>? _progressSub;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _service = widget.audioService ?? KarigaarAudioService.instance;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (_service.state == AudioRecordingState.recording) {
      _pulseController.repeat(reverse: true);
    }

    _stateSub = _service.stateStream.listen((state) {
      if (state == AudioRecordingState.recording) {
        if (!_pulseController.isAnimating) {
          _pulseController.repeat(reverse: true);
        }
      } else {
        if (_pulseController.isAnimating) {
          _pulseController.stop();
          _pulseController.reset();
        }
      }
      if (mounted) setState(() {});
      if (state == AudioRecordingState.stopped) {
        final memo = _service.recordedMemo;
        ref.read(recordedAudioMemoProvider.notifier).state = memo;
        widget.onMemoChanged?.call(memo);
      } else if (state == AudioRecordingState.idle) {
        ref.read(recordedAudioMemoProvider.notifier).state = null;
        widget.onMemoChanged?.call(null);
      }
    });

    _elapsedSub = _service.elapsedSecondsStream.listen((_) {
      if (mounted) setState(() {});
    });

    _waveformSub = _service.waveformStream.listen((_) {
      if (mounted) setState(() {});
    });

    _progressSub = _service.playbackProgressStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant AudioMemoRecorderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.audioService != null && widget.audioService != _service) {
      _service = widget.audioService!;
    }
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _elapsedSub?.cancel();
    _waveformSub?.cancel();
    _progressSub?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _service.state;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: state.isRecording
            ? const Color(0xFFFEF2F2)
            : AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: state.isRecording
              ? AppColors.error
              : state.isPlaying
                  ? AppColors.secondary
                  : AppColors.borderSubtle,
          width: state.isRecording || state.isPlaying ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: state.isRecording
                            ? AppColors.errorContainer
                            : AppColors.secondarySurfaceTint,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        state.isRecording
                            ? Icons.mic_rounded
                            : Icons.graphic_eq_rounded,
                        color: state.isRecording
                            ? AppColors.error
                            : AppColors.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '15s Audio Memo Scoping',
                            style: AppTypography.headlineSm.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            state.isRecording
                                ? 'Recording in progress (Max 15s)...'
                                : state.isStopped || state.isPlaying || state.isPaused
                                    ? 'Voice memo attached (${_service.recordedMemo?.durationSeconds ?? _service.elapsedSeconds}s)'
                                    : 'Explain defect in Hindi, Marathi, or English',
                            style: AppTypography.labelSm.copyWith(
                              color: state.isRecording
                                  ? AppColors.error
                                  : AppColors.textMuted,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isRecording) ...[
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.fiber_manual_record,
                              size: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '0:${_service.elapsedSeconds.toString().padLeft(2, '0')} / 0:15',
                              style: AppTypography.labelSm.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          // Main body conditional on state
          if (state.isIdle) ...[
            _buildIdleView(),
          ] else if (state.isRecording) ...[
            _buildRecordingView(),
          ] else ...[
            _buildPreviewView(),
          ],
        ],
      ),
    );
  }

  Widget _buildIdleView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Record up to 15 seconds of motor hum, water leak sound, or sparking sound for the master artisan.',
          style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            key: const Key('start_recording_button'),
            onPressed: () => _service.startRecording(),
            icon: const Icon(Icons.mic_rounded, size: 20),
            label: Text(
              'Record 15s Audio Memo',
              style: AppTypography.labelMd.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              minimumSize: const Size(120, 48),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingView() {
    final waveform = _service.liveWaveform.isNotEmpty
        ? _service.liveWaveform
        : [0.2, 0.4, 0.6, 0.8, 0.5, 0.3];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Live Waveform Visualizer
        Container(
          height: 52,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.errorContainer),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(24, (index) {
              final val = index < waveform.length ? waveform[index] : 0.15;
              final height = (val * 40).clamp(4.0, 44.0);
              return Container(
                width: 4,
                height: height,
                decoration: BoxDecoration(
                  color: index < waveform.length
                      ? AppColors.error
                      : AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            key: const Key('stop_recording_button'),
            onPressed: () => _service.stopRecording(),
            icon: const Icon(Icons.stop_rounded, size: 20),
            label: Text(
              'Stop Recording (${_service.elapsedSeconds}s)',
              style: AppTypography.labelMd.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(120, 48),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewView() {
    final memo = _service.recordedMemo;
    final waveform = memo?.waveform.isNotEmpty == true
        ? memo!.waveform
        : _service.liveWaveform.isNotEmpty
            ? _service.liveWaveform
            : AudioMemoModel.generateSimulatedWaveform(24);

    final durationSec = memo?.durationSeconds ??
        (_service.elapsedSeconds > 0 ? _service.elapsedSeconds : 15);
    final isPlaying = _service.state.isPlaying;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Waveform Scrubber Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Waveform Bars
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  final renderBox = context.findRenderObject() as RenderBox?;
                  if (renderBox != null) {
                    final width = renderBox.size.width - 48;
                    if (width > 0) {
                      final ratio = (details.localPosition.dx / width).clamp(0.0, 1.0);
                      _service.seekPreview(ratio);
                    }
                  }
                },
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(waveform.length.clamp(12, 28), (index) {
                      final amp = index < waveform.length ? waveform[index] : 0.3;
                      final barHeight = (amp * 36).clamp(4.0, 36.0);
                      final barProgress = index / waveform.length;
                      final isPassed = barProgress <= _service.playbackProgress;

                      return Container(
                        width: 4,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: isPassed
                              ? AppColors.secondary
                              : AppColors.borderSubtle,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0:${((_service.playbackProgress * durationSec).round()).toString().padLeft(2, '0')}',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '0:${durationSec.toString().padLeft(2, '0')}',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Action Buttons Row: Play/Pause, Re-record, Delete
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ElevatedButton.icon(
              key: const Key('play_preview_button'),
              onPressed: () {
                if (isPlaying) {
                  _service.pausePreview();
                } else {
                  _service.playPreview();
                }
              },
              icon: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 20,
              ),
              label: Text(
                isPlaying ? 'Pause' : 'Play Preview',
                style: AppTypography.labelMd.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 42),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            OutlinedButton.icon(
              key: const Key('rerecord_button'),
              onPressed: () => _service.startRecording(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Re-record',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(100, 42),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            IconButton(
              key: const Key('delete_memo_button'),
              tooltip: 'Delete Audio Memo',
              onPressed: () => _service.deleteAndReset(),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 22,
              ),
            ),
          ],
        ),

        if (memo?.transcript != null && memo!.transcript!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.subtitles_rounded,
                  size: 16,
                  color: AppColors.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    memo.transcript!,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textPrimary,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
