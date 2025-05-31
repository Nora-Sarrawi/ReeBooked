import 'package:cloud_firestore/cloud_firestore.dart';

class SwapNotification {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatarUrl;
  final String recipientId;
  final String text;
  final DateTime createdAt;
  final bool read;

  SwapNotification({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.recipientId,
    required this.text,
    required this.createdAt,
    this.read = false,
  });

  factory SwapNotification.fromMap(String id, Map<String, dynamic> data) {
    return SwapNotification(
      id: id,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String,
      senderAvatarUrl: data['senderAvatarUrl'] as String,
      recipientId: data['recipientId'] as String,
      text: data['text'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      read: data['read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatarUrl': senderAvatarUrl,
        'recipientId': recipientId,
        'text': text,
        'createdAt': createdAt,
        'read': read,
      };
}
