import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


part 'todolist.g.dart';




// Todolist Model
@HiveType(typeId: 0)
class Todolist extends HiveObject {

 @HiveField(0)
 final String title;


 @HiveField(1)
 final String id;

 @HiveField(2)
 final bool completed;

 @HiveField(3)
 final String description;

 @HiveField(4)
 final DateTime dueDate;

 @HiveField(5)
 final TimeOfDay dueTime;

 @HiveField(6)
 final String priority;







   Todolist({
    required this.title,
    required this.id,
    required this.completed,
    required this.description,
    required this.dueDate,
    required this.dueTime,
    required this.priority,
  });



  Todolist copyWith({
    String? title,
    String? id,
    bool? completed,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime, 
    String? priority,
  }) {
    return Todolist(
      title: title ?? this.title,
      id: id ?? this.id,
      completed: completed ?? this.completed,
      description: description ?? this.description,
      dueTime: dueTime ?? this.dueTime,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}

// Todonotifier for managing state
class Todonotifier extends StateNotifier<List<Todolist>> {
  Todonotifier() : super([]){
    loadtask();
    }
 
  final Uuid uuid = Uuid();
  late Box<Todolist> taskbox;

  Future<void> loadtask() async{
    taskbox = await Hive.openBox<Todolist>('tasks');
    state = taskbox.values.toList();
  }

  final List<Todolist> deletedTasks = [];

  // Add a new task
  void addTask(Todolist task) async{
   await taskbox.put(task.id, task);
   state = taskbox.values.toList();
  }

  // Remove a task by ID
  void removeTask(String id) async {
    final tasktToRemove = taskbox.get(id);
    if (tasktToRemove != null){
      deletedTasks.add(tasktToRemove);
      await tasktToRemove.delete();
      state= taskbox.values.toList();
    }

  }

  void renewTask(String id) async {
   final taskToRestore = deletedTasks.firstWhere((task)=> task.id == id, orElse: () => Todolist(title: '', id: '', completed: false, description: '', dueDate: DateTime.now(), dueTime: TimeOfDay.now(),  priority: 'Low'));

   if(taskToRestore.id.isNotEmpty){
    await taskbox.put(taskToRestore.id, taskToRestore);
    deletedTasks.removeWhere((task) => task.id == id);
    state = taskbox.values.toList();
   }
}

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String id) async {
    final task = taskbox.get(id);
    if (task != null) {
      final updatedTask = task.copyWith(completed: !task.completed);
      await taskbox.put(id, updatedTask);  // Update in Hive
      state = taskbox.values.toList();
    }
  }


  // Update task
  Future<void> updTask(Todolist updatedTask) async {
    if (taskbox.containsKey(updatedTask.id)) {
      await taskbox.put(updatedTask.id, updatedTask);  // Update task in Hive
      state = taskbox.values.toList();  // Update state after change
    }
  }
}





// Provider for TodoNotifier to manage list of tasks
final todoProvider = StateNotifierProvider<Todonotifier, List<Todolist>>(
  (ref) => Todonotifier(),
);
