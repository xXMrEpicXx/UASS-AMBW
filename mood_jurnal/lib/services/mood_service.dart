import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood.dart';

class MoodService {
  final String? uid;
  final CollectionReference moodCollection =
      FirebaseFirestore.instance.collection('moods');

  MoodService({required this.uid});

  Future<void> addMood(Mood mood) async {
    await moodCollection.add(mood.toMap());
  }

  Stream<List<Mood>> getUserMoods() {
    return moodCollection
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Mood.fromDocument(doc)).toList());
  }
}
