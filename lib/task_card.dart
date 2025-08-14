import 'package:flutter/material.dart';

// This widget represents a single, self-contained task card.
class TaskCard extends StatelessWidget {
  final String taskTitle;
  final bool isCompleted;

  // The constructor requires a title and completion status for each card.
  const TaskCard({
    super.key,
    required this.taskTitle,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    // A Material widget gives us the nice "lifting" effect when we drag it.
    return Material(
      color: Colors.transparent,
      // The main container for the card.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          // A slightly lighter shade of dark gray to stand out from the background.
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            // The checkbox icon.
            Icon(
              isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
              color: isCompleted ? Colors.green : const Color(0xFF007BFF),
            ),
            const SizedBox(width: 10), // A small space between the icon and text.
            // The Expanded widget ensures the text doesn't overflow the screen.
            Expanded(
              child: Text(
                taskTitle,
                style: TextStyle(
                  color: isCompleted ? Colors.white54 : Colors.white,
                  decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
