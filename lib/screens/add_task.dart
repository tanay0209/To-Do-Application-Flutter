import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  addTaskToFirebase() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(userId)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': taskTitleController.text,
      'description': taskDescriptionController.text,
      'time': time.toString(),
      'timeStamp': time
    });
    taskTitleController.text = '';
    taskDescriptionController.text = '';
    Fluttertoast.showToast(msg: "Task Added");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            controller: taskTitleController,
            decoration: const InputDecoration(
                label: Text("Enter Title"), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: taskDescriptionController,
            decoration: const InputDecoration(
                label: Text("Enter Description"), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                addTaskToFirebase();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(12.0)),
                shape: MaterialStateProperty.all(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                backgroundColor: MaterialStateProperty.resolveWith(
                    <Color>(Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.purple.shade100;
                  }
                  return Theme.of(context).primaryColor;
                }),
              ),
              child: Text(
                "Add Task",
                style: GoogleFonts.roboto(fontSize: 18),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
