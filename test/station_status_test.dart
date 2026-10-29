import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mashhad_metro/widgets/station_status.dart';

void main() {
  testWidgets('unavailable badge identifies a disabled station', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StationUnavailableBadge())),
    );

    expect(find.text('غیرفعال'), findsOneWidget);
    expect(find.byIcon(Icons.block), findsOneWidget);
  });

  testWidgets('unavailable notice explains the station status', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StationUnavailableNotice())),
    );

    expect(find.text('ایستگاه غیرفعال است'), findsOneWidget);
    expect(find.text('این ایستگاه در حال حاضر در دسترس نیست.'), findsOneWidget);
    expect(find.byIcon(Icons.subway), findsOneWidget);
  });
}
