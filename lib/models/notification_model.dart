import 'package:cloud_firestore/cloud_firestore.dart';

class SwapNotification {
  final String id; // document ID
  final String requestId; // which swap request it belongs to
  final String text; // your “short note”
  final DateTime createdAt;
  final bool read;

  SwapNotification({
    required this.id,
    required this.requestId,
    required this.text,
    required this.createdAt,
    this.read = false,
  });

  factory SwapNotification.fromMap(String id, Map<String, dynamic> data) {
    return SwapNotification(
      id: id,
      requestId: data['requestId'] as String,
      text: data['text'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      read: data['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'requestId': requestId,
        'text': text,
        'createdAt': createdAt,
        'read': read,
      };
}
