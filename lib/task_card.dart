import 'package:flutter/material.dart';

import 'task_model.dart';

/// A single, self-contained task card.
///
/// * Tapping the checkbox toggles completion.
/// * Tapping the card body opens the edit dialog.
/// * Long-pressing the card deletes it (after confirmation).
/// * The whole card is [Draggable] when wrapped by the parent list.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onToggleCompleted,
    this.onTap,
    this.onLongPress,
    this.compact = false,
  });

  final Task task;

  final ValueChanged<bool>? onToggleCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Inbox cards are rendered in a horizontal strip, so they are slightly
  /// more compact.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: compact ? 6 : 10,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: task.isCompleted
                  ? const Color(0x33FFFFFF)
                  : task.quadrant.accentColor,
              width: task.isCompleted ? 1 : 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onToggleCompleted?.call(!task.isCompleted),
                child: Icon(
                  task.isCompleted
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: task.isCompleted
                      ? Colors.green
                      : task.quadrant.accentColor,
                  size: compact ? 20 : 24,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 13 : 14,
                    color: task.isCompleted ? Colors.white54 : Colors.white,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
