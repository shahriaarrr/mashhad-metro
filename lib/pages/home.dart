import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mashhad_metro/providers/station_provider.dart';
import 'package:mashhad_metro/models/station_model.dart';
import 'package:mashhad_metro/widgets/line_card.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStationsAsync = ref.watch(allStationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
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
                onTab: () {
                  print('خط ${data['lineNumber']} کلیک شد');
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
}
