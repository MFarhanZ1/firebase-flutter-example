import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection notes in firestore
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // POST: add a new note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // GET: get all notes
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // PUT: update a note
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE: delete a note
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
