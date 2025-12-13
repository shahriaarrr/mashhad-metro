import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mashhad_metro/pages/LineDetail.dart';
import 'package:mashhad_metro/providers/station_provider.dart';
import 'package:mashhad_metro/models/station_model.dart';
import 'package:mashhad_metro/widgets/line_card.dart';
import 'package:mashhad_metro/pages/map.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStationsAsync = ref.watch(allStationsProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF1A1A1A),
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Column(
          children: [
            Text(
              'فهرست خطوط',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'LINES LIST',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: allStationsAsync.when(
        data: (stations) {
          final lineData = _prepareLineData(stations);

          if (lineData.isEmpty) {
            return const Center(
              child: Text(
                'هیچ خطی یافت نشد',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: lineData.length,
            itemBuilder: (context, index) {
              final data = lineData[index];
              return LineCard(
                lineNumber: data['lineNumber'],
                lineColor: data['color'],
                firstStation: data['firstStation'],
                lastStation: data['lastStation'],
                firstStationEn: data['firstStationEn'],
                lastStationEn: data['lastStationEn'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LineDetailPage(
                        lineNumber: data['lineNumber'],
                        lineColor: data['color'],
                        lineName:
                            '${data['firstStation']} / ${data['lastStation']}',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'خطا در بارگذاری اطلاعات',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _prepareLineData(List<StationModel> stations) {
    final result = <Map<String, dynamic>>[];

    final linesSet = <int>{};
    for (var station in stations) {
      linesSet.addAll(station.lines);
    }
    final lines = linesSet.toList()..sort();

    for (final lineNumber in lines) {
      final lineStations = stations
          .where((station) => station.lines.contains(lineNumber))
          .toList();

      if (lineStations.isEmpty) continue;

      lineStations.sort((a, b) {
        final posA = a.getPositionInLine(lineNumber) ?? 0;
        final posB = b.getPositionInLine(lineNumber) ?? 0;
        return posA.compareTo(posB);
      });

      final firstStation = lineStations.first;
      final lastStation = lineStations.last;

      final colorString = firstStation.colors.isNotEmpty
          ? firstStation.colors.first
          : '#87CEEB';

      result.add({
        'lineNumber': lineNumber,
        'color': _parseColor(colorString),
        'firstStation': firstStation.translations['fa'] ?? firstStation.name,
        'lastStation': lastStation.translations['fa'] ?? lastStation.name,
        'firstStationEn': firstStation.name,
        'lastStationEn': lastStation.name,
        'stationCount': lineStations.length,
      });
    }

    return result;
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade700,
                  Colors.deepPurple.shade500,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),

                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.subway,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'مشهد مترو',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
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
                          'MASHHAD METRO',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.view_list_rounded,
                  title: 'فهرست خطوط',
                  subtitle: 'LINE LIST',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                _buildDrawerItem(
                  context: context,
                  icon: Icons.map_outlined,
                  title: 'نقشه',
                  subtitle: 'MAP',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapPage()),
                    );
                  },
                ),

                _buildDrawerItem(
                  context: context,
                  icon: Icons.info_outline,
                  title: 'درباره ما',
                  subtitle: 'ABOUT US',
                  onTap: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('این صفحه بزودی اضافه میشود'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.deepPurple.shade300,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
