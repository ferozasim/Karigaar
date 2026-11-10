import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CustomerMessagesScreen extends ConsumerStatefulWidget {
  const CustomerMessagesScreen({super.key});

  @override
  ConsumerState<CustomerMessagesScreen> createState() =>
      _CustomerMessagesScreenState();
}

class _CustomerMessagesScreenState
    extends ConsumerState<CustomerMessagesScreen> {
  String _selectedArtisanId = 'art_nanded_01';
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Map<String, List<Map<String, dynamic>>> _threads = {
    'art_nanded_01': [
      {
        'sender': 'artisan',
        'text':
            'Namaskar! I have departed from Vazirabad chowk with the Havells 32A MCB kit.',
        'time': '10:42 AM',
      },
      {
        'sender': 'customer',
        'text': 'Great, please enter via Gate 2 at Anand Nagar Society.',
        'time': '10:43 AM',
      },
    ],
    'art_nanded_02': [
      {
        'sender': 'artisan',
        'text':
            'Confirmed for tomorrow 10:30 AM. I will bring the Jaguar diverter cartridge.',
        'time': 'Yesterday',
      },
    ],
    'art_nanded_03': [
      {
        'sender': 'artisan',
        'text':
            'Thank you! Your 30-Day Guild Craftsmanship Warranty is active.',
        'time': '02 Nov',
      },
    ],
  };

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? preset]) {
    final text = (preset ?? _messageController.text).trim();
    if (text.isEmpty) return;

    setState(() {
      final list = _threads.putIfAbsent(_selectedArtisanId, () => []);
      list.add({
        'sender': 'customer',
        'text': text,
        'time': 'Just now',
      });
      if (preset == null) {
        _messageController.clear();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final artisans = ref.watch(topArtisansProvider);
    final selectedArtisan = artisans.firstWhere(
      (a) => a.artisanId == _selectedArtisanId,
      orElse: () => artisans.first,
    );
    final messages = _threads[_selectedArtisanId] ?? [];

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: const Text('Guild Masked Chat & WhatsApp'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/customer/home');
            }
          },
        ),
        actions: [
          IconButton(
            tooltip: 'View Artisan Profile',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () =>
                context.push('/customer/artisan/${selectedArtisan.artisanId}'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Artisan Thread Selector Strip
          Container(
            color: AppColors.surfaceRaised,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: artisans.map((artisan) {
                  final isSelected = artisan.artisanId == _selectedArtisanId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => setState(
                        () => _selectedArtisanId = artisan.artisanId,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.borderSubtle,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user_rounded,
                              size: 16,
                              color: isSelected
                                  ? AppColors.secondary
                                  : AppColors.tertiary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              artisan.name,
                              style: AppTypography.labelMd.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Privacy & Masked Bridge Notice
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.tertiarySurfaceTint,
            child: Row(
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 16,
                  color: AppColors.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Number Masking Active • Connected with ${selectedArtisan.name} (${selectedArtisan.tradeTitle})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: messages.map((msg) {
                final isCustomer = msg['sender'] == 'customer';
                return Align(
                  alignment: isCustomer
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isCustomer
                          ? AppColors.primary
                          : AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(16),
                      border: isCustomer
                          ? null
                          : Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'] as String,
                          style: AppTypography.bodyMd.copyWith(
                            color: isCustomer
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'] as String,
                          style: AppTypography.labelSm.copyWith(
                            fontSize: 10,
                            color: isCustomer
                                ? Colors.white70
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Canned Gate / Society Quick Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildQuickChip('Gate Pass Approved'),
                const SizedBox(width: 8),
                _buildQuickChip('Share Live Pin'),
                const SizedBox(width: 8),
                _buildQuickChip('Call on Arrival'),
              ],
            ),
          ),

          // Composer Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            decoration: const BoxDecoration(
              color: AppColors.surfaceRaised,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Message artisan via Guild Bridge...',
                      isDense: true,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _sendMessage(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildQuickChip(String label) {
    return ActionChip(
      label: Text(label, style: AppTypography.labelSm),
      backgroundColor: AppColors.surfaceRaised,
      onPressed: () => _sendMessage(label),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.explore_rounded,
            label: 'Explore',
            isActive: false,
            onTap: () => context.go('/customer/home'),
          ),
          _buildNavItem(
            icon: Icons.assignment_rounded,
            label: 'Bookings',
            isActive: false,
            onTap: () => context.go('/customer/bookings'),
          ),
          _buildNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Messages',
            isActive: true,
          ),
          _buildNavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: false,
            onTap: () => context.go('/customer/profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textSubtle,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: AppTypography.labelSm.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textSubtle,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
