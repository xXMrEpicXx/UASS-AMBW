import 'package:cloud_firestore/cloud_firestore.dart';

class Mood {
  final String id;
  final String emoji;
  final String? note;
  final Timestamp timestamp;

  Mood({required this.id, required this.emoji, this.note, required this.timestamp});

  // Factory constructor untuk membuat instance Mood dari data Firestore
  factory Mood.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Mood(
      id: doc.id,
      emoji: data['emoji'] ?? '😊',
      note: data['note'],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}