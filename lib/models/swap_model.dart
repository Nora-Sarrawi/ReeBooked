import 'package:cloud_firestore/cloud_firestore.dart';

enum SwapStatus { pending, accepted, declined }

class Swap {
  final String id;
  final String ownerBookId;
  final String borrowerBookId;
  final String ownerId;
  final String borrowerId;
  final SwapStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Swap({
    required this.id,
    required this.ownerBookId,
    required this.borrowerBookId,
    required this.ownerId,
    required this.borrowerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /* Firestore → Dart */
  factory Swap.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final j = d.data()!;
    return Swap(
      id: d.id,
      ownerBookId: j['ownerBookId'],
      borrowerBookId: j['borrowerBookId'],
      ownerId: j['ownerId'],
      borrowerId: j['borrowerId'],
      status: SwapStatus.values.byName(j['status']),
      createdAt: (j['createdAt'] as Timestamp).toDate(),
      updatedAt: (j['updatedAt'] as Timestamp).toDate(),
    );
  }

  /* Dart → Firestore (on create) */
  Map<String, dynamic> toJson() => {
        'ownerBookId': ownerBookId,
        'borrowerBookId': borrowerBookId,
        'ownerId': ownerId,
        'borrowerId': borrowerId,
        'status': status.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
