import 'package:flutter/material.dart';
import '../models/station_model.dart';
import 'package:mashhad_metro/pages/station_details.dart';

class StationItem extends StatelessWidget {
  final StationModel station;
  final int currentLineNumber;
  final Color currentLineColor;
  final bool isFirst;
  final bool isLast;
  final List<StationModel> allStations;

  const StationItem({
    super.key,
    required this.station,
    required this.currentLineNumber,
    required this.currentLineColor,
    required this.isFirst,
    required this.isLast,
    required this.allStations,
  });

  @override
  Widget build(BuildContext context) {
    final otherLines = station.lines
        .where((line) => line != currentLineNumber)
        .toList();
    final hasTransfer = otherLines.isNotEmpty;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            currentLineColor.withOpacity(0.3),
                            currentLineColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 8),

                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentLineColor,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: currentLineColor.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: hasTransfer
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            currentLineColor,
                            currentLineColor.withOpacity(0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 8),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StationDetail(stationName: station.name),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(16),
                      border: hasTransfer
                          ? Border.all(
                              color: currentLineColor.withOpacity(0.3),
                              width: 2,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (station.nearHolyshrine)
                                      Text(
                                        "${station.translations['fa']} 🕌",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          height: 1.4,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Text(
                                        station.translations['fa'] ??
                                            station.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          height: 1.4,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 4),

                                    Text(
                                      station.name.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white.withOpacity(0.3),
                                size: 16,
                              ),
                            ],
                          ),

                          if (hasTransfer) ...[
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: otherLines.map((lineNum) {
                                final lineColor = _getLineColor(lineNum);
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        lineColor,
                                        lineColor.withOpacity(0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: lineColor.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.swap_horiz_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'خط $lineNum',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black26,
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getLineColor(int lineNumber) {
    final lineStations = allStations
        .where((s) => s.lines.contains(lineNumber))
        .toList();

    if (lineStations.isEmpty) {
      return Colors.blue;
    }

    lineStations.sort((a, b) {
      final posA = a.getPositionInLine(lineNumber) ?? 0;
      final posB = b.getPositionInLine(lineNumber) ?? 0;
      return posA.compareTo(posB);
    });

    final firstStation = lineStations.first;
    final colorString = firstStation.colors.isNotEmpty
        ? firstStation.colors.first
        : '#87CEEB';

    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }
}
