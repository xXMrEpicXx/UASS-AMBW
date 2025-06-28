import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mood_jurnal/models/mood.dart';
import 'package:mood_jurnal/services/auth_service.dart';
import 'package:mood_jurnal/services/mood_service.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class MoodChoice {
  final String emoji;
  final String label;

  const MoodChoice({required this.emoji, required this.label});
}

class _HomeScreenState extends State<HomeScreen> {
  late final MoodService _moodService;
  final AuthService _authService = AuthService();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedMoodEmoji;

  final List<MoodChoice> _moodChoices = [
    const MoodChoice(emoji: '😄', label: 'Senang'),
    const MoodChoice(emoji: '😊', label: 'Baik'),
    const MoodChoice(emoji: '😐', label: 'Biasa'),
    const MoodChoice(emoji: '😔', label: 'Sedih'),
    const MoodChoice(emoji: '😡', label: 'Marah'),
    const MoodChoice(emoji: '😴', label: 'Lelah'),
  ];

  @override
  void initState() {
    super.initState();
    final user = _authService.currentUser;
    _moodService = MoodService(uid: user?.uid);
  }

  void _saveMood() async {
    if (_selectedMoodEmoji == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih mood kamu terlebih dahulu!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final user = _authService.currentUser;
    if (user == null) return;

    try {
      final newMood = Mood(
        mood: _selectedMoodEmoji!,
        notes: _notesController.text,
        timestamp: Timestamp.now(),
        userId: user.uid,
      );

      await _moodService.addMood(newMood);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mood berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _selectedMoodEmoji = null;
        _notesController.clear();
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan mood: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal Mood'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
            tooltip: 'Riwayat Mood',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Halo, ${user?.displayName ?? user?.email ?? 'Sobat'}!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bagaimana perasaanmu hari ini?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: _moodChoices.length,
                itemBuilder: (context, index) {
                  final mood = _moodChoices[index];
                  final isSelected = _selectedMoodEmoji == mood.emoji;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMoodEmoji = mood.emoji;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: Colors.teal, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mood.emoji,
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(height: 8),
                          Text(mood.label),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _saveMood,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Mood'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
