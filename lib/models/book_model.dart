import 'package:cloud_firestore/cloud_firestore.dart';

enum BookStatus {
  available,
  requested,
  onLoan,
}

BookStatus _statusFromString(String s) => BookStatus.values
    .firstWhere((e) => e.name == s, orElse: () => BookStatus.available);

/// A single book in ReBooked
class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final String location;
  final String coverUrl; // network or local asset
  final String ownerId;
  final String ownerName;
  final String ownerAvatarUrl; // network or asset path
  final BookStatus status;
  final String? requestedById; // who’s requested it (if any)
  final String? loanedToId; // who’s currently borrowing it
  final DateTime? dueDate; // optional
  final String? description; // for detail screen
  final String? notes; // user can attach arbitrary notes on upload

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.location,
    required this.coverUrl,
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatarUrl,
    this.status = BookStatus.available,
    this.requestedById,
    this.loanedToId,
    this.dueDate,
    this.description,
    this.notes,
  });

 factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Book(
    id: doc.id,
    title: data['title'] as String? ?? '',
    author: data['author'] as String? ?? '',
    genre: data['genre'] as String? ?? '',
    location: data['location'] as String? ?? '',
    coverUrl: data['coverUrl'] as String? ?? '',
    ownerId: data['ownerId'] as String? ?? '',
    ownerName: data['ownerName'] as String? ?? '',
    ownerAvatarUrl: data['ownerAvatarUrl'] as String? ?? '',
    status: _statusFromString(data['status'] as String? ?? ''),
    requestedById: data['requestedById'] as String?,
    loanedToId: data['loanedToId'] as String?,
    dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
    description: data['description'] as String?,
    notes: data['notes'] as String?,
  );
}


  /// Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'genre': genre,
      'location': location,
      'coverUrl': coverUrl,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerAvatarUrl': ownerAvatarUrl,
      'status': status.name,
      'requestedById': requestedById,
      'loanedToId': loanedToId,
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
      'description': description,
      'notes': notes,
    };
  }

  /// 🔥 Add this factory to fix your error
  factory Book.fromDocument(DocumentSnapshot doc) {
    return Book.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
  }
}
