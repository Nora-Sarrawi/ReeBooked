import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String senderId;
  final String message;
  final Timestamp createdAt;

  Note({
    required this.id,
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      message: data['message'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
