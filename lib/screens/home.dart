import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/screens/add_task.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userId = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                FirebaseAuth.instance.signOut();
              }),
        ],
        centerTitle: true,
        title: const Text("To-Do List"),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(userId)
              .collection('mytasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var time = (docs[index]['timeStamp'] as Timestamp).toDate();
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        isThreeLine: true,
                        title: Text(
                            '${docs[index]['title']}  \n'),
                        subtitle: Text('${DateFormat.yMd().add_jm().format(time)} \n${docs[index]['description']}'),
                        trailing: InkWell(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(userId)
                                .collection('mytasks')
                                .doc(docs[index]['time'])
                                .delete();
                          },
                          child: const Icon(Icons.delete),

                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTask()));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
