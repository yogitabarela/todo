import 'package:flutter/material.dart';
import 'package:todo/keys/check_item.dart';

class Todo {
  const Todo(this.text, this.priority);

  final String text;
  final Priority priority;
}

class Keys extends StatefulWidget {
  const Keys({super.key});

  @override
  State<Keys> createState() {
    return _KeysState();
  }
}

class _KeysState extends State<Keys> {
  var _order = 'asc';
  final _todos = [
    const Todo(
      'Paperwork of new home',
      Priority.urgent,
    ),
    const Todo(
      'Buy Groceries',
      Priority.urgent,
    ),
    const Todo(
      'Clean the house',
      Priority.normal,
    ),
    const Todo(
      'Water the plants',
      Priority.low,
    ),
    const Todo(
      'Collect clothes for donation',
      Priority.normal,
    ),
    const Todo(
      'Pay bills',
      Priority.urgent,
    ),
    const Todo(
      'Call plumber',
      Priority.normal,
    ),
    const Todo(
      'Schedule car service',
      Priority.low,
    ),
    const Todo(
      'Read book',
      Priority.low,
    ),
    const Todo(
      'Finish car service',
      Priority.urgent,
    ),
    const Todo(
      'Finish work report',
      Priority.normal,
    ),
    const Todo(
      'Exercise',
      Priority.low,
    ),
  ];

  final TextEditingController _textController = TextEditingController();

  List<Todo> get _orderedTodos {
    final sortedTodos = List.of(
        _todos); //copy of todos so that sort doesn't change the original list but the copy only
    sortedTodos.sort((a, b) {
      final priorityComparison = a.priority.index.compareTo(b.priority.index);
      if (priorityComparison != 0) {
        return _order == 'asc' ? priorityComparison : -priorityComparison;
      }
      final textComparison = a.text.compareTo(b.text);
      return _order == 'asc' ? textComparison : -textComparison;
    });
    return sortedTodos;
  }

  void _changeOrder() {
    setState(() {
      _order = _order == 'asc' ? 'desc' : 'asc';
    });
  }

  void _addTodoItem(String text, Priority priority) {
    setState(() {
      _todos.add(Todo(
        text,
        priority,
      ));
    });
    _textController.clear(); // Clear the text field after adding the item
  }

  // Method to remove a todo item
  void _removeTodoItem(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Added TextField and IconButton to allow adding new tasks
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    labelText: 'New Task',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    _addTodoItem(_textController.text, Priority.normal);
                  }
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _changeOrder,
            icon: Icon(
              _order == 'asc' ? Icons.arrow_downward : Icons.arrow_upward,
            ),
            label: Text('Sort ${_order == 'asc' ? 'Descending' : 'Ascending'}'),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              //wrapped in dismissible to allow swipe-to-delete
              for (final todo in _orderedTodos)
                Dismissible(
                  key: ObjectKey(todo),
                  onDismissed: (direction) {
                    _removeTodoItem(todo);
                  },
                  background:
                      Container(color: Color.fromARGB(255, 177, 151, 200)),
                  child: CheckableTodoItem(
                    key: ObjectKey(
                        todo), //ValueKey is more light weight and needs to manage single value instead of entire object
                    todo.text, // use keys that are directly connected to data and are unique
                    todo.priority,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
