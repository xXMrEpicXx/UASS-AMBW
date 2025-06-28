import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_jurnal/models/mood.dart';
import 'package:mood_jurnal/services/auth_service.dart';
import 'package:mood_jurnal/services/mood_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final moodService = MoodService(uid: user?.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Mood'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Mood>>(
        stream: moodService.getUserMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada mood yang dicatat.'));
          }

          final moods = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              final formattedDate = DateFormat('dd MMM yyyy – HH:mm')
                  .format(mood.timestamp.toDate());

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Text(
                    mood.mood,
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text(mood.notes),
                  subtitle: Text(formattedDate),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
