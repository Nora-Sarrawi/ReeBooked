import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebooked_app/models/notification_model.dart';
import 'package:rebooked_app/models/notifications_summary.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Streams all notifications for a single swap
  Stream<List<SwapNotification>> streamNotifications({
    required String swapId,
    bool onlyUnread = false,
  }) {
    var query = _db
        .collection('swaps')
        .doc(swapId)
        .collection('notifications')
        .orderBy('createdAt', descending: true);

    if (onlyUnread) {
      query = query.where('read', isEqualTo: false);
    }

    return query.snapshots().map((snap) => snap.docs
        .map((doc) => SwapNotification.fromMap(doc.id, doc.data()))
        .toList());
  }

  /// Creates a new notification
  Future<void> createNotification({
    required String swapId,
    required String senderId,
    required String senderName,
    required String senderAvatarUrl,
    required String recipientId,
    required String text,
  }) async {
    print('DEBUG - NotificationService.createNotification called with:');
    print('Swap ID: $swapId');
    print('Sender ID: $senderId');
    print('Sender Name: $senderName');
    print('Sender Avatar: $senderAvatarUrl');
    print('Recipient ID: $recipientId');
    print('Text: $text');

    try {
      final ref = await _db
          .collection('swaps')
          .doc(swapId)
          .collection('notifications')
          .add({
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatarUrl': senderAvatarUrl.isNotEmpty
            ? senderAvatarUrl
            : 'https://i.imgur.com/BoN9kdC.png',
        'recipientId': recipientId,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
      print('DEBUG - Notification document created with ID: ${ref.id}');

      // Verify the notification was created
      final doc = await ref.get();
      print('DEBUG - Created notification data:');
      print(doc.data());
    } catch (e) {
      print('DEBUG - Error in createNotification:');
      print(e);
      rethrow;
    }
  }

  /// Streams notification summaries for the current user
  Stream<List<SwapNotificationSummary>> streamSummaries(String userId) {
    print('Starting streamSummaries for user: $userId');

    // Get all swaps where the user is either owner or borrower
    final swapsQuery = _db.collection('swaps').where(Filter.or(
          Filter('ownerId', isEqualTo: userId),
          Filter('borrowerId', isEqualTo: userId),
        ));

    print('Created swaps query for user: $userId');

    // First, get the stream of all relevant swaps
    return swapsQuery.snapshots().switchMap((swapSnap) {
      print('Got swaps snapshot with ${swapSnap.docs.length} swaps');

      // If there are no swaps, return an empty list immediately
      if (swapSnap.docs.isEmpty) {
        print('No swaps found for user: $userId');
        return Stream.value(<SwapNotificationSummary>[]);
      }

      // For each swap, create a stream of its notifications
      final notificationStreams = swapSnap.docs.map((swapDoc) {
        print('Creating notification stream for swap: ${swapDoc.id}');

        // Simplified query: just get all notifications for this recipient
        return _db
            .collection('swaps')
            .doc(swapDoc.id)
            .collection('notifications')
            .where('recipientId', isEqualTo: userId)
            .snapshots()
            .map((notesSnap) {
          if (notesSnap.docs.isEmpty) return null;

          // Sort locally to avoid complex index requirements
          final sortedDocs = notesSnap.docs.toList()
            ..sort((a, b) {
              final aTime = (a.data()['createdAt'] as Timestamp).toDate();
              final bTime = (b.data()['createdAt'] as Timestamp).toDate();
              return bTime.compareTo(aTime); // descending
            });

          final latestNote = sortedDocs.first.data();
          final unreadCount =
              sortedDocs.where((doc) => doc.data()['read'] == false).length;

          return SwapNotificationSummary(
            swapId: swapDoc.id,
            senderId: latestNote['senderId'],
            senderName: latestNote['senderName'],
            senderAvatarUrl: latestNote['senderAvatarUrl'],
            lastMessage: latestNote['text'],
            lastTimestamp: (latestNote['createdAt'] as Timestamp).toDate(),
            unreadCount: unreadCount,
          );
        });
      }).toList();

      print('Created ${notificationStreams.length} notification streams');

      // Combine all notification streams
      return Rx.combineLatest(notificationStreams,
          (List<SwapNotificationSummary?> summaries) {
        final filteredSummaries = summaries
            .where((s) => s != null)
            .cast<SwapNotificationSummary>()
            .toList();
        print(
            'Combined streams, found ${filteredSummaries.length} notifications');
        return filteredSummaries;
      });
    });
  }

  /// Marks a notification as read
  Future<void> markAsRead(String swapId, String notificationId) {
    return _db
        .collection('swaps')
        .doc(swapId)
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true});
  }

  Future<void> markNotificationsAsRead(String swapId, String userId) async {
    try {
      // Get all unread notifications for this swap
      final notificationsRef = _db
          .collection('swaps')
          .doc(swapId)
          .collection('notifications')
          .where('recipientId', isEqualTo: userId)
          .where('read', isEqualTo: false);

      // Get the notifications that need to be updated
      final notifications = await notificationsRef.get();

      print(
          'Found ${notifications.docs.length} unread notifications to update');

      // Update each notification
      final batch = _db.batch();
      for (var doc in notifications.docs) {
        batch.update(doc.reference, {'read': true});
      }

      // Commit the batch
      await batch.commit();
      print('Successfully marked notifications as read');
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }
}
