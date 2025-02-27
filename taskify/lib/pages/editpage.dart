import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taskify/pages/todolist.dart';

class Editpage extends ConsumerStatefulWidget {
  final Todolist task;
  const Editpage({super.key, required this.task});

  @override
  _EditpageState createState() => _EditpageState();
}

class _EditpageState extends ConsumerState<Editpage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? dueDate;
  TimeOfDay? dueTime;
  late String priority;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    dueDate = widget.task.dueDate;
    dueTime = widget.task.dueTime;
    priority = widget.task.priority;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveTask() {
    final updatedTask = widget.task.copyWith(
      title: titleController.text,
      description: descriptionController.text,
      dueDate: dueDate,
      dueTime: dueTime,
      completed: widget.task.completed,
      priority: priority
    );

    ref.read(todoProvider.notifier).updTask(updatedTask);

    Navigator.pop(context);
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  Future<void> selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        dueTime = picked;
      });
    }
  }

  Future<void> selectDateNew() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  Future<void> selectTimeNew() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        dueTime = picked;
      });
    }
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
                child: Text('Edit Task',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: const Text(
                  'Title',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  Icon(
                    Icons.calendar_month,
                    size: 20,
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(dueDate == null
                          ? "Select Due Date"
                          : DateFormat('EEEE, d  MMMM').format(dueDate!)),
                      trailing: const Icon(Icons.edit),
                      onTap: selectDateNew,
                    ),
                  ),
                ],
              ),


              
            Row(
              children: [
                Icon(Icons.timer, size: 20,),
                

                Expanded(
                  child: ListTile(
                    title: Text(dueTime == null
                        ? 'Select Due Time'
                        : dueTime!.format(context)),
                    trailing: Icon(Icons.edit),
                    onTap: selectTimeNew,
                  ),
                ),
              ],
            ),

             const SizedBox(height: 10),
            const Text(
              'Priority: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                priorityRadio("low"),
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
            onPressed: saveTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              'save changes',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),);
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
