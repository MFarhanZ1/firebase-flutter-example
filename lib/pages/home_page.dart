import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // call firestore services
  final FirestoreService firestoreService = FirestoreService();

  // get value of text field note
  final TextEditingController textController = TextEditingController();

  void openNotedBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          TextButton(
              onPressed: () => {
                    if (docID == null) {
                      // adding new note
                      firestoreService.addNote(textController.text),
                    } else {
                      // updating existing note
                      firestoreService.updateNote(docID, textController.text),
                    },

                    // clearing text controller
                    textController.clear(),

                    // close the alert modal pop up
                    Navigator.pop(context),
                  },
              child: const Text('Save')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List App'),
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {openNotedBox()},
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  String noteText = data['note'];

                  return Container(
                    color: Colors.amber,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit), onPressed: () {
                                openNotedBox(docID: docID);
                          }),
                          IconButton(
                              icon: const Icon(Icons.delete), onPressed: () {
                                firestoreService.deleteNote(docID);
                          }),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
