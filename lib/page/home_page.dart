import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  void openDialogBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docId == null) {
                        firestoreService.addNote(textController.text);
                      } else {
                        firestoreService.updateNote(docId, textController.text);
                      }

                      textController.clear();
                      Navigator.pop(context);
                    },
                    child: Text("add"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: openDialogBox,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // eğer data varsa hepsini al
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;
            // listeyi göster
            return ListView.builder(
                itemCount: noteList.length,
                itemBuilder: (context, index) {
                  // her bir belgeyi al

                  DocumentSnapshot document = noteList[index];
                  String docId = document.id;

                  // her belgeden not alın
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  // başlıkların gösterilmesi
                  return ListTile(
                      title: Text(
                        noteText,
                        maxLines: 2, // sadece iki satır göster
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize
                            .min, // bunu eklemezsen diğer buton gelmez
                        children: [
                          IconButton(
                            onPressed: () => openDialogBox(docId: docId),
                            icon: const Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () => firestoreService.deleteNote(docId),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ));
                });
          } else {
            return const Text("No notes");
          }
        },
      ),
    );
  }
}
