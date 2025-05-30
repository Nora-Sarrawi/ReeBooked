import 'package:cloud_firestore/cloud_firestore.dart';

class SwapService {
  final _swaps = FirebaseFirestore.instance.collection('swaps');
  final _books = FirebaseFirestore.instance.collection('books');

  /* Borrower → Request */
  Future<String> requestSwap({
    required String ownerBookId,
    required String borrowerBookId,
    required String ownerId,
    required String borrowerId,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    // 1. swap doc
    final swapRef = _swaps.doc();
    batch.set(swapRef, {
      'ownerBookId': ownerBookId,
      'borrowerBookId': borrowerBookId,
      'ownerId': ownerId,
      'borrowerId': borrowerId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 2. mark borrower’s book as requested
    batch.update(_books.doc(borrowerBookId), {'status': 'requested'});

    await batch.commit();
    return swapRef.id;
  }

  /* Owner → Accept */
  Future<void> acceptSwap({
    required String swapId,
    required String ownerBookId,
    required String borrowerBookId,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    batch.update(_swaps.doc(swapId), {
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(_books.doc(ownerBookId), {'status': 'onLoan'});
    batch.update(_books.doc(borrowerBookId), {'status': 'onLoan'});

    await batch.commit();
  }

  /* Owner Declines  OR Borrower Cancels */
  Future<void> declineSwap({
    required String swapId,
    required String ownerBookId,
    required String borrowerBookId,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    batch.update(_swaps.doc(swapId), {
      'status': 'declined',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    batch.update(_books.doc(ownerBookId), {'status': 'available'});
    batch.update(_books.doc(borrowerBookId), {'status': 'available'});

    await batch.commit();
  }

  /* Optional: add note / chat bubble */
  Future<void> addNote(
      {required String swapId, required String uid, required String text}) {
    return _swaps.doc(swapId).collection('notes').add({
      'authorId': uid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp()
    });
  }
}
