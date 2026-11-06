import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ContactIntentService {
  /// Launches native phone dialer for Path A direct communication with fallback dialog
  static Future<void> makePhoneCall(
    BuildContext context, {
    required String phoneNumber,
    String? contactName,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          _showSimulatedIntentSheet(
            context,
            title: 'Direct Telephony Call Dispatched',
            actionText: 'Calling ${contactName ?? cleanPhone}',
            details: 'Intent: tel:$cleanPhone\n\n(Dialer intent simulated on desktop/test environment)',
            icon: Icons.phone_in_talk_rounded,
            iconColor: AppColors.primary,
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        _showSimulatedIntentSheet(
          context,
          title: 'Direct Telephony Call Dispatched',
          actionText: 'Calling ${contactName ?? cleanPhone}',
          details: 'Intent: tel:$cleanPhone\n\n(Dialer intent simulated on desktop/test environment)',
          icon: Icons.phone_in_talk_rounded,
          iconColor: AppColors.primary,
        );
      }
    }
  }

  /// Launches WhatsApp chat for Path A direct inquiry with pre-filled message
  static Future<void> openWhatsAppChat(
    BuildContext context, {
    required String phoneNumber,
    required String prefilledMessage,
    String? contactName,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final encodedMsg = Uri.encodeComponent(prefilledMessage);
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$encodedMsg');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          _showSimulatedIntentSheet(
            context,
            title: 'WhatsApp Conversation Dispatched',
            actionText: 'Chatting with ${contactName ?? cleanPhone}',
            details: 'URI: $uri\n\nMessage: "$prefilledMessage"\n\n(WhatsApp intent simulated on desktop/test environment)',
            icon: Icons.chat_bubble_rounded,
            iconColor: const Color(0xFF25D366),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        _showSimulatedIntentSheet(
          context,
          title: 'WhatsApp Conversation Dispatched',
          actionText: 'Chatting with ${contactName ?? cleanPhone}',
          details: 'URI: $uri\n\nMessage: "$prefilledMessage"\n\n(WhatsApp intent simulated on desktop/test environment)',
          icon: Icons.chat_bubble_rounded,
          iconColor: const Color(0xFF25D366),
        );
      }
    }
  }

  /// Interactive simulated intent modal bottom sheet for headless/desktop/testing environments
  static void _showSimulatedIntentSheet(
    BuildContext context, {
    required String title,
    required String actionText,
    required String details,
    required IconData icon,
    required Color iconColor,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.headlineSm.copyWith(fontSize: 16)),
                      Text(actionText, style: AppTypography.bodySm.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                details,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Dismiss Intent Simulation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
