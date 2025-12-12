import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mashhad_metro/providers/station_provider.dart';
import 'package:mashhad_metro/models/station_model.dart';

class StationDetail extends ConsumerWidget {
  final String stationName;

  const StationDetail({super.key, required this.stationName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationAsync = ref.watch(stationByNameProvider(stationName));

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: stationAsync.when(
        data: (station) {
          if (station == null) {
            return const Center(
              child: Text(
                'ایستگاه یافت نشد',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final primaryColor = _parseColor(
            station.colors.isNotEmpty ? station.colors.first : '#87CEEB',
          );

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: primaryColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.7)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),

                    child: Stack(
                      children: [
                        Positioned(
                          left: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),

                        Positioned(
                          right: 16,
                          left: 16,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                station.translations['fa'] ?? station.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                station.name.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              if (station.nearHolyshrine) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'نزدیک ترین ایستگاه به حرم امام رضا(ع)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.mosque,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSection(
                        title: 'خطوط مترو',
                        icon: Icons.subway,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          children: station.lines.map((lineNum) {
                            return _buildLineChip(lineNum, station);
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        title: 'آدرس',
                        icon: Icons.location_on,
                        child: Text(
                          station.address,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.6,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        title: 'امکانات',
                        icon: Icons.info_outline,
                        child: _buildFacilities(station),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },

        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (error, _) => Center(
          child: Text(
            'خطا در بارگذاری اطلاعات',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),

      bottomNavigationBar: stationAsync.when(
        data: (station) => station != null
            ? _buildBottomButtons(context, station)
            : const SizedBox(),
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white70, size: 22),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildLineChip(int lineNumber, StationModel station) {
    final position = station.getPositionInLine(lineNumber);
    final color = _parseColor(
      station.colors.isNotEmpty ? station.colors.first : '#87CEEB',
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (position != null) ...[
            Text(
              'ایستگاه $position',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 1.5,
              height: 18,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            'خط $lineNumber',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilities(StationModel station) {
    final facilities = <Map<String, dynamic>>[
      if (station.wc) {'icon': Icons.wc, 'label': 'سرویس بهداشتی'},
      if (station.elevator) {'icon': Icons.elevator, 'label': 'آسانسور'},
      if (station.atm) {'icon': Icons.atm, 'label': 'خودپرداز'},
      if (station.prayerRoom) {'icon': Icons.mosque, 'label': 'نمازخانه'},
      if (station.freeWifi) {'icon': Icons.wifi, 'label': 'وای‌فای رایگان'},
      if (station.coffeeShop) {'icon': Icons.coffee, 'label': 'کافی‌شاپ'},
      if (station.fastFood) {'icon': Icons.fastfood, 'label': 'فست‌فود'},
      if (station.groceryStore) {'icon': Icons.store, 'label': 'بقالی'},
      if (station.bicycleParking)
        {'icon': Icons.pedal_bike, 'label': 'پارکینگ دوچرخه'},
      if (station.camera) {'icon': Icons.videocam, 'label': 'دوربین مداربسته'},
      if (station.waitingChair) {'icon': Icons.chair, 'label': 'صندلی انتظار'},
      if (station.blindPath)
        {'icon': Icons.accessibility_new, 'label': 'مسیر نابینایان'},
      if (station.fireExtinguisher)
        {'icon': Icons.fire_extinguisher, 'label': 'کپسول آتش‌نشانی'},
      if (station.metroPolice)
        {'icon': Icons.local_police, 'label': 'پلیس مترو'},
    ];

    if (facilities.isEmpty) {
      return const Text(
        'امکانات ثبت نشده است',
        style: TextStyle(color: Colors.white54, fontSize: 14),
        textAlign: TextAlign.right,
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.end,
      children: facilities.map((facility) {
        final label = facility['label'] as String;
        final icon = facility['icon'] as IconData;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, color: Colors.white70, size: 18),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomButtons(BuildContext context, StationModel station) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'قابلیت نمایش در نقشه به زودی اضافه می‌شود',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.map, size: 20),
                label: const Text(
                  'نمایش در نقشه',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  final coordinates =
                      '${station.latitude}, ${station.longitude}';
                  Clipboard.setData(ClipboardData(text: coordinates));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'مختصات کپی شد',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green.shade700,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 20),
                label: const Text(
                  'کپی مختصات',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _parseColor(
                    station.colors.isNotEmpty
                        ? station.colors.first
                        : '#87CEEB',
                  ),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
