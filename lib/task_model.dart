// A simple class to represent a Task.
class Task {
  final String id;
  String title;
  int quadrant; // 0: Inbox, 1-4: Quadrants
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.quadrant = 0, // All new tasks start in the inbox
    this.isCompleted = false,
  });
}
