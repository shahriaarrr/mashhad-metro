import 'package:flutter/material.dart';
import 'package:mashhad_metro/models/station_model.dart';

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

    final stationFa = station.translations['fa'];

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
                  const SizedBox(width: 8),
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
                    print('ایستگاه ${station.name} کلیک شد');
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
                                    if (!station.nearHolyshrine)
                                      Text(
                                        stationFa ?? station.name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    else
                                      Text(
                                        "$stationFa 🕌",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                    const SizedBox(height: 4),

                                    Text(
                                      station.name.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                        letterSpacing: 0.5,
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
                              spacing: 0,
                              runSpacing: 0,
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
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
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
