import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_jurnal/models/mood_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Tambah Mood baru berdasarkan UID user
  Future<void> addMood(String uid, String emoji, String? note) async {
    await _db.collection('users').doc(uid).collection('moods').add({
      'emoji': emoji,
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // Ambil stream (real-time) data mood untuk user tertentu
  Stream<List<Mood>> getMoods(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('moods')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Mood.fromFirestore(doc)).toList());
  }
}
