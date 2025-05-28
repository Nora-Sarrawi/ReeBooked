import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebooked_app/models/notification_model.dart';
import '../models/notification_model.dart';

class NotificationService {
  final _db = FirebaseFirestore.instance;

  // Once your collection exists, listen here
  Stream<List<SwapNotification>> streamNotifications(
      {bool onlyUnread = false}) {
    var col =
        _db.collection('notifications').orderBy('createdAt', descending: true);
    if (onlyUnread) {
      col = col.where('read', isEqualTo: false);
    }
    return col.snapshots().map((snap) => snap.docs
        .map((doc) => SwapNotification.fromMap(doc.id, doc.data()))
        .toList());
  }

  // Mark as read
  Future<void> markAsRead(String id) =>
      _db.collection('notifications').doc(id).update({'read': true});
}
