// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/pages/todolist.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddToList extends ConsumerStatefulWidget {
  const AddToList({super.key});

  @override
  _AddToListState createState() => _AddToListState();
}

class _AddToListState extends ConsumerState<AddToList> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? dueDate;
  TimeOfDay? dueTime;
  String priority = "Low";

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  Future<void> selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        dueTime = picked;
      });
    }
  }

  void addTask() async{
    final title = titleController.text;
    final description = descriptionController.text;
    priority = priority;

    if (title.isEmpty ||
        description.isEmpty ||
        dueDate == null ||
        dueTime == null) {
      // Show an error message if the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(title.isEmpty ? 'Title is required' : description.isEmpty ? 'Description is required': dueDate == null ? 'Due Date is required' : "Due Time is required") ),
      );
      return;
    }

    // Add the task
    final task = Todolist(
      title: title,
      id: Uuid().v4(),
      completed: false, // Start as incomplete
      description: description,
      dueDate: dueDate!,
      dueTime: dueTime!,
      priority: priority,
    );

    ref.read(todoProvider.notifier).addTask(task);

    // Go back to the homepage
  Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(13.0),
              child: Text(
                'Add a task',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'What is the task about?',
              ),
              maxLength: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Describe the task in detail',
              ),
              maxLength: 200,
            ),

            // due date picker
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Icon(Icons.calendar_month, size: 20,),

                Expanded(
                  child: ListTile(
                    title: Text(dueDate == null
                        ? "Select Due Date"
                        : DateFormat('EEEE, d  MMMM').format(dueDate!)),
                    trailing: const Icon(Icons.edit),
                    onTap: selectDate,
                  ),
                ),
              ],
            ),

            // due time picker

            Row(
              children: [
                Icon(Icons.timer, size: 20,),
                

                Expanded(
                  child: ListTile(
                    title: Text(dueTime == null
                        ? 'Select Due Time'
                        : dueTime!.format(context)),
                    trailing: Icon(Icons.edit),
                    onTap: selectTime,
                  ),
                ),
              ],
            ),

            //priority Selection
            Expanded(child: const SizedBox(height: 10)),
            const Text(
              'Priority: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                priorityRadio("Low"),
                priorityRadio("Medium"),
                priorityRadio("High"),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: addTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              'Add Task',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget priorityRadio(String value) {
    return Row(children: [
      Radio(
        groupValue: priority,
        value: value,
        onChanged: (String? newValue) {
          setState(() {
            priority = newValue!;
          });
        },
      ),
      Text(value)
    ]);
  }
}
