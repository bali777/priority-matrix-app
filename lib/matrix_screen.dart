import 'package:flutter/material.dart';
import 'task_card.dart'; // We will create this file next
import 'task_model.dart'; // And this one too

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});

  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen> {
  // The "state" of our app: a list of all tasks.
  final List<Task> _tasks = [
    // Some sample tasks to start with
    Task(id: '1', title: 'Plan the Q4 product launch', quadrant: 1),
    Task(id: '2', title: 'Respond to important emails', quadrant: 2),
    Task(id: '3', title: 'Call back the client', quadrant: 2, isCompleted: true),
    Task(id: '4', title: 'Organize desktop files', quadrant: 4),
  ];

  // Logic to add a new task
  void _addTask() {
    setState(() {
      final newTask = Task(
        id: DateTime.now().toString(), // A unique ID based on the current time
        title: 'New Task', // A default title
        quadrant: 0, // Starts in the "Inbox" quadrant
      );
      _tasks.add(newTask);
    });
  }

  // Logic for when a drag-and-drop is successfully completed
  void _onTaskDrop(String taskId, int newQuadrant) {
    setState(() {
      // Find the task that was dropped and update its quadrant
      _tasks.firstWhere((task) => task.id == taskId).quadrant = newQuadrant;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Priority Matrix'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask, // Connect the button to our add task logic
        backgroundColor: const Color(0xFF007BFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Top Row
          Expanded(
            child: Row(
              children: [
                _buildQuadrant(title: 'High Impact / Difficult', quadrant: 1),
                _buildQuadrant(title: 'High Impact / Easy', quadrant: 2),
              ],
            ),
          ),
          // Bottom Row
          Expanded(
            child: Row(
              children: [
                _buildQuadrant(title: 'Low Impact / Difficult', quadrant: 3),
                _buildQuadrant(title: 'Low Impact / Easy', quadrant: 4),
              ],
            ),
          ),
          // Inbox Area for new tasks
          _buildQuadrant(title: 'INBOX', quadrant: 0, isInbox: true),
        ],
      ),
    );
  }

  // This is the final, fully interactive quadrant widget
  Widget _buildQuadrant({required String title, required int quadrant, bool isInbox = false}) {
    // Filter the list of tasks to get only the ones for this quadrant
    final quadrantTasks = _tasks.where((task) => task.quadrant == quadrant).toList();

    // The DragTarget allows this area to accept draggable items
    return DragTarget<String>(
      onWillAccept: (data) => true, // Allows any draggable to be dropped here
      onAccept: (taskId) => _onTaskDrop(taskId, quadrant), // The logic to run on success
      builder: (context, candidateData, rejectedData) {
        return Expanded(
          flex: isInbox ? 0 : 1, // Inbox doesn't expand like the main quadrants
          child: Container(
            height: isInbox ? 120 : double.infinity,
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF007BFF).withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8.0),
              color: candidateData.isNotEmpty ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: quadrantTasks.length,
                    itemBuilder: (context, index) {
                      final task = quadrantTasks[index];
                      // We wrap the TaskCard in a Draggable widget
                      return Draggable<String>(
                        data: task.id, // The data that gets passed on drop (the task's unique ID)
                        feedback: SizedBox(width: 200, child: TaskCard(taskTitle: task.title)), // What the card looks like while dragging
                        child: TaskCard(taskTitle: task.title, isCompleted: task.isCompleted),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
