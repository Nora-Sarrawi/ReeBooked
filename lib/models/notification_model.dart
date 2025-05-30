import 'package:cloud_firestore/cloud_firestore.dart';

class SwapNotification {
  final String id; // document ID
 
  final String requestId; // which swap this lives under
  final String senderId; // who sent it
  final String senderName;
  final String senderAvatarUrl;
  final String text;

  final DateTime createdAt;
  final bool read;

  SwapNotification({
    required this.id,
    required this.requestId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,

    required this.text,
    required this.createdAt,
    this.read = false,
  });

  factory SwapNotification.fromMap(String id, Map<String, dynamic> data) {
    return SwapNotification(
      id: id,
      requestId: data['requestId'] as String,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String,
      senderAvatarUrl: data['senderAvatarUrl'] as String,

      text: data['text'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      read: data['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'requestId': requestId,
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatarUrl': senderAvatarUrl,

        'text': text,
        'createdAt': createdAt,
        'read': read,
      };
}
