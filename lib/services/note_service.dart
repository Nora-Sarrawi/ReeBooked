import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebooked_app/models/note_model.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Note>> getNotes(String swapId) {
    return _firestore
        .collection('swaps')
        .doc(swapId)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }

  Future<void> addNote(String swapId, Note note) async {
    await _firestore.collection('swaps').doc(swapId).collection('notes').add(note.toJson());
  }
}
