import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mood_jurnal/screens/auth_gate.dart';
import 'package:mood_jurnal/services/auth_service.dart';
import 'package:mood_jurnal/screens/get_started_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

// Variabel global untuk menampung status first launch
bool isFirstTime = true;

void main() async {
  // Pastikan semua binding Flutter sudah siap sebelum menjalankan kode lain
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cek Shared Preferences untuk Get Started Screen
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Sediakan AuthService ke seluruh widget tree
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Mood Journal',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        // Tentukan halaman awal berdasarkan status isFirstTime
        home: isFirstTime ? const GetStartedScreen() : const AuthGate(),
      ),
    );
  }
}
