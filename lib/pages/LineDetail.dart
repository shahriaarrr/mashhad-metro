import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mashhad_metro/providers/station_provider.dart';
import 'package:mashhad_metro/widgets/stationItem.dart';

class LineDetailPage extends ConsumerWidget {
  final int lineNumber;
  final Color lineColor;
  final String lineName;

  const LineDetailPage({
    super.key,
    required this.lineNumber,
    required this.lineColor,
    required this.lineName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(stationsByLineProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: lineColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lineColor, lineColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'خط $lineNumber - $lineName',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'LINE $lineNumber',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          stationsAsync.when(
            data: (allStations) {
              final lineStations = allStations
                  .where((station) => station.lines.contains(lineNumber))
                  .toList();

              lineStations.sort((a, b) {
                final posA = a.getPositionInLine(lineNumber) ?? 0;
                final posB = b.getPositionInLine(lineNumber) ?? 0;

                return posA.compareTo(posB);
              });

              return SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final station = lineStations[index];
                    final isFirst = index == 0;
                    final isLast = index == lineStations.length - 1;

                    return StationItem(
                      station: station,
                      currentLineNumber: lineNumber,
                      currentLineColor: lineColor,
                      isFirst: isFirst,
                      isLast: isLast,
                      allStations: allStations,
                    );
                  }, childCount: lineStations.length),
                ),
              );
            },

            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),

            error: (error, _) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'خطا در بارگزاری ایستگاه های خط $lineNumber',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
