import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/booking_model.dart';
import '../../../core/models/support_case.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

Future<void> showSupportCaseSheet({
  required BuildContext context,
  required WidgetRef ref,
  required BookingModel booking,
  required String reporterId,
  required String reporterRole,
}) async {
  final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _SupportCaseSheet(
        booking: booking,
        reporterId: reporterId,
        reporterRole: reporterRole,
      ),
    );
  if (submitted == true && context.mounted) {
    final message = ref.read(isFirebaseLiveProvider)
        ? 'Report submitted for support review.'
        : 'Report saved in this app only; it has not reached support.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SupportCaseSheet extends ConsumerStatefulWidget {
  const _SupportCaseSheet({
    required this.booking,
    required this.reporterId,
    required this.reporterRole,
  });

  final BookingModel booking;
  final String reporterId;
  final String reporterRole;

  @override
  ConsumerState<_SupportCaseSheet> createState() => _SupportCaseSheetState();
}

class _SupportCaseSheetState extends ConsumerState<_SupportCaseSheet> {
  final _descriptionController = TextEditingController();
  final _evidenceController = TextEditingController();
  late final String _submissionKey =
      'support_${widget.booking.bookingId}_${widget.reporterId}_${DateTime.now().microsecondsSinceEpoch}';
  SupportCaseCategory _category = SupportCaseCategory.other;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _descriptionController.dispose();
    _evidenceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final description = _descriptionController.text.trim();
    final references = _evidenceController.text
        .split(RegExp(r'[\n,]'))
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
    if (description.length < 10) {
      setState(() => _error = 'Describe what happened in at least 10 characters.');
      return;
    }
    if (description.length > 2000 || references.length > 5) {
      setState(() => _error = 'Keep the description under 2,000 characters and add up to 5 evidence links.');
      return;
    }
    final validReferences = references.every((value) {
      final uri = Uri.tryParse(value);
      return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
    });
    if (!validReferences) {
      setState(() => _error = 'Evidence links must be valid HTTPS links.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final now = DateTime.now().toUtc();
      final caseId = _submissionKey.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final supportCase = SupportCase.create(
        caseId: caseId,
        idempotencyKey: _submissionKey,
        bookingId: widget.booking.bookingId,
        reporterId: widget.reporterId,
        reporterRole: widget.reporterRole,
        category: _category,
        description: description,
        evidenceReferences: references,
        createdAt: now,
      );
      await ref.read(supportCaseRepositoryProvider).create(supportCase);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = 'Your report could not be submitted. Check your connection and retry.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cases = ref.watch(repositorySupportCasesProvider(widget.booking.bookingId));
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report an issue', style: AppTypography.headlineSm),
            const SizedBox(height: 6),
            Text(
              'Booking ${widget.booking.bookingId} · ${widget.booking.tradeName}',
              style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<SupportCaseCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Issue type'),
              items: SupportCaseCategory.values
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.label),
                      ))
                  .toList(growable: false),
              onChanged: _submitting
                  ? null
                  : (value) => setState(() => _category = value ?? _category),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'What happened?',
                hintText: 'Include the time and what help you need.',
                alignLabelWithHint: true,
              ),
            ),
            TextField(
              controller: _evidenceController,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Evidence links (optional)',
                hintText: 'HTTPS links, up to 5; separate with commas or new lines',
                helperText: 'Use links you are comfortable sharing with Karigaar support.',
              ),
            ),
            if (_category == SupportCaseCategory.safetyConcern) ...[
              const SizedBox(height: 8),
              const Text(
                'This report is not an emergency line. If anyone is in immediate danger, contact local emergency services.',
                style: TextStyle(color: AppColors.error),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: Text(_submitting ? 'Submitting…' : 'Submit report'),
              ),
            ),
            const SizedBox(height: 16),
            Text('Your reports', style: AppTypography.labelMd),
            const SizedBox(height: 6),
            cases.when(
              data: (items) => items.isEmpty
                  ? Text(
                      'No reports yet. Support will review a submitted report; filing does not mean a claim is approved.',
                      style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items
                          .map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '${item.category.label} · ${_statusLabel(item.status)}',
                                  style: AppTypography.bodySm,
                                ),
                              ))
                          .toList(growable: false),
                    ),
              error: (_, __) => Text(
                'Report status is temporarily unavailable.',
                style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
              ),
              loading: () => const LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(SupportCaseStatus status) => switch (status) {
        SupportCaseStatus.submitted => 'Submitted for review',
        SupportCaseStatus.underReview => 'Under review',
        SupportCaseStatus.awaitingInformation => 'Support needs more information',
        SupportCaseStatus.resolved => 'Resolved',
      };
}
