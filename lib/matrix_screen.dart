import 'package:flutter/material.dart';

import 'task_card.dart';
import 'task_model.dart';

/// The main board: a 2×2 impact/effort matrix plus an inbox strip.
///
/// Tasks can be added through the FAB, dragged between quadrants, toggled
/// complete, edited and deleted.
class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});

  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen> {
  final List<Task> _tasks = [
    Task(
      id: 'sample-1',
      title: 'Plan the Q4 product launch',
      quadrant: TaskQuadrant.highImpactDifficult,
    ),
    Task(
      id: 'sample-2',
      title: 'Respond to important emails',
      quadrant: TaskQuadrant.highImpactEasy,
    ),
    Task(
      id: 'sample-3',
      title: 'Call back the client',
      quadrant: TaskQuadrant.highImpactEasy,
      isCompleted: true,
    ),
    Task(
      id: 'sample-4',
      title: 'Organize desktop files',
      quadrant: TaskQuadrant.lowImpactEasy,
    ),
  ];

  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- actions

  Task? _taskById(String id) {
    for (final task in _tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  void _addOrMoveTask(Task task, {bool isNew = false}) {
    setState(() {
      if (isNew) {
        _tasks.add(task);
      } else {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = task;
        }
      }
    });
  }

  void _toggleCompleted(Task task, bool value) {
    _addOrMoveTask(task.copyWith(isCompleted: value));
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.removeWhere((t) => t.id == task.id);
    });
  }

  /// Called when a card is dropped on a quadrant.
  void _onTaskDropped(String taskId, TaskQuadrant target) {
    final task = _taskById(taskId);
    if (task == null || task.quadrant == target) {
      return;
    }
    _addOrMoveTask(task.copyWith(quadrant: target));
  }

  // ---------------------------------------------------------------- dialogs

  Future<void> _showAddTaskDialog() async {
    _titleController.clear();
    final result = await showDialog<_TaskDialogResult>(
      context: context,
      builder: (context) =>
          _TaskDialog(controller: _titleController, isEditing: false),
    );
    if (result == null) {
      return;
    }
    _addOrMoveTask(
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: result.title,
        quadrant: result.quadrant,
      ),
      isNew: true,
    );
  }

  Future<void> _showEditTaskDialog(Task task) async {
    _titleController.text = task.title;
    final result = await showDialog<_TaskDialogResult>(
      context: context,
      builder: (context) => _TaskDialog(
        controller: _titleController,
        isEditing: true,
        initialQuadrant: task.quadrant,
        initialCompleted: task.isCompleted,
      ),
    );
    if (result == null) {
      return;
    }
    if (result.delete) {
      _deleteTask(task);
    } else {
      _addOrMoveTask(
        task.copyWith(
          title: result.title,
          quadrant: result.quadrant,
          isCompleted: result.isCompleted,
        ),
      );
    }
  }

  Future<void> _confirmDelete(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF6B6B)),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _deleteTask(task);
    }
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Priority Matrix'),
        actions: [
          IconButton(
            tooltip: 'About this board',
            icon: const Icon(Icons.info_outline),
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
      body: Column(
        children: [
          // The 2×2 matrix.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildQuadrantCell(TaskQuadrant.highImpactDifficult),
                        _buildQuadrantCell(TaskQuadrant.highImpactEasy),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildQuadrantCell(TaskQuadrant.lowImpactDifficult),
                        _buildQuadrantCell(TaskQuadrant.lowImpactEasy),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Inbox strip for new, unsorted tasks.
          _buildInbox(),
        ],
      ),
    );
  }

  /// One cell of the 2×2 matrix.
  ///
  /// The [Expanded] must wrap the [DragTarget] (a DragTarget builder may not
  /// return ParentDataWidgets such as Expanded — that was the bug that made
  /// the previous version crash on launch).
  Widget _buildQuadrantCell(TaskQuadrant quadrant) {
    return Expanded(
      child: _buildDropZone(quadrant),
    );
  }

  /// Shared DragTarget used by both the matrix cells and the inbox.
  Widget _buildDropZone(TaskQuadrant quadrant, {double? height}) {
    final tasks =
        _tasks.where((task) => task.quadrant == quadrant).toList();
    return SizedBox(
      height: height,
      child: DragTarget<String>(
        onWillAcceptWithDetails: (details) =>
            _taskById(details.data)?.quadrant != quadrant,
        onAcceptWithDetails: (details) =>
            _onTaskDropped(details.data, quadrant),
        builder: (context, candidateData, rejectedData) {
          final highlighted = candidateData.isNotEmpty;
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: highlighted
                    ? quadrant.accentColor
                    : Color(0x33007BFF),
                width: highlighted ? 2 : 1,
              ),
              color: highlighted ? const Color(0x14FFFFFF) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildQuadrantHeader(quadrant, tasks.length),
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: Text(
                            'Drop tasks here',
                            style: const TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : _buildTaskList(quadrant, tasks),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuadrantHeader(TaskQuadrant quadrant, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: quadrant.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              quadrant.label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(fontSize: 11, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(TaskQuadrant quadrant, List<Task> tasks) {
    final horizontal = quadrant == TaskQuadrant.inbox;
    return ListView.builder(
      scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final card = TaskCard(
          task: task,
          compact: horizontal,
          onToggleCompleted: (value) => _toggleCompleted(task, value),
          onTap: () => _showEditTaskDialog(task),
          onLongPress: () => _confirmDelete(task),
        );
        return Draggable<String>(
          data: task.id,
          feedback: SizedBox(
            width: horizontal ? 220 : 240,
            child: TaskCard(task: task, compact: horizontal),
          ),
          childWhenDragging: Opacity(opacity: 0.35, child: card),
          child: horizontal
              ? SizedBox(width: 216, child: card)
              : card,
        );
      },
    );
  }

  Widget _buildInbox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: _buildDropZone(TaskQuadrant.inbox, height: 108),
    );
  }

  Future<void> _showAboutDialog() async {
    final hints = TaskQuadrant.values
        .where((q) => q != TaskQuadrant.inbox)
        .map((q) => '${q.label}: ${q.hint}')
        .join('\n');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to use'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort tasks by dragging cards between quadrants. '
                'Tap a card to edit it, tap its checkbox to complete it, '
                'long-press to delete it.',
              ),
              const SizedBox(height: 12),
              Text(hints, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

/// Result of the add/edit task dialog.
class _TaskDialogResult {
  const _TaskDialogResult({
    required this.title,
    required this.quadrant,
    this.isCompleted = false,
    this.delete = false,
  });

  final String title;
  final TaskQuadrant quadrant;
  final bool isCompleted;
  final bool delete;
}

/// Dialog used for both creating and editing a task.
class _TaskDialog extends StatefulWidget {
  const _TaskDialog({
    required this.controller,
    required this.isEditing,
    this.initialQuadrant = TaskQuadrant.inbox,
    this.initialCompleted = false,
  });

  final TextEditingController controller;
  final bool isEditing;
  final TaskQuadrant initialQuadrant;
  final bool initialCompleted;

  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  late TaskQuadrant _quadrant = widget.initialQuadrant;
  late bool _completed = widget.initialCompleted;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'New Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: widget.controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  hintText: 'e.g. Prepare the weekly report',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskQuadrant>(
                value: _quadrant,
                decoration: const InputDecoration(labelText: 'Quadrant'),
                items: [
                  for (final quadrant in TaskQuadrant.values)
                    DropdownMenuItem(
                      value: quadrant,
                      child: Text(quadrant.label),
                    ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _quadrant = value);
                },
              ),
              if (isEditing) ...[
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Completed'),
                  value: _completed,
                  onChanged: (value) {
                    setState(() => _completed = value);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (isEditing)
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF6B6B),
            ),
            onPressed: () => Navigator.of(context).pop(
              const _TaskDialogResult(
                title: '',
                quadrant: TaskQuadrant.inbox,
                delete: true,
              ),
            ),
            child: const Text('Delete'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(
        _TaskDialogResult(
          title: widget.controller.text.trim(),
          quadrant: _quadrant,
          isCompleted: _completed,
        ),
      );
    }
  }
}
