import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/Modules/HomeScreen/home_screen.dart';

void main() {
  group('HomeScreen Tests', () {
    testWidgets('UNT_001: Verify Add Room button exists',
        (WidgetTester tester) async {
      // Build the HomeScreen widget.
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify the Add Room button exists by finding the '+' icon.
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Verify Add Room dialog appears and room is added dynamically',
        (WidgetTester tester) async {
      // Build the HomeScreen widget.
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Verify initial state: no rooms displayed.
      expect(find.byKey(const Key('addRoomTile')), findsOneWidget);

      // Tap the "Add Room" button.
      await tester.tap(find.byKey(const Key('addRoomTile')));
      await tester.pumpAndSettle();

      // Verify the dialog appears.
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Add Room'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter a room name.
      await tester.enterText(find.byType(TextField), 'Living Room');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify the room was added and displayed on the HomeScreen.
      expect(find.text('Living Room'), findsOneWidget);
    });

    testWidgets('Confirm Security button existence',
        (WidgetTester tester) async {
      // Build the HomeScreen widget.
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Find the Security button by its label.
      final securityButtonFinder = find.text('Security');

      // Verify that the Security button exists on the HomeScreen.
      expect(securityButtonFinder, findsOneWidget);
    });

    testWidgets(
        'Confirm Security button navigates to the Security Options dialog',
        (WidgetTester tester) async {
      // Arrange: Build the HomeScreen widget
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Act: Locate the Security button by text
      final securityButton = find.text('Security');
      expect(securityButton, findsOneWidget,
          reason: 'The Security button should exist on the HomeScreen.');

      // Tap the Security button
      await tester.tap(securityButton);
      await tester.pumpAndSettle();

      // Assert: Verify that the Security Options dialog appears
      final securityDialogTitle = find.text('Security Options');
      expect(securityDialogTitle, findsOneWidget,
          reason: 'The Security Options dialog should appear.');

      // Assert: Check that Cameras and Locks options are present
      final camerasOption = find.text('Cameras');
      final locksOption = find.text('Locks');

      expect(camerasOption, findsOneWidget,
          reason: 'Cameras option should be present in the dialog.');
      expect(locksOption, findsOneWidget,
          reason: 'Locks option should be present in the dialog.');
    });
    testWidgets('Verify navigation to the selected Room\'s screen',
        (WidgetTester tester) async {
      // Arrange: Build the HomeScreen with a room already present
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
        ),
      );

      // Act: Add a room tile to simulate existing data
      await tester.tap(find.byKey(const Key('addRoomTile')));
      await tester.pumpAndSettle();

      // Add a room name to the dialog
      await tester.enterText(find.byType(TextField), 'Living Room');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify the room tile is created
      expect(find.text('Living Room'), findsOneWidget);

      // Tap the room tile
      await tester.tap(find.text('Living Room'));
      await tester.pumpAndSettle();

      // Assert: Verify navigation to the Room's page
      expect(find.text('Room Settings'), findsOneWidget,
          reason:
              'The Room Settings page should be displayed for the selected room.');
    });
  });
}
