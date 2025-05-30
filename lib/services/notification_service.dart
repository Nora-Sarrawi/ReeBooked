import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebooked_app/models/notification_model.dart';
import 'package:rebooked_app/models/notifications_summary.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Streams all notifications for a single swap (by listening to the top-level
  /// /notifications collection and filtering on requestId).
  Stream<List<SwapNotification>> streamNotifications({
    required String swapId,
    bool onlyUnread = false,
  }) {
    var col = _db
        .collection('notifications')
        .where('requestId', isEqualTo: swapId)
        .orderBy('createdAt', descending: true);

    if (onlyUnread) {
      col = col.where('read', isEqualTo: false);
    }

    return col.snapshots().map((snap) => snap.docs
        .map((doc) => SwapNotification.fromMap(doc.id, doc.data()))
        .toList());
  }

  /// Streams one summary per swap by using a collectionGroup() on the
  /// 'notifications' subcollections across all swaps.
  Stream<List<SwapNotificationSummary>> streamSummaries() {
    return _db.collectionGroup('notifications').snapshots().map((snap) {
      // Group raw notes by their parent swapId
      final bySwap = <String, List<SwapNotification>>{};
      for (var doc in snap.docs) {
        final swapId = doc.reference.parent.parent!.id;
        final note = SwapNotification.fromMap(doc.id, doc.data());
        bySwap.putIfAbsent(swapId, () => []).add(note);
      }

      // Convert each group into a summary object
      return bySwap.entries.map((entry) {
        final swapId = entry.key;
        final notes = entry.value;
        final unreadCount = notes.where((n) => !n.read).length;
        final latestNote =
            notes.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);

        return SwapNotificationSummary(
          swapId: swapId,
          senderId: latestNote.requestId, // adjust if you store senderId
          senderName: latestNote.senderName, // newly added field
          senderAvatarUrl: latestNote.senderAvatarUrl, // newly added field
          lastMessage: latestNote.text,
          lastTimestamp: latestNote.createdAt,
          unreadCount: unreadCount,
        );
      }).toList();
    });
  }

  /// Marks a single notification as read in the top-level /notifications collection.
  Future<void> markAsRead(String notificationId) {
    return _db
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true});
  }
}
