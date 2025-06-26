import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_jurnal/models/mood_model.dart';
import 'package:mood_jurnal/services/auth_service.dart';
import 'package:mood_jurnal/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _noteController = TextEditingController();
  String _selectedEmoji = '😊';

  void _showAddMoodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bagaimana perasaanmu hari ini?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['😊', '😔', '😡', '😄', '😢'].map((emoji) {
                  return GestureDetector(
                    onTap: () {
                       // Untuk update UI di dalam dialog, kita perlu state management yang lebih kompleks
                       // atau menggunakan StatefulBuilder. Untuk simplicity, kita set di luar.
                       // Ini adalah contoh sederhana.
                       setState(() {
                         _selectedEmoji = emoji;
                       });
                       // Tutup dan buka lagi untuk refresh (cara sederhana)
                       Navigator.of(context).pop();
                       _showAddMoodDialog();

                    },
                    child: Text(emoji, style: const TextStyle(fontSize: 30)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Text("Terpilih: $_selectedEmoji", style: const TextStyle(fontSize: 20)),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(hintText: 'Tambahkan catatan (opsional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await _firestoreService.addMood(user.uid, _selectedEmoji, _noteController.text);
                  _noteController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal Mood'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Silakan login terlebih dahulu.'))
          : StreamBuilder<List<Mood>>(
              stream: _firestoreService.getMoods(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada catatan mood. Tambahkan sekarang!'));
                }

                final moods = snapshot.data!;
                return ListView.builder(
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    return ListTile(
                      leading: Text(mood.emoji, style: const TextStyle(fontSize: 30)),
                      title: Text(mood.note ?? 'Tanpa catatan'),
                      subtitle: Text(DateFormat('d MMMM yyyy, HH:mm').format(mood.timestamp.toDate())),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMoodDialog,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Mood',
      ),
    );
  }
}
