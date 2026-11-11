import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/city_model.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class LocalitySelectorSheet extends ConsumerStatefulWidget {
  const LocalitySelectorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocalitySelectorSheet(),
    );
  }

  @override
  ConsumerState<LocalitySelectorSheet> createState() => _LocalitySelectorSheetState();
}

class _LocalitySelectorSheetState extends ConsumerState<LocalitySelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityAsync = ref.watch(pilotCityProvider);
    final selectedLocality = ref.watch(selectedLocalityProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title & District Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Locality', style: AppTypography.headlineSm),
                    Consumer(
                      builder: (context, ref, _) {
                        final currentDistrict = ref.watch(selectedDistrictProvider);
                        final isNanded = currentDistrict.name.toLowerCase().contains('nanded');
                        return Text(
                          isNanded
                              ? 'Pilot City: Nanded-Waghala (Maharashtra)'
                              : 'District: ${currentDistrict.fullName}',
                          style: AppTypography.bodySm.copyWith(color: AppColors.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Consumer(
                builder: (context, ref, _) {
                  final currentDistrict = ref.watch(selectedDistrictProvider);
                  final isNanded = currentDistrict.name.toLowerCase().contains('nanded');
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondarySurfaceTint,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      isNanded ? '10 Hubs Active' : '${currentDistrict.localities.length} Hubs Active',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 7-District Regional Corridor Selector
          Consumer(
            builder: (context, ref, _) {
              final districtsAsync = ref.watch(regionalDistrictsProvider);
              final activeDistrict = ref.watch(selectedDistrictProvider);

              return districtsAsync.when(
                data: (districts) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: districts.map((dist) {
                      final isSelected = dist.name.toLowerCase() == activeDistrict.name.toLowerCase();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            ref.read(selectedDistrictProvider.notifier).state = dist;
                            if (dist.localities.isNotEmpty) {
                              ref.read(selectedLocalityProvider.notifier).state = dist.localities.first;
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                dist.name,
                                style: AppTypography.labelSm.copyWith(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),

          const SizedBox(height: 16),

          // Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim().toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search locality or pincode...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surfaceSubtle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          const SizedBox(height: 16),

          // Localities List
          Expanded(
            child: cityAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _buildFallbackList(selectedLocality),
              data: (city) {
                final localities = city.localities.where((loc) {
                  if (_searchQuery.isEmpty) return true;
                  return loc.name.toLowerCase().contains(_searchQuery) ||
                      loc.marathiName.toLowerCase().contains(_searchQuery) ||
                      loc.pincode.contains(_searchQuery);
                }).toList();

                if (localities.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_off_rounded, size: 48, color: AppColors.textSubtle),
                        const SizedBox(height: 8),
                        Text('No locality found in ${city.name}', style: AppTypography.bodyMd),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: localities.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderSubtle),
                  itemBuilder: (context, index) {
                    final loc = localities[index];
                    final isSelected = loc.localityId == selectedLocality.localityId;
                    return _buildLocalityItem(loc, isSelected);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalityItem(LocalityModel loc, bool isSelected) {
    return InkWell(
      onTap: () {
        ref.read(selectedLocalityProvider.notifier).state = loc;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched service hub to ${loc.name} (${loc.pincode})'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        color: isSelected ? AppColors.surfaceSubtle : Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: isSelected ? Colors.white : AppColors.textMuted,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          loc.name,
                          style: AppTypography.labelLg.copyWith(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (loc.emergencyHub) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.tertiarySurfaceTint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '25m Hub',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.tertiary,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          loc.marathiName,
                          style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• Pincode ${loc.pincode}',
                        style: AppTypography.bodySm.copyWith(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.tertiary, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackList(LocalityModel selectedLocality) {
    const fallbackLocalities = [
      LocalityModel(
        localityId: 'loc_anand_nagar',
        name: 'Anand Nagar',
        marathiName: 'आनंद नगर',
        pincode: '431602',
        center: GeoPointModel(latitude: 19.1685, longitude: 77.3090),
        radiusKm: 2.0,
        density: 'HIGH_RESIDENTIAL',
        emergencyHub: true,
      ),
      LocalityModel(
        localityId: 'loc_vazirabad',
        name: 'Vazirabad & Sarafa',
        marathiName: 'वजिराबाद आणि सराफा',
        pincode: '431601',
        center: GeoPointModel(latitude: 19.1555, longitude: 77.3190),
        radiusKm: 2.5,
        density: 'HIGH_COMMERCIAL_RESIDENTIAL',
        emergencyHub: true,
      ),
      LocalityModel(
        localityId: 'loc_cidco',
        name: 'CIDCO New Nanded',
        marathiName: 'सिडको',
        pincode: '431603',
        center: GeoPointModel(latitude: 19.1310, longitude: 77.3380),
        radiusKm: 3.5,
        density: 'RESIDENTIAL_PLANNED',
        emergencyHub: true,
      ),
    ];

    return ListView.separated(
      itemCount: fallbackLocalities.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borderSubtle),
      itemBuilder: (context, index) {
        final loc = fallbackLocalities[index];
        final isSelected = loc.localityId == selectedLocality.localityId;
        return _buildLocalityItem(loc, isSelected);
      },
    );
  }
}
