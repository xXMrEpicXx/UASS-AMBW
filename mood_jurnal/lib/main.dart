// (Bagian atas file Anda tidak perlu diubah, sudah benar)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home.dart';
import 'package:mood_jurnal/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Inisialisasi untuk format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Jurnal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // --- PERUBAHAN KECIL: Menggunakan warna tema yang konsisten ---
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
    );
  }
}


// --- PERUBAHAN UTAMA DI SINI ---
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Saat menunggu koneksi ke Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 2. (TAMBAHAN) Jika terjadi error saat koneksi
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Terjadi kesalahan. Periksa koneksi Anda.'),
            ),
          );
        }

        // 3. Jika pengguna berhasil login (data ada)
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        
        // 4. Jika tidak ada pengguna yang login
        return LoginScreen();
      },
    );
  }
}
