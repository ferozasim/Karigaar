import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../l10n/localized_strings.dart';

class AppLanguageSelector extends ConsumerWidget {
  const AppLanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(partnerLanguageProvider);
    final strings = localizedStrings(context);
    final options = <(String, String)>[
      ('en', strings.english),
      ('hi', strings.hindi),
      ('mr', strings.marathi),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(strings.languageSetting,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(strings.chooseLanguage,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: options.map((option) {
                final selected = languageCode == option.$1;
                return ChoiceChip(
                  label: Text(option.$2),
                  selected: selected,
                  onSelected: (_) => ref
                      .read(partnerLanguageProvider.notifier)
                      .state = option.$1,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
