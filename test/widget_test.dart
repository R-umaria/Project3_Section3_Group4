import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_ease_app/Modules/Temperature/temperature_control.dart';

void main() {
  testWidgets('TemperatureControl increments and decrements temperature',
      (WidgetTester tester) async {
    // Build TemperatureControl and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: TemperatureControl()));

    // Verify the initial temperature is 22.0°C.
    expect(find.text('Current Temperature: 22.0°C'), findsOneWidget);

    // Tap the '+' button to increase temperature.
    await tester.tap(find.text('+'));
    await tester.pump();

    // Verify the temperature increased to 23.0°C.
    expect(find.text('Current Temperature: 23.0°C'), findsOneWidget);

    // Tap the '-' button to decrease temperature.
    await tester.tap(find.text('-'));
    await tester.pump();

    // Verify the temperature returned to 22.0°C.
    expect(find.text('Current Temperature: 22.0°C'), findsOneWidget);
  });
}
