import 'package:cloud_firestore/cloud_firestore.dart';

class Mood {
  final String mood;
  final String notes;
  final Timestamp timestamp;
  final String userId;

  Mood({
    required this.mood,
    required this.notes,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'mood': mood,
      'notes': notes,
      'timestamp': timestamp,
      'userId': userId,
    };
  }

  factory Mood.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Mood(
      mood: data['mood'] ?? '',
      notes: data['notes'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userId: data['userId'] ?? '',
    );
  }
}
