import 'package:flutter/material.dart';

const stationUnavailableColor = Color(0xFFFFC46B);

class StationUnavailableIcon extends StatelessWidget {
  final double size;

  const StationUnavailableIcon({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Center(
              child: Icon(Icons.subway, color: Colors.white, size: size * 0.62),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.block,
                color: stationUnavailableColor,
                size: size * 0.48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StationUnavailableBadge extends StatelessWidget {
  const StationUnavailableBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'ایستگاه غیرفعال است',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: stationUnavailableColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: stationUnavailableColor.withValues(alpha: 0.55),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block, color: stationUnavailableColor, size: 15),
              SizedBox(width: 5),
              Text(
                'غیرفعال',
                style: TextStyle(
                  color: stationUnavailableColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StationUnavailableNotice extends StatelessWidget {
  const StationUnavailableNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'وضعیت ایستگاه: غیرفعال. این ایستگاه در حال حاضر در دسترس نیست.',
      child: ExcludeSemantics(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: stationUnavailableColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: stationUnavailableColor.withValues(alpha: 0.45),
            ),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ایستگاه غیرفعال است',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: stationUnavailableColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'این ایستگاه در حال حاضر در دسترس نیست.',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              StationUnavailableIcon(size: 36),
            ],
          ),
        ),
      ),
    );
  }
}
