// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:taskify/pages/editpage.dart';
import 'package:taskify/pages/todolist.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void addToList() {
    Navigator.pushNamed(context, '/addtolist');
  }

  Future<bool> onWillPop() async {
    // Show a dialog to confirm exit
    bool exitConfirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Exit Taskify?'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Don't exit
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Exit the app
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if the dialog is dismissed without action
    return exitConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoProvider); // Listening to the state
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                bool exitConfirmed = await onWillPop();
                if (exitConfirmed) {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.exit_to_app,
                size: 30,
                color: Colors.blueAccent,
              ),
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.notes_rounded, size: 50, color: Colors.blueAccent,),

              const Text(
              'Taskify',
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),
            ],
          )

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addToList,
          backgroundColor: Colors.blueAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: todoList.isEmpty
            ? Center(
                child: Text(
                  'Welcome to Taskify\nAdd a task to get started!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final task = todoList[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.blueAccent,
                          checkColor: Colors.white,
                          value: task.completed,
                          onChanged: (_) {
                            ref
                                .read(todoProvider.notifier)
                                .toggleTaskCompletion(task.id);
                          },
                        ),
                        Expanded(
                          child: Slidable(
                            endActionPane:
                                ActionPane(motion: StretchMotion(), children: [
                              SlidableAction(
                                onPressed: (_) {
                                  Slidable.of(context)?.close();
                                  ref
                                      .read(todoProvider.notifier)
                                      .removeTask(task.id);
                                  // Show an error message if the fields are empty
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        elevation: 0,
                                        content: Text(
                                            '${task.title} just got deleted'),
                                        action: SnackBarAction(
                                            label: 'undo',
                                            onPressed: () {
                                              ref
                                                  .read(todoProvider.notifier)
                                                  .renewTask(task.id);
                                            })),
                                  );
                                  return;
                                },
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              )
                            ]),
                            child: Expanded(
                              child: ListTile(
                                selectedTileColor: Colors.black,
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: task.completed
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.description,
                                      style: TextStyle(
                                          decoration: task.completed
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Due: ${DateFormat('EEE, d MMM').format(task.dueDate)} at ${task.dueTime.format(context)}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text('Priority: ${task.priority}',
                                        style: TextStyle(
                                          color: task.priority == 'High'
                                              ? Colors.red
                                              : (task.priority == "Medium"
                                                  ? Colors.orange
                                                  : Colors.green),
                                        ))
                                  ],
                                ),
                                trailing: Icon(Icons.edit),
                                onTap: () {
                                  Slidable.of(context)?.close();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Editpage(task: task)));
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
