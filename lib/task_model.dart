import 'package:flutter/material.dart' show Color;

/// A single task (to-do item) in the priority matrix.
class Task {
  Task({
    required this.id,
    required this.title,
    this.quadrant = TaskQuadrant.inbox,
    this.isCompleted = false,
  });

  /// Unique identifier for this task.
  final String id;

  /// Short description shown on the card.
  final String title;

  /// Where the task currently sits on the board.
  final TaskQuadrant quadrant;

  /// Whether the task has been finished.
  final bool isCompleted;

  /// Returns a copy of this task with the given fields replaced.
  Task copyWith({String? title, TaskQuadrant? quadrant, bool? isCompleted}) {
    return Task(
      id: id,
      title: title ?? this.title,
      quadrant: quadrant ?? this.quadrant,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// The areas a task can live in.
///
/// The board is an impact/effort matrix:
///
///   ┌─────────────────────┬─────────────────────┐
///   │ 1. High impact /    │ 2. High impact /    │
///   │    difficult        │    easy             │
///   ├─────────────────────┼─────────────────────┤
///   │ 3. Low impact /     │ 4. Low impact /     │
///   │    difficult        │    easy             │
///   └─────────────────────┴─────────────────────┘
///
/// New tasks start in the [inbox] strip below the matrix.
enum TaskQuadrant {
  inbox('Inbox', 'New, unsorted tasks'),
  highImpactDifficult('High Impact / Difficult', 'Big bets — plan these'),
  highImpactEasy('High Impact / Easy', 'Quick wins — do these first'),
  lowImpactDifficult('Low Impact / Difficult', 'Time sinks — avoid or delegate'),
  lowImpactEasy('Low Impact / Easy', 'Filler — do them if time allows');

  const TaskQuadrant(this.label, this.hint);

  /// Heading shown above the quadrant.
  final String label;

  /// Short explanation of what belongs in the quadrant.
  final String hint;

  /// Accent colour used for the quadrant header.
  Color get accentColor {
    switch (this) {
      case TaskQuadrant.inbox:
        return const Color(0xFF007BFF); // Electric blue.
      case TaskQuadrant.highImpactDifficult:
        return const Color(0xFFFF6B6B); // Coral red.
      case TaskQuadrant.highImpactEasy:
        return const Color(0xFF4ECDC4); // Teal.
      case TaskQuadrant.lowImpactDifficult:
        return const Color(0xFFFFD93D); // Yellow.
      case TaskQuadrant.lowImpactEasy:
        return const Color(0xFF9B59B6); // Purple.
    }
  }
}
