import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priority_matrix_app/main.dart';
import 'package:priority_matrix_app/task_model.dart';

void main() {
  testWidgets('app renders the matrix board with sample tasks', (
    tester,
  ) async {
    await tester.pumpWidget(const PriorityMatrixApp());

    expect(find.text('Priority Matrix'), findsOneWidget);
    expect(find.text('HIGH IMPACT / DIFFICULT'), findsOneWidget);
    expect(find.text('HIGH IMPACT / EASY'), findsOneWidget);
    expect(find.text('LOW IMPACT / DIFFICULT'), findsOneWidget);
    expect(find.text('LOW IMPACT / EASY'), findsOneWidget);
    expect(find.text('INBOX'), findsOneWidget);
    expect(find.text('Plan the Q4 product launch'), findsOneWidget);
    expect(find.text('Respond to important emails'), findsOneWidget);
    expect(find.text('Organize desktop files'), findsOneWidget);
  });

  testWidgets('tapping the checkbox toggles a task', (tester) async {
    await tester.pumpWidget(const PriorityMatrixApp());

    // 'Call back the client' is the only completed sample task.
    expect(find.byIcon(Icons.check_box), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check_box));
    await tester.pumpAndSettle();

    // It is now unchecked: no filled boxes remain on the board.
    expect(find.byIcon(Icons.check_box), findsNothing);
    expect(
      find.byIcon(Icons.check_box_outline_blank),
      findsNWidgets(4),
    );
  });

  testWidgets('the new task dialog validates empty titles', (tester) async {
    await tester.pumpWidget(const PriorityMatrixApp());

    await tester.tap(find.text('New Task'));
    await tester.pumpAndSettle();

    expect(find.text('New Task'), findsWidgets);
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.text('Please enter a title'), findsOneWidget);
  });

  testWidgets('task model copyWith replaces only given fields', (tester) async {
    final task = Task(id: 't1', title: 'Original');
    final renamed = task.copyWith(title: 'Renamed');

    expect(renamed.id, 't1');
    expect(renamed.title, 'Renamed');
    expect(renamed.quadrant, TaskQuadrant.inbox);
    expect(renamed.isCompleted, isFalse);
    expect(task.title, 'Original'); // Immutable original stays untouched.
  });
}
