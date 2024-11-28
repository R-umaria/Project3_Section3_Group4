import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:home_ease_app/Modules/hmi_interface/hmi_interface.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  group('HMIInterface Tests', () {
    // Test cases will go here.

    testWidgets('Fan Status Visualization', (WidgetTester tester) async {
      final Map<String, dynamic> simulatedData = {
        'fanStatus': 'On',
      };
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: HMIInterface(sensorData: simulatedData),
        ),
      );

      // Verify the fan status icon and text are displayed correctly
      expect(find.text('Fan Status'), findsOneWidget);
      expect(find.text('Current Status: On'), findsOneWidget);
      expect(find.byIcon(Icons.toys), findsOneWidget);
    });

    testWidgets('Temperature Graph Visualization', (WidgetTester tester) async {
      final Map<String, dynamic> simulatedData = {
        'fanStatus': 'On',
        'temperatureTrend': [22.0, 23.0, 24.0],
      };

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: HMIInterface(sensorData: simulatedData),
        ),
      );

      // Verify the temperature trend title
      expect(find.text('Temperature Trend'), findsOneWidget);

      // Verify that the graph exists
      expect(find.byType(SfCartesianChart), findsOneWidget);
    });

    testWidgets('Garage Door Visualization', (WidgetTester tester) async {
      // Arrange
      final testData = {'garageDoorOpen': true}; // Garage door should be open
      await tester
          .pumpWidget(MaterialApp(home: HMIInterface(sensorData: testData)));

      // Act
      await tester.pump();

      // Assert
      expect(find.text('Open'), findsOneWidget); // Verify "Open" is displayed
    });

    testWidgets('Blinds Visualization', (WidgetTester tester) async {
      // Arrange
      final testData = {'blindsPosition': 75.0}; // 75% open
      await tester
          .pumpWidget(MaterialApp(home: HMIInterface(sensorData: testData)));

      // Act
      await tester.pump();

      // Assert
      expect(find.text('75% Open'),
          findsOneWidget); // Verify the text is displayed
    });

    testWidgets('Lights Visualization', (WidgetTester tester) async {
      // Arrange
      final testData = {
        'lightsBrightness': 80.0,
        'lightsColor': Colors.yellow, // Simulating yellow light
      };
      await tester
          .pumpWidget(MaterialApp(home: HMIInterface(sensorData: testData)));

      // Act
      await tester.pump();

      // Assert
      expect(find.textContaining('Brightness: 80%'),
          findsOneWidget); // Verify brightness text
      expect(find.textContaining('Color: Yellow'),
          findsOneWidget); // Verify color name
    });

    testWidgets('Entertainment System Visualization',
        (WidgetTester tester) async {
      // Arrange
      final testData = {
        'tvOn': true,
        'tvChannel': 'Netflix',
      };
      await tester
          .pumpWidget(MaterialApp(home: HMIInterface(sensorData: testData)));

      // Act
      await tester.pump();

      // Assert
      // Verify the TV is on and displaying the correct channel
      expect(find.textContaining('TV On - Channel: Netflix'), findsOneWidget);

      // Update the test data for TV off state
      final testDataOff = {
        'tvOn': false,
      };
      await tester
          .pumpWidget(MaterialApp(home: HMIInterface(sensorData: testDataOff)));

      // Act
      await tester.pump();

      // Assert
      // Verify the TV is off
      expect(find.textContaining('TV Off'), findsOneWidget);
    });
  });
}
